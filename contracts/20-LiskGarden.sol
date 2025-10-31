// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LiskGarden {
    // 1. Data Types
    enum GrowthStage {
        SEED,
        SPROUT,
        GROWING,
        BLOOMING
    }

    struct Plant {
        address owner;
        GrowthStage stage;
        uint256 plantedDate;
        uint256 lastWatered;
        uint8 waterLevel;
        bool exist;
        bool isDead;
    }

    // 2. State
    mapping(uint256 => Plant) plants;
    mapping(address => uint256[]) userPlants;
    uint256 plantCounter;
    address owner;

    // 3. Constants
    uint256 public constant PLANT_PRICE = 0.001 ether;
    uint256 public constant HARVEST_REWARD = 0.003 ether;
    uint256 public constant STAGE_DURATION = 1 minutes;
    uint256 public constant WATER_DEPLETION_TIME = 30 seconds;
    uint256 public constant WATER_DEPLETION_RATE = 2;

    // 4. Events
    event PlantSeeded(address indexed owner, uint256 indexed plantId);
    event PlantWatered(uint256 indexed plantId, uint8 newWaterLevel);
    event PlantHarvested(
        uint256 indexed plantId,
        address indexed owner,
        uint256 reward
    );
    event StageAdvanced(uint256 indexed plantId, GrowthStage newStage);
    event PlantDied(uint256 indexed plantId);

    // + Modifier
    modifier onlyPlantOwner(uint256 _plantId) {
        require(plants[_plantId].owner == msg.sender, "Bukan owner");
        _;
    }

    // 5. Constructor
    constructor() {
        owner = msg.sender;
    }

    // 6. Main Functions (6 functions)
    // [1]
    function plantSeed() external payable returns (uint256) {
        require(msg.value >= PLANT_PRICE, "Saldo tidak mencukupi");

        plantCounter += 1;
        uint256 newPlantId = plantCounter; // Gunakan variabel lokal untuk Plant ID baru

        plants[newPlantId] = Plant({
            owner: msg.sender,
            stage: GrowthStage.SEED,
            plantedDate: block.timestamp,
            lastWatered: block.timestamp,
            waterLevel: 100,
            exist: true,
            isDead: false
        });

        userPlants[msg.sender].push(newPlantId);

        emit PlantSeeded(msg.sender, newPlantId);

        return newPlantId; // Mengembalikan ID baru
    }

    // [2]
    function calculateWaterLevel(uint256 _plantId) public view returns (uint8) {
        Plant storage plant = plants[_plantId];

        if (!plant.exist || plant.isDead) {
            return 0;
        }

        uint256 timeSinceWatered = block.timestamp - plant.lastWatered;
        uint256 depletionIntervals = timeSinceWatered / WATER_DEPLETION_TIME;
        uint256 waterLost = depletionIntervals * WATER_DEPLETION_RATE;

        if (waterLost >= plant.waterLevel) {
            return 0;
        }

        return plant.waterLevel - uint8(waterLost);
    }

    // [3]
    function updateWaterLevel(uint256 _plantId) internal {
        Plant storage plant = plants[_plantId];

        uint256 timeSinceWatered = block.timestamp - plant.lastWatered;
        uint256 depletionIntervals = timeSinceWatered / WATER_DEPLETION_TIME;

        if (depletionIntervals > 0) {
            uint8 currentWater = calculateWaterLevel(_plantId);

            plant.waterLevel = currentWater;
            plant.lastWatered =
                plant.lastWatered +
                (depletionIntervals * WATER_DEPLETION_TIME);

            if (currentWater == 0 && !plant.isDead) {
                plant.isDead = true;
                emit PlantDied(_plantId);
            }
        }
    }

    // [4]
    function waterPlant(uint256 _plantId) external onlyPlantOwner(_plantId) {
        Plant storage plant = plants[_plantId];

        require(plant.exist, "Tidak ada plant");
        require(!plant.isDead, "Plant sudah mati");

        plant.waterLevel = 100;
        plant.lastWatered = block.timestamp;

        emit PlantWatered(_plantId, plant.waterLevel);

        updatePlantStage(_plantId);
    }

    // [5]
    function updatePlantStage(uint256 _plantId) public {
        Plant storage plant = plants[_plantId];

        require(plant.exist, "Tidak ada plant");

        updateWaterLevel(_plantId);

        if (plant.isDead) {
            return;
        }

        GrowthStage oldStage = plant.stage;

        if (plant.stage != GrowthStage.BLOOMING) {
            uint256 timeSincePlanted = block.timestamp - plant.plantedDate;

            // SEED -> SPROUT (1 * STAGE_DURATION)
            if (
                plant.stage == GrowthStage.SEED &&
                timeSincePlanted >= STAGE_DURATION
            ) {
                plant.stage = GrowthStage.SPROUT;
            }
            // SPROUT -> GROWING (2 * STAGE_DURATION)
            else if (
                plant.stage == GrowthStage.SPROUT &&
                timeSincePlanted >= (STAGE_DURATION * 2)
            ) {
                plant.stage = GrowthStage.GROWING;
            }
            // GROWING -> BLOOMING (3 * STAGE_DURATION)
            else if (
                plant.stage == GrowthStage.GROWING &&
                timeSincePlanted >= (STAGE_DURATION * 3)
            ) {
                plant.stage = GrowthStage.BLOOMING;
            }
        }

        if (plant.stage != oldStage) {
            emit StageAdvanced(_plantId, plant.stage);
        }
    }

    // [6]
    function harvestPlant(uint256 _plantId) external onlyPlantOwner(_plantId) {
        Plant storage plant = plants[_plantId];

        require(plant.exist, "Tidak ada plant");
        require(!plant.isDead, "Plant sudah mati");

        updatePlantStage(_plantId);
        require(plant.stage == GrowthStage.BLOOMING, "Belum BLOOMING");

        plant.exist = false;

        emit PlantHarvested(_plantId, plant.owner, HARVEST_REWARD);

        (bool success, ) = msg.sender.call{value: HARVEST_REWARD}("");
        require(success, "Transfer reward gagal.");
    }

    // 7. Helper Functions (3 functions)
    // [1]
    function getPlant(uint256 _plantId) external view returns (Plant memory) {
        Plant memory plant = plants[_plantId];

        require(plants[_plantId].exist, "Tidak ada plant");
        plant.waterLevel = calculateWaterLevel(_plantId);

        return plant;
    }

    // [2]
    function getUserPlants(
        address user
    ) external view returns (uint256[] memory) {
        return userPlants[user];
    }

    // [3]
    function withdraw() external {
        require(msg.sender == owner, "Bukan Owner");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdraw tidak berhasil");
    }

    // 8. Receive ETH
    receive() external payable {}
}
