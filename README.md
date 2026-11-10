# MyPortfolio Mobile (myportofolio_mobile)

Aplikasi mobile portofolio pribadi berbasis Flutter untuk mata kuliah Pemrograman Berbasis Platform (CSGE602022) - Fasilkom Universitas Indonesia, Semester Gasal 2026/2027.

---

## 👤 Informasi Mahasiswa
* **Nama** : Yosua Peitho Purba
* **NPM** : 2506657402
* **Kelas** : PBP D

---

## 📱 Tentang Proyek
Proyek ini merupakan klien aplikasi *mobile* multiplatform yang dibangun menggunakan **Flutter** dan bahasa **Dart**. Aplikasi ini berfungsi sebagai antarmuka *mobile* bagi portofolio pribadi (`myportofolio`), yang nantinya akan diintegrasikan dengan REST API Django REST Framework (DRF) yang telah dibangun pada Tutorial 07.

Pada **Tutorial 08**, aplikasi ini menampilkan halaman beranda statis portofolio dengan identitas pemilik dan kisi-kisi tombol menu aksi yang interaktif.

---

## ✨ Fitur & Komponen yang Diimplementasikan
1. **Pemisahan Struktur Kode (*Separation of Concerns*)**:
   - Memisahkan logika bootstrap/tema utama di `lib/main.dart` dengan kode tampilan halaman antarmuka di `lib/menu.dart`.
2. **Kustomisasi Tema Material 3**:
   - Menggunakan `ColorScheme.fromSeed` dengan warna dasar `Colors.indigo` dan warna sekunder `Colors.amber[700]` pada kartu tombol aksi.
3. **Stateless Widget Halaman (`MyHomePage`)**:
   - Mengubah widget halaman utama dari `StatefulWidget` menjadi `StatelessWidget` untuk performa rendering statis yang lebih ringan dan efisien.
4. **Reusable Widget - `InfoCard`**:
   - Menampilkan ringkasan identitas (NPM, Nama, Kelas) secara horizontal dengan layout `Row` dan `MediaQuery`.
5. **Model Data & Reusable Widget - `ItemCard`**:
   - Model data `ItemHomepage` merepresentasikan setiap tombol menu (*Lihat Proyek*, *Tambah Proyek*, *Logout*) beserta ikonnya.
   - Widget `ItemCard` menggunakan `Material` dan `InkWell` untuk efek sentuhan (*ripple effect*).
6. **Integrasi Widget Tree & Tata Letak Responsif**:
   - Menggabungkan `Scaffold`, `AppBar`, `Padding`, `Column`, `Row`, dan `GridView.count(crossAxisCount: 3)` yang fleksibel dengan `shrinkWrap: true`.
7. **Feedback Pengguna (*SnackBar*)**:
   - Menampilkan notifikasi `SnackBar` interaktif ketika salah satu tombol menu ditekan: `"Kamu telah menekan tombol <nama_tombol>!"`.

---

## 🚀 Cara Menjalankan Aplikasi
1. Pastikan Flutter SDK telah terpasang di komputer dan terdaftar pada *environment variable* `PATH`.
2. Buka terminal pada root folder proyek ini:
   ```bash
   cd myportofolio_mobile
   ```
3. Unduh seluruh dependensi Flutter:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi pada peramban Google Chrome:
   ```bash
   flutter run -d chrome
   ```
   Atau pada emulator Android / perangkat fisik:
   ```bash
   flutter run
   ```
5. Periksa kualitas dan kepatuhan sintaks kode:
   ```bash
   flutter analyze
   ```
