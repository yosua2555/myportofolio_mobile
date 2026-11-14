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

### Tugas 7

1. **Apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget?**
   *Widget tree* adalah struktur hierarki berbentuk pohon yang merepresentasikan seluruh elemen antarmuka pengguna (UI) dalam aplikasi Flutter, mulai dari *root widget* hingga komponen terkecil seperti teks atau ikon. Hubungan *parent-child* bekerja melalui komposisi: *parent widget* membungkus satu (`child`) atau beberapa (`children`) *child widget*, lalu meneruskan batasan ukuran (*constraints*), tema, maupun konfigurasi posisi ke bawah, sementara *child widget* menentukan ukurannya sendiri berdasarkan batasan tersebut untuk kemudian diposisikan oleh *parent*-nya.

2. **Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!**
   * `MyApp` (`StatelessWidget`): *Root widget* aplikasi yang membungkus keseluruhan konfigurasi aplikasi.
   * `MaterialApp`: Menyediakan konfigurasi dasar Material Design seperti tema (`ThemeData`), judul aplikasi, dan halaman awal (`home`).
   * `MyHomePage` (`StatelessWidget`): Widget utama untuk halaman beranda portofolio.
   * `Scaffold`: Kerangka tata letak standar halaman Material Design yang menyediakan area `appBar`, `body`, dan wadah tampilan `SnackBar`.
   * `AppBar`: Bilah judul pada bagian paling atas layar.
   * `SingleChildScrollView`: Memungkinkan konten halaman digulir (*scroll*) secara vertikal agar tidak terjadi *overflow* pada layar berukuran kecil.
   * `Column`: Menyusun beberapa widget anak secara vertikal dari atas ke bawah.
   * `Row`: Menyusun beberapa widget anak secara horizontal dari kiri ke kanan.
   * `Container`: Kotak serbaguna untuk mengatur *padding*, lebar/tinggi, dan dekorasi visual (`BoxDecoration` seperti warna latar, sudut melengkung, dan garis tepi).
   * `Padding`: Memberikan jarak ruang di sekeliling widget anaknya.
   * `SizedBox`: Memberikan jarak kosong tetap antar-widget.
   * `Expanded`: Membagi ruang tersisa di dalam `Row` secara proporsional untuk ketiga kartu informasi.
   * `Text`: Menampilkan untaian teks dengan pengaturan gaya (`TextStyle`).
   * `Icon`: Menampilkan ikon grafis bawaan Material Icons.
   * `GridView.count`: Menampilkan daftar tombol menu dalam tata letak kisi (*grid*) berjumlah 3 kolom.
   * `InfoCard` (`StatelessWidget`): Widget kustom untuk menampilkan informasi identitas (`NPM`, `Name`, dan `Class`).
   * `ItemCard` (`StatelessWidget`): Widget kustom untuk menampilkan kartu tombol menu aksi portofolio.
   * `Material`: Memberikan permukaan berbasis Material Design (warna latar, elevasi bayangan, dan bentuk sudut membulat) pada `ItemCard`.
   * `InkWell`: Memberikan respons sentuhan (*onTap*) beserta efek riak air (*ripple effect*) pada `ItemCard`.
   * `SnackBar`: Notifikasi singkat yang muncul di bagian bawah layar saat tombol menu ditekan.

3. **Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!**
   `MaterialApp` berfungsi untuk membungkus seluruh aplikasi dengan sistem desain Google Material Design, mengatur tema warna global (`ThemeData`), navigasi antarhalaman (`Navigator`), lokalisasi, serta menyediakan konteks dasar yang dibutuhkan widget-widget Material seperti `Scaffold` dan `ScaffoldMessenger` (untuk `SnackBar`). Widget ini digunakan sebagai *root widget* agar seluruh turunan widget di bawahnya mewarisi tema, tipografi, dan sistem navigasi yang seragam tanpa perlu dikonfigurasi ulang di setiap halaman.

4. **Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?**
   `StatelessWidget` adalah widget yang bersifat statis (*immutable*), artinya tampilan UI-nya tidak berubah setelah dibangun kecuali menerima data baru dari *parent*-nya. Sebaliknya, `StatefulWidget` memiliki objek `State` terpisah yang dapat berubah secara dinamis selama siklus hidup widget, dan memanggil `setState()` akan memicu render ulang UI sesuai data terbaru. Kita memilih `StatelessWidget` untuk tampilan yang murni menampilkan data tetap (seperti kartu profil atau tombol navigasi statis), dan menggunakan `StatefulWidget` ketika komponen perlu merespons interaksi yang mengubah data tampilan secara langsung (seperti *counter*, *form input*, atau *toggle* tema).

5. **Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?**
   `BuildContext` adalah objek referensi yang menandai lokasi spesifik sebuah widget di dalam struktur *widget tree*. Objek ini sangat penting karena menjadi penghubung bagi widget untuk mengakses data atau konfigurasi dari *ancestor widget* (induk di atasnya) tanpa harus mengoper parameter secara manual satu per satu. Di dalam metode `build(BuildContext context)`, `context` digunakan untuk mengambil konfigurasi tema aplikasi seperti `Theme.of(context).colorScheme.primary` pada `AppBar`, serta mencari `ScaffoldMessenger.of(context)` untuk menampilkan `SnackBar` di halaman aktif.

6. **Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?**
   *Hot reload* menyuntikkan (*inject*) kode Dart yang baru diubah ke dalam Dart Virtual Machine (DVM) yang sedang berjalan dan membangun ulang *widget tree* dalam hitungan detik tanpa menghapus *state* (data) aplikasi saat ini. Sebaliknya, *hot restart* memuat ulang seluruh kode aplikasi dari awal dan mereset semua *state* kembali ke nilai awal. Kita tidak bisa hanya mengandalkan *hot reload*—dan harus melakukan *hot restart* atau *full restart*—ketika mengubah struktur kelas utama, variabel global, inisialisasi di dalam `main()` atau `initState()`, maupun saat menambahkan *dependency/package* dan aset baru di `pubspec.yaml`.

#### AI Disclosure
* **Tools yang digunakan:** Gemini.
* **Bagian yang dibantu AI:** Penyusunan struktur variasi warna `ItemHomepage`, peningkatan tata letak UI/UX pada `lib/menu.dart` (*header banner* dan *grid* kartu), serta peninjauan konsep untuk pertanyaan reflektif.
* **Proses verifikasi & penyesuaian manual:** Menguji seluruh perubahan secara lokal melalui `flutter run` dan memverifikasi tidak ada peringatan sintaks menggunakan `flutter analyze` sebelum melakukan *commit* bertahap ke GitHub.