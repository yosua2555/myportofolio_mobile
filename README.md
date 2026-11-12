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

1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!
Widget tree adalah struktur hierarki (pohon) yang merepresentasikan bagaimana widget-widget dalam aplikasi Flutter disusun. Dalam Flutter, hampir semuanya adalah widget. Hubungan parent-child bekerja dengan cara widget induk (parent) membungkus dan mengontrol tata letak serta batasan widget di dalamnya (child/children). Misalnya, Column (parent) dapat menampung beberapa widget Text (children) dan menyusunnya secara vertikal. Data dan constraints (seperti batasan ukuran) mengalir dari atas (parent) ke bawah (child), sedangkan event (seperti interaksi klik) mengalir dari bawah (child) ke atas (parent).

2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!

MaterialApp: Widget root yang mengonfigurasi tema dasar, navigasi, dan elemen desain Material.

Scaffold: Menyediakan struktur visual dasar layar, seperti tempat untuk AppBar, body, dan SnackBar.

AppBar: Menampilkan navigasi/bar di bagian atas layar aplikasi.

Text: Menampilkan teks string di layar.

Padding: Memberikan ruang kosong (margin/padding) di sekeliling widget anaknya.

Column: Menyusun widget anak-anaknya secara vertikal.

Row: Menyusun widget anak-anaknya secara horizontal.

Center: Memposisikan widget anaknya persis di tengah area yang tersedia.

SizedBox: Memberikan jarak spesifik antar-widget (bisa vertikal atau horizontal).

GridView.count: Menampilkan anak-anaknya dalam bentuk grid/kisi 2D dengan jumlah kolom tertentu.

Card: Wadah visual dengan sudut membulat dan efek bayangan (elevasi).

Container: Kotak serbaguna untuk mengatur ukuran, padding, atau margin dari sebuah widget.

Material: Memberikan canvas dengan properti desain Material seperti warna latar belakang atau efek tinta.

InkWell: Membuat area menjadi interaktif (bisa ditekan/diklik) dan memunculkan efek ripple (gelombang tinta).

Icon: Menampilkan grafis ikon.

SnackBar: Menampilkan pesan pop-up singkat di bagian bawah layar.

3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!
MaterialApp adalah widget praktis yang membungkus beberapa widget yang dibutuhkan untuk aplikasi berdesain Material. Fungsinya adalah untuk mengatur tema global (ThemeData), sistem routing/navigasi halaman, dan localization. Widget ini digunakan sebagai root (akar) karena memastikan semua widget di bawahnya mematuhi standar desain visual (Material Design) dan memiliki akses ke alat navigasi fundamental di seluruh bagian aplikasi.

4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?

StatelessWidget: Widget yang sifatnya statis (tidak bisa berubah). Begitu dirender, UI-nya tidak akan berubah kecuali widget tersebut dihancurkan dan dibuat ulang oleh induknya.

StatefulWidget: Widget yang sifatnya dinamis (bisa berubah). Memiliki objek State internal, dan tampilannya dapat di-update secara real-time dengan memanggil setState() saat ada interaksi pengguna atau aliran data baru.

Kapan memilihnya? Gunakan StatelessWidget untuk UI yang informatif saja dan tidak berubah, seperti label teks, ikon, atau kartu info. Gunakan StatefulWidget saat UI perlu bereaksi dan merubah tampilannya, seperti halaman dengan form input, tombol counter, atau animasi yang sedang berjalan.

5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?
BuildContext adalah "pegangan" (handle) atau referensi lokasi spesifik dari sebuah widget di dalam Widget Tree. Ini sangat penting karena Flutter menggunakannya untuk mengetahui di mana posisi widget tersebut relatif terhadap widget lainnya. Di dalam metode build, BuildContext digunakan untuk mencari informasi atau data dari widget parent/ancestor yang lebih tinggi di tree, misalnya mencari tema saat ini (Theme.of(context)), mencari ukuran layar (MediaQuery.of(context)), atau memanggil fungsi navigasi dan SnackBar (ScaffoldMessenger.of(context)).

6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?

Hot Reload: Memuat (inject) kode yang baru diubah ke dalam Dart Virtual Machine (DVM) yang sedang berjalan, lalu melakukan build ulang UI-nya saja. State (data saat ini) aplikasi tetap dipertahankan (tidak hilang). Proses ini sangat cepat.

Hot Restart: Memuat ulang seluruh kode dari awal dan me-reset semua State ke nilai bawaannya. Lebih lambat dari hot reload tapi lebih cepat dari full restart.

Kapan tidak bisa pakai Hot Reload? Kita harus menggunakan Hot Restart ketika mengubah kode inisialisasi awal (misalnya variabel global, struktur kelas, atau data di dalam initState()), atau saat menambahkan package/aset (gambar/font) baru, karena DVM perlu direstart untuk membaca ulang keseluruhan struktur awal dan dependencies yang baru.