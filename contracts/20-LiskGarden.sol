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
        uint256 id;
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
    uint256 constant PLANT_PRICE = 0.001 ether;
    uint256 constant HARVEST_REWARD = 0.003 ether;
    uint256 constant STAGE_DURATION = 1 minutes;
    uint256 constant WATER_DEPLETION_TIME = 30 seconds;
    uint256 constant WATER_DEPLETION_RATE = 2;

    // 4. Events
    event PlantSeeded(address indexed owner, uint256 indexed plantId);
    event PlantWatered(uint256 indexed plantId, uint8 newWaterLevel);
    event PlantHarvested(uint256 indexed plantId, address indexed owner, uint256 reward);
    event StageAdvanced(uint256 indexed plantId, GrowthStage newStage);
    event PlantDied(uint256 indexed plantId);

    // 5. Constructor
    constructor() {
        owner = msg.sender;
    }

    // 6. Main Functions (8 functions)
    function plantSeed() external payable returns (uint256){
        require(msg.value >= PLANT_PRICE, "Saldo tidak mencukupi");

        plantCounter += 1;

        plants[plantCounter] = Plant({
            id: plantCounter,
            stage:  GrowthStage.SEED,
            plantedDate: block.timestamp,
            lastWatered: block.timestamp,
            waterLevel: 100,
            exist: true,
            isDead: false
        });

        userPlants[msg.sender].push(plantCounter);

        emit PlantSeeded(owner, plantCounter);

        return plants[plantCounter].id;
    }

    function calculateWaterLevel(uint256 plantId) public view returns (uint8){
        if(plants[plantId].exist == false || plants[plantId].isDead){
            return 0;
        }
        uint256 timeSinceWatered = block.timestamp - plants[plantId].lastWatered;
        
        uint256 depletionIntervals = timeSinceWatered / WATER_DEPLETION_TIME;

        uint256 waterLost = depletionIntervals * WATER_DEPLETION_RATE;

        return plants[plantId].waterLevel - uint8(waterLost);
    }

    function updateWaterLevel(uint256 plantId) internal{
        Plant storage plant = plants[plantId];
            uint8 currentWater = calculateWaterLevel(plantId);

            plant.waterLevel = currentWater;
            plant.lastWatered = block.timestamp;

            if (currentWater == 0 && !plant.isDead) {
                plant.isDead = true;
                emit PlantDied(plantId);
            }
    }

    function waterPlant(uint256 plantId) external {
        Plant storage plant = plants[plantId];

        if(plant.exist && msg.sender == owner && !plant.isDead){
            plant.waterLevel = 100;
            plant.lastWatered = block.timestamp;

            emit PlantWatered(plantId, plant.waterLevel);
            updatePlantStage(plantId);
        }
    }

    function updatePlantStage(uint256 plantId) public {
        Plant storage plant = plants[plantId];
        if(plant.stage == GrowthStage.SEED){
            plant.stage = GrowthStage.SPROUT;
        } else if (plant.stage == GrowthStage.SPROUT) {
            plant.stage = GrowthStage.GROWING;
        } else if (plant.stage == GrowthStage.GROWING){
            plant.stage == GrowthStage.BLOOMING;
        } else if (plant.stage == GrowthStage.BLOOMING) {
            plant.stage == GrowthStage.BLOOMING;
        }
    }

    function harvestPlant(uint256 plantId) external {
        Plant storage plant = plants[plantId];
        if(plant.exist && msg.sender == owner && !plant.isDead){
            updatePlantStage(plantId);

            require(plant.stage == GrowthStage.BLOOMING, "Belum di Stage Blooming");

            plant.exist = false;

            emit PlantHarvested(plantId, owner, HARVEST_REWARD);

            (bool success, ) = msg.sender.call{value: HARVEST_REWARD}("");

            require(success, "Transfer reward gagal.");
        }
    }

    // 7. Helper Functions (3 functions)
    function getPlant(uint256 plantId) external view returns (Plant memory){
        Plant memory plant = plants[plantId];
        if (plant.exist) {
            plant.waterLevel = calculateWaterLevel(plantId);
        }
        return plant;
    }
    function getUserPlants(address userAdr) external view returns (uint256[] memory){
        return userPlants[userAdr];
     }

    function withdraw() external {
        require(msg.sender == owner, "Bukan Owner");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdraw tidak berhasil");
    }

    // 8. Receive ETH
    receive() external payable {}
}