# 📄 Belajar Solidity - Kelas Rutin Batch 4 🎓

Ini adalah repositori yang berisi koleksi **smart contract Solidity** yang dibuat sebagai bagian dari pembelajaran intensif di **Kelas Rutin Batch 4**. Repositori ini berfungsi sebagai panduan praktis dan referensi kode untuk konsep-konsep inti dalam pengembangan smart contract, dengan fokus pada simulasi manajemen "kebun" digital.

---

## 📚 Daftar Isi dan Konsep Pembelajaran

File-file di repositori ini disusun secara progresif, mulai dari tipe data dasar hingga konsep lanjutan seperti transfer Ether, error handling, dan modifier.

### Bagian I: Dasar-Dasar Tipe Data & Struktur Data

| File Name | Konsep Utama | Deskripsi Singkat | Sumber Contoh |
| :--- | :--- | :--- | :--- |
| `01-LearnString.sol` | **`string`** | [cite_start]Deklarasi dan manipulasi variabel tipe `string` untuk menyimpan teks, seperti nama tanaman (`plantName`)[cite: 23, 24, 25, 26]. [cite_start]| [cite: 23, 24, 25, 26] |
| `02-LearnNumber.sol` | **`uint256`** (Angka) | [cite_start]Penggunaan tipe data `uint256` untuk menyimpan bilangan bulat positif (seperti `plantId` dan `waterLevel`) dan operasi aritmatika[cite: 1, 2, 4, 5]. [cite_start]| [cite: 1, 2, 4, 5] |
| `03-LearnBoolean.sol` | **`bool`** (Boolean) | [cite_start]Penggunaan tipe data `bool` (`true`/`false`) untuk manajemen status seperti `isAlive` atau `isBlooming`[cite: 12, 13, 14, 15]. [cite_start]| [cite: 12, 13, 14, 15] |
| `04-LearnAddress.sol` | **`address`** | [cite_start]Mempelajari tipe data `address` untuk identifikasi akun (`owner`, `gardener`), termasuk penggunaan `msg.sender`[cite: 33, 34, 35, 36]. [cite_start]| [cite: 33, 34, 35, 36] |
| `05-SimplePlant.sol` | **State Variables & `constructor`** | [cite_start]Menggabungkan tipe data dasar, mendefinisikan variabel status, inisialisasi nilai dengan `constructor`, dan penggunaan `block.timestamp` untuk menghitung usia (`getAge`)[cite: 17, 18, 19, 20, 21, 22]. [cite_start]| [cite: 17, 18, 19, 20, 21, 22] |
| `06-LearnEnum.sol` | **`enum`** (Enumerasi) | [cite_start]Penggunaan tipe kustom `enum` untuk mendefinisikan status terbatas (`GrowthStage`), dan logika transisi status (`grow`)[cite: 27, 28, 29, 30, 31, 32]. [cite_start]| [cite: 27, 28, 29, 30, 31, 32] |
| `07-LearnStruct.sol` | **`struct`** (Struktur) | [cite_start]Pembuatan tipe data kustom kompleks (`Plant`) untuk mengelompokkan variabel terkait, termasuk `enum`[cite: 6, 7, 8, 9, 10, 11]. [cite_start]| [cite: 6, 7, 8, 9, 10, 11] |
| `08-LearnMapping.sol` | **`mapping`** | [cite_start]Eksplorasi `mapping` untuk membuat asosiasi kunci-nilai, seperti `plantId` ke `waterLevel` atau `owner`[cite: 42, 43, 44, 45]. [cite_start]| [cite: 42, 43, 44, 45] |
| `09-LearnArray.sol` | **`array`** | [cite_start]Penggunaan *dynamic array* (`uint256[]`) untuk menyimpan daftar data sejenis (`allPlantIds`), termasuk fungsi `push`, `length`, dan _getter_[cite: 37, 38, 39, 40, 41]. [cite_start]| [cite: 37, 38, 39, 40, 41] |
| `10-MultiplePlants.sol` | **`mapping` dan `struct`** | [cite_start]Implementasi sistem untuk mengelola banyak objek `Plant` (`struct`) menggunakan `mapping` dan _counter_[cite: 46, 47, 48, 49, 50, 51, 52]. [cite_start]| [cite: 46, 47, 48, 49, 50, 51, 52] |

---

### Bagian II: Kontrol Aliran, Keamanan & Interaksi ETH

| File Name | Konsep Utama | Deskripsi Singkat |
| :--- | :--- | :--- |
| `11-LearnRequire.sol` | **`require()`** | Teknik *error handling* dasar untuk memvalidasi kondisi sebelum eksekusi fungsi (misalnya, memastikan level air cukup). |
| `12-LearnModifier.sol` | **`modifier`** | Pembuatan dan penggunaan *function modifier* (`onlyOwner`) untuk mengontrol akses dan mengurangi duplikasi kode validasi. |
| `13-LearnEvents.sol` | **`event`** | Penggunaan `event` untuk mencatat aktivitas penting *smart contract* ke blockchain agar dapat diakses oleh aplikasi luar (_off-chain_). |
| `14-LearnPayable.sol` | **`payable`** | Mempelajari *modifier* `payable` pada fungsi untuk memungkinkan fungsi menerima **Ether (ETH)** saat dipanggil. |
| `15-LearnSendETH.sol` | **Transfer ETH** | Demonstrasi cara mengirim ETH keluar dari *smart contract* menggunakan metode `.transfer()`. |
| `16-LearnScopes.sol` | **Scopes** | Memahami perbedaan antara *state variable* (variabel status) dan *local variable* (variabel lokal) dalam sebuah *contract*. |
| `17-LearnVisibility.sol` | **Visibility** | Eksplorasi kata kunci visibilitas (`public`, `private`, `internal`, `external`) untuk mengontrol akses fungsi dan variabel. |
| `18-LearnFunctionModifiers.sol` | **View & Pure** | Penggunaan *function modifier* `view` (membaca *state*) dan `pure` (tidak membaca atau menulis *state*) untuk optimalisasi gas. |
| `19-LearnErrorHandling.sol` | **Revert & Custom Error** | Teknik *error handling* lanjutan menggunakan `revert()` dan *Custom Error* untuk memberikan pesan kesalahan yang spesifik dan mengembalikan sisa gas. |
| `20-LiskGarden.sol` | **Final Project/Summary** | Gabungan dari semua konsep (Struct, Mapping, Modifiers, Require, Events, dll.) untuk membangun *smart contract* simulasi kebun/pertanian yang lengkap. |

---

### 🛠️ Prasyarat

Untuk menguji dan berinteraksi dengan smart contract ini, Anda disarankan menggunakan:

1.  **Remix IDE:** Platform pengembangan berbasis *browser* yang cepat untuk kompilasi, deployment, dan pengujian.
2.  **Solidity Compiler:** Versi `^0.8.30` atau yang terbaru.

### 🚀 Cara Menggunakan

1.  **Buka Remix IDE.**
2.  Salin kode dari salah satu file (`01-LearnString.sol` hingga `20-LiskGarden.sol`).
3.  Tempelkan kode ke editor Remix.
4.  Kompilasi kontrak menggunakan versi Solidity yang sesuai.
5.  Deploy kontrak ke lingkungan *JavaScript VM* atau *Testnet* (`Injected Provider`).
6.  Lakukan interaksi dengan fungsi-fungsi yang tersedia untuk melihat bagaimana setiap konsep dasar Solidity bekerja secara langsung.

Selamat Belajar! 🌐
