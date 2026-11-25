# MyPortfolio Mobile (myportofolio_mobile)

[![CI](https://github.com/yosua2555/myportofolio_mobile/actions/workflows/main.yaml/badge.svg)](https://github.com/yosua2555/myportofolio_mobile/actions/workflows/main.yaml)

Aplikasi mobile portofolio pribadi berbasis Flutter untuk mata kuliah Pemrograman Berbasis Platform (CSGE602022) - Fasilkom Universitas Indonesia, Semester Gasal 2026/2027.

* **Repositori Backend Django (DRF):** https://github.com/yosua2555/myportofolio
* **URL API Backend (PWS):** https://yosua-peitho-myportofolio.pws.cs.ui.ac.id/api/v1/

---

## 👤 Informasi Mahasiswa
* **Nama** : Yosua Peitho Purba
* **NPM** : 2506657402
* **Kelas** : PBP D

---

## 📱 Tentang Proyek
Proyek ini merupakan klien aplikasi *mobile* multiplatform yang dibangun menggunakan **Flutter** dan bahasa **Dart**. Aplikasi ini berfungsi sebagai antarmuka *mobile* bagi portofolio pribadi (`myportofolio`), yang nantinya akan diintegrasikan dengan REST API Django REST Framework (DRF) yang telah dibangun pada Tutorial 07.

* **Tutorial 08**: Menampilkan halaman beranda statis portofolio dengan identitas pemilik dan kisi-kisi tombol menu aksi yang interaktif.
* **Tutorial 09**: Mengimplementasikan navigasi antarhalaman (*routing* dengan `Navigator.push` dan `Navigator.pushReplacement`), drawer navigasi (`LeftDrawer`), formulir input proyek (`ProjectFormPage`) dengan validasi data dan dialog pop-up konfirmasi, serta melakukan *refactoring* struktur file ke dalam folder `screens/` dan `widgets/`.
* **Tugas 8 (Individual Assignment 8)**: Menambahkan halaman formulir portofolio baru untuk bagian **Edukasi** (`EducationFormPage` di `lib/screens/education_form.dart`), mengintegrasikan kartu aksi `"Tambah Edukasi"` dan opsi drawer `"Add Education"`, menerapkan validasi komprehensif (teks wajib, batas panjang, rentang IPK, format URL, urutan tanggal), serta menampilkan dialog ringkasan data.

---

## ✨ Fitur & Komponen yang Diimplementasikan
1. **Navigasi & Drawer Menu (`lib/widgets/left_drawer.dart`)**:
   - Menambahkan menu laci navigasi samping (*side drawer*) dengan `DrawerHeader` bertema utama aplikasi (`colorScheme.primary`).
   - Menyediakan menu navigasi **Home** (kembali ke `MyHomePage`), **Add Project** (menuju `ProjectFormPage`), dan **Add Education** (menuju `EducationFormPage`) menggunakan `Navigator.pushReplacement()`.
2. **Formulir Input Proyek (`lib/screens/project_form.dart`)**:
   - Dibuat menggunakan `StatefulWidget` dengan `_formKey = GlobalKey<FormState>()` untuk mengelola *state* dan validasi form.
   - Memiliki berbagai elemen input:
     - *TextFormField* untuk **Nama Proyek** (dengan validasi wajib diisi).
     - *TextFormField* *multiline* untuk **Deskripsi Proyek** (dengan validasi wajib diisi).
     - *DropdownButtonFormField* untuk **Kategori Proyek** (*Web Development*, *Mobile Development*, *Machine Learning*, *Data Science*, *Other*).
     - *TextFormField* untuk **Teknologi yang Digunakan**.
     - *TextFormField* untuk **Tautan Proyek** (*opsional*).
   - Tombol **Save** yang melakukan validasi input dan memunculkan pop-up dialog `AlertDialog` berisi seluruh data proyek yang telah diisi, serta mereset formulir setelah ditutup.
3. **Formulir Input Edukasi (`lib/screens/education_form.dart`)**:
   - Halaman formulir baru untuk Tugas 8 menggunakan `StatefulWidget`, `Form`, dan `GlobalKey<FormState>` dengan `AutovalidateMode.onUserInteraction` aktif otomatis setelah percobaan submit gagal.
   - Menyediakan input **Nama Institusi** (wajib, maks. 120 karakter), **Jenjang Pendidikan** (`DropdownButtonFormField` dengan `isExpanded: true`), **Jurusan / Program Studi** (wajib, maks. 100 karakter), sakelar **Masih menempuh pendidikan di sini** (`SwitchListTile` dibungkus `Material`), **Tanggal Mulai** & **Tanggal Selesai** (`showDatePicker()` dengan validasi urutan tanggal), **IPK / Nilai Akhir** (opsional, rentang `0.00 - 4.00`), **Tautan Institusi / Kredensial** (opsional, validasi URL `http`/`https`), dan **Deskripsi / Pencapaian** (opsional, maks. 500 karakter).
   - Tombol **Simpan** memicu `FormState.validate()` dan menampilkan `AlertDialog` ringkasan isian sebelum mereset formulir, sedangkan tombol **Reset** mengosongkan seluruh isian kapan saja.
   - **Fitur Ekstra Sesi Ini**: Menampilkan daftar kartu riwayat edukasi yang baru ditambahkan selama sesi berjalan (*in-memory list*) lengkap dengan tombol hapus per entri dan umpan balik `SnackBar`.
4. **Pemisahan Model & Validasi (`lib/models/`, `lib/utils/`)**:
   - Model data immutable `EducationEntry` (`lib/models/education_entry.dart`) untuk enkapsulasi struktur data dan pemformatan tanggal/periode.
   - Fungsi validasi murni `EducationValidators` (`lib/utils/education_validators.dart`) yang terpisah dari widget UI sehingga mudah diuji secara terisolasi.
5. **Navigasi dari Tombol Kartu (`lib/widgets/project_card.dart`)**:
   - Menambahkan fungsi pada `onTap` di kartu `"Tambah Proyek"` untuk berpindah ke `ProjectFormPage` serta `"Tambah Edukasi"` untuk berpindah ke `EducationFormPage` menggunakan `Navigator.push()`.
6. **Refactoring Struktur Berkas (*Clean Architecture*)**:
   - Memisahkan berkas halaman ke direktori `lib/screens/` (`menu.dart`, `project_form.dart`, `education_form.dart`), komponen *reusable* ke `lib/widgets/` (`left_drawer.dart`, `project_card.dart`), model ke `lib/models/`, dan utilitas validasi ke `lib/utils/`.

---

## 📅 Progres Mingguan

| Minggu | Modul / Tugas | Fokus Implementasi |
| :--- | :--- | :--- |
| **Tutorial 08 / Tugas 7** | Dasar Flutter & Layout | Halaman beranda `MyHomePage`, `InfoCard`, `ItemCard` dengan warna kustom & `SnackBar`. |
| **Tutorial 09** | Navigasi, Drawer, & Form Proyek | `LeftDrawer`, `ProjectFormPage` (`Form` + `AlertDialog`), navigasi `push`/`pushReplacement`, refactoring ke `screens/` & `widgets/`. |
| **Tugas 8** | Formulir Edukasi & Validasi Lanjut | `EducationEntry`, `EducationValidators`, `EducationFormPage`, unit & widget test. |
| **Tutorial 10** | Integrasi DRF, Auth Token, & CI/CD | Model `@JsonSerializable` (`Project`), `ApiClient`, `ProjectListScreen`, `ProjectDetailScreen`, `AuthState`, `LoginScreen`, `ensureLoggedIn`, GitHub Actions (`very_good_workflows` + `build_apk`). |
| **Assignment 9** | Integrasi Penuh Bagian Education | Model `@JsonSerializable` (`Education`), `GET`/`POST`/`PATCH`/`DELETE`/`star` di `ApiClient`, `EducationListScreen`, `EducationDetailScreen`, refactor `EducationFormPage` terautentikasi + penanganan `401`, pengujian `MockClient`, dan badge CI. |

---

## 📁 Struktur Proyek

```text
.github/
└── workflows/
    └── main.yaml
lib/
├── config.dart
├── main.dart
├── models/
│   ├── education.dart
│   ├── education_entry.dart
│   └── project.dart
├── screens/
│   ├── education_detail_screen.dart
│   ├── education_form.dart
│   ├── education_list_screen.dart
│   ├── login_screen.dart
│   ├── menu.dart
│   ├── project_detail_screen.dart
│   ├── project_form.dart
│   └── project_list_screen.dart
├── services/
│   ├── api_client.dart
│   └── auth_state.dart
├── utils/
│   └── education_validators.dart
└── widgets/
    ├── auth_guard.dart
    ├── left_drawer.dart
    └── project_card.dart
test/
├── api_client_test.dart
├── education_validators_test.dart
└── widget_test.dart
```

---

## 🚀 Cara Menjalankan Aplikasi & Pengujian
1. Pastikan Flutter SDK telah terpasang di komputer dan terdaftar pada *environment variable* `PATH`.
2. Buka terminal pada root folder proyek ini dan unduh seluruh dependensi:
   ```bash
   cd myportofolio_mobile
   flutter pub get
   ```
3. Hasilkan berkas serialisasi JSON (`*.g.dart` tidak di-*commit* ke Git):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Jalankan aplikasi terhadap backend Django sesuai target perangkat:
   * **Chrome / Web terhadap Django lokal (`http://localhost:8000`):**
     ```bash
     flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
     ```
   * **Emulator Android terhadap Django lokal (default `http://10.0.2.2:8000`):**
     ```bash
     flutter run
     ```
   * **Terhadap backend produksi PWS:**
     ```bash
     flutter run -d chrome --dart-define=API_BASE_URL=https://yosua-peitho-myportofolio.pws.cs.ui.ac.id
     ```
5. Jalankan pemeriksaan format, analisis statis, dan seluruh *unit* + *widget test*:
   ```bash
   dart format --output=none --set-exit-if-changed .
   flutter analyze
   flutter test
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

---

### Tugas 8

1. **Jelaskan perbedaan antara `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`. Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.**
   * `Navigator.push()` menambahkan *route* baru di atas tumpukan (*stack*) navigasi tanpa menghapus halaman sebelumnya, sehingga pengguna masih dapat kembali ke halaman asal dengan tombol Back bawaan perangkat atau `Navigator.pop()`.
   * `Navigator.pushReplacement()` menghapus *route* yang sedang tampil di puncak *stack* lalu menggantinya secara langsung dengan *route* baru. Halaman sebelumnya tidak lagi tersimpan di *stack* tepat di bawah halaman baru.
   * `Navigator.pop()` mengeluarkan *route* teratas dari *stack* navigasi sehingga tampilan kembali ke halaman sebelumnya yang berada di bawahnya.
   * **Metode untuk membuka formulir dari kartu aksi**: Kartu aksi `"Tambah Proyek"` dan `"Tambah Edukasi"` di `lib/widgets/project_card.dart` menggunakan `Navigator.push()` untuk membuka `ProjectFormPage` atau `EducationFormPage` agar pengguna bisa kembali ke halaman utama memakai tombol kembali bawaan perangkat/browser.
   * **Opsi Home di drawer**: Pada `lib/widgets/left_drawer.dart`, mengetuk opsi **Home** memanggil `Navigator.pushReplacement()` menuju `MyHomePage()`. Cara ini menggantikan halaman formulir yang sedang aktif dengan halaman utama sehingga *stack* navigasi tetap bersih dan tidak menumpuk berulang kali saat pengguna berpindah melalui drawer (termasuk berguna saat diuji di Chrome).

2. **Bagaimana susunan `Scaffold`, `AppBar`, dan `Drawer` membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.**
   * `Scaffold` menyediakan kerangka tata letak Material Design yang seragam di tiap halaman (`appBar`, `drawer`, `body`, dan `backgroundColor`), sehingga posisi bilah atas, menu navigasi samping, dan area konten selalu konsisten.
   * `AppBar` menampilkan identitas halaman aktif di bagian atas dengan warna latar, tipografi, dan warna ikon yang seragam.
   * `Drawer` yang diekstrak menjadi widget *reusable* `LeftDrawer` (`lib/widgets/left_drawer.dart`) dan dipasang pada properti `drawer` di `MyHomePage`, `ProjectFormPage`, maupun `EducationFormPage` memastikan struktur menu dan alur navigasi antarhalaman identik di mana pun pengguna berada.
   * **Contoh penggunaan warna tema portofolio di lebih dari satu halaman**: `Theme.of(context).colorScheme.primary` (yang bersumber dari `ColorScheme.fromSeed(seedColor: Colors.indigo)` di `lib/main.dart`) digunakan secara konsisten untuk warna latar `AppBar` dan *banner* pada `MyHomePage` (`lib/screens/menu.dart`), warna `AppBar` dan tombol **Simpan** pada `EducationFormPage` (`lib/screens/education_form.dart`), serta latar `DrawerHeader` pada `LeftDrawer` (`lib/widgets/left_drawer.dart`).

3. **Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.**
   * Formulir `EducationFormPage` disusun secara vertikal menggunakan `Column` (`crossAxisAlignment: CrossAxisAlignment.stretch`) di dalam `SingleChildScrollView` dan `SafeArea` agar alur pengisian terasa alami dari atas ke bawah, setiap label dan pesan validasi memiliki ruang lebar penuh pada layar selebar ponsel tanpa terpotong, dan tombol **Simpan** berada di bagian akhir alur input.
   * **Peran widget pengatur jarak (`Padding` dan `SizedBox`)**: `Padding` memberi jarak aman antara tepi layar dan konten formulir sehingga komponen tidak menempel ke sisi layar, sedangkan `SizedBox(height: ...)` menjaga jarak vertikal antar-elemen input dan tombol agar mudah dibaca serta mencegah kesalahan ketuk (*mis-tap*).
   * **Peran widget penggulir (`SingleChildScrollView`)**: `Column` secara bawaan tidak dapat digulir dan akan mengalami *RenderFlex overflow* jika tinggi konten melebihi ruang layar—terutama pada ponsel berukuran kecil atau ketika *soft keyboard* muncul dan memotong hampir separuh tinggi layar. Membungkus `Column` di dalam `SingleChildScrollView` memastikan seluruh kolom input dan tombol **Simpan** tetap dapat digulir dan dijangkau dengan lancar.

4. **Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.**
   * `GlobalKey<FormState>` (`_formKey`) bertindak sebagai pengenal unik untuk mengakses `FormState` dari luar widget `Form`, sehingga logika tombol **Simpan** dapat memicu validasi atau reset seluruh input sekaligus.
   * `validator` adalah fungsi *callback* pada setiap `TextFormField` atau `DropdownButtonFormField` yang memeriksa nilai input terhadap aturan bisnis (mengembalikan pesan *error* `String` jika tidak valid, atau `null` jika valid).
   * `_formKey.currentState!.validate()` mengeksekusi fungsi `validator` di seluruh *field* di dalam `Form` saat tombol **Simpan** ditekan. Jika ada yang mengembalikan pesan error, UI otomatis menampilkannya di bawah kolom terkait dan `validate()` mengembalikan `false` sehingga dialog ringkasan tidak ditampilkan.
   * **Contoh nilai yang ditolak**: Input `"   "` (hanya spasi) pada **Nama Institusi**, angka `"4.50"` pada **IPK**, teks `"bukan-url"` pada **Tautan Institusi**, atau memilih **Tanggal Selesai** yang lebih awal daripada **Tanggal Mulai**.
   * **Mengapa memilih jenis input atau papan ketik (`keyboardType`) saja belum cukup**: `keyboardType` (seperti `TextInputType.numberWithOptions(decimal: true)` atau `TextInputType.url`) hanya mengatur tata letak tombol yang disarankan di papan ketik virtual pada perangkat seluler, tetapi tidak memaksa maupun memvalidasi isi data. Pengguna tetap dapat menempelkan (*paste*) teks acak, mengetik melalui *hardware keyboard* di web/Chrome, memasukkan angka di luar rentang (misalnya IPK `4.50` atau `-1`), meninggalkan teks berisi spasi saja, atau memasukkan format URL yang tidak sah. Oleh karena itu, validasi eksplisit di dalam `validator` tetap wajib dilakukan.

#### AI Disclosure (Tugas 8)
* **Tools yang digunakan:** Antigravity AI Assistant.
* **Ringkasan Log Prompting & Strategi:**
  1. *Prompt 1 (Perancangan Fitur):* Meminta implementasi Tugas 8 berdasarkan PDF tugas—membuat halaman formulir Edukasi, kartu aksi `"Tambah Edukasi"`, dan opsi `"Add Education"` di `LeftDrawer`.
  2. *Prompt 2 (Refaktor & Pengujian):* Meminta evaluasi terhadap rubrik penilaian nilai 4, lalu memisahkan `EducationEntry` (`lib/models/`) dan `EducationValidators` (`lib/utils/`) dari UI, menambahkan fitur ekstra (*in-memory session list*, tombol *Reset*, `AutovalidateMode`), serta menyusun *unit* dan *widget test*.
  3. *Prompt 3 (Dokumentasi):* Menyusun jawaban reflektif Tugas 8, tabel progres mingguan, dan analisis verifikasi pada `README.md`.
* **Analisis Kritis Keterbatasan AI & Perbaikan Manual:**
  * *Masalah Material/Ink Splash pada `SwitchListTile`:* Kode awal membungkus `SwitchListTile` dengan `Container` berlatar putih, yang memicu pengecualian kerangka Flutter karena `DecoratedBox` menutupi *ink splash* `ListTile`. Perbaikan dilakukan dengan menggantinya menjadi `Material` ber-`shape` dan `clipBehavior: Clip.antiAlias`.
  * *Masalah Overflow di Layar Sempit (`360x640`) & Font Test:* Widget test menemukan *RenderFlex overflow* pada `DrawerHeader` (`78px` vertikal) serta pada `DropdownButtonFormField` (`87px` horizontal untuk opsi `"Bootcamp / Non-Gelar"`). Masalah ini diselesaikan dengan membungkus isi `DrawerHeader` dalam `SingleChildScrollView`, menata field tanggal secara vertikal, serta menambahkan `isExpanded: true` dan `TextOverflow.ellipsis` pada `DropdownButtonFormField`.
  * *Kebersihan Impor & State Reset:* Template tutorial menyisakan potensi *unused import* (`menu.dart` di `project_card.dart`) serta kebutuhan reset `TextEditingController` tanggal dan `_autovalidateMode` secara eksplisit saat dialog ditutup. Seluruh kode diverifikasi menggunakan `flutter analyze` dan `flutter test` hingga seluruh kasus uji lulus tanpa error.

---

### Assignment 9

1. **Mengapa kita menggunakan `@JsonSerializable(fieldRename: FieldRename.snake)` dan `@JsonKey(includeToJson: false)` alih-alih mengirim objek `Map<String, dynamic>` mentah langsung dari widget? Jelaskan satu bug yang dicegah atau dapat dicegah oleh pendekatan ini pada model bagianmu.**
   * Menggunakan kelas model bertipe kuat (`Education` di `lib/models/education.dart`) bersama `json_serializable` menjamin *type safety* pada waktu kompilasi, menghilangkan kode *boilerplate* pemetaan manual yang rawan salah ketik (*typo*), serta memisahkan kontrak serialisasi JSON dari lapisan widget UI.
   * `@JsonSerializable(fieldRename: FieldRename.snake)` secara konsisten memetakan konvensi *camelCase* Dart (`startedYear`, `endedYear`, `starCount`, `isStarred`, `starredByNames`) ke konvensi *snake_case* milik Django REST Framework (`started_year`, `ended_year`, `star_count`, `is_starred`, `starred_by_names`).
   * `@JsonKey(includeToJson: false)` mencegah atribut yang dikelola server (`id`, `star_count`, `is_starred`, `starred_by_names`) ikut terkirim pada body `POST`/`PATCH`.
   * **Contoh bug yang dicegah pada model `Education`**: Apabila widget merakit `Map<String, dynamic>` secara manual, sangat mudah terjadi salah ketik kunci seperti `'startedYear'` alih-alih `'started_year'` atau mengirim `started_year` sebagai `String` (`"2025"`) bukannya `int`, maupun tanpa sengaja mengirim `'id': null` atau `'star_count': 0` pada `POST /api/v1/education/`—yang berakibat `400 Bad Request` dari `EducationSerializer` DRF atau *runtime `TypeError`* saat deserialisasi `ended_year` yang bernilai `null`. Dengan `Education.fromJson()` / `toJson()` hasil `build_runner`, struktur kunci, nullability (`int? endedYear`), dan pengecualian field *read-only* dijamin konsisten.

2. **Mengapa `Future` yang diteruskan ke `FutureBuilder` harus diinisialisasi di dalam `initState()` alih-alih langsung di dalam `build()`, dan mengapa `ApiClient` sebaiknya melempar `ApiException` daripada mengembalikan `null` pada respons HTTP non-2xx?**
   * **Inisialisasi `Future` di `initState()`**: Di Flutter, metode `build()` dapat dipanggil berulang kali setiap kali ada perubahan *state*, animasi, pembukaan *drawer*, perubahan ukuran layar, atau pembaruan `InheritedWidget`/`Provider`. Jika `context.read<ApiClient>().getEducations()` dipanggil langsung di dalam `build()`, setiap *rebuild* akan memicu permintaan HTTP baru ke server, membuat layar berkedip kembali ke `CircularProgressIndicator` terus-menerus, memboroskan kuota jaringan/server, bahkan memicu *infinite request loop*. Menyimpan `_educationsFuture` di `initState()` (dan memperbaruinya secara eksplisit hanya di `_reload()`) memastikan permintaan jaringan berjalan tepat satu kali saat layar dibuka atau saat pengguna melakukan *pull-to-refresh* / menekan **Retry**.
   * **Melempar `ApiException` daripada mengembalikan `null`**: Mengembalikan `null` menyamarkan penyebab kegagalan—pemanggil tidak bisa membedakan apakah daftar memang kosong, token kedaluwarsa (`401`), pengguna bukan superuser (`403`), input tidak valid (`400`), atau server bermasalah (`500`). Dengan melempar `ApiException(statusCode, message)`, `FutureBuilder` otomatis menangkapnya lewat `snapshot.hasError` untuk merender tombol **Retry**, sementara formulir dan aksi detail (`EducationFormPage` & `EducationDetailScreen`) dapat memeriksa `e.statusCode == 401` untuk mencabut sesi dan meminta login ulang, atau menampilkan pesan khusus untuk `403`.

3. **Bandingkan `SessionAuthentication` milik Django (dari Tutorial 04/07) dengan `TokenAuthentication` milik DRF (dari Tutorial 10). Mengapa `myportofolio_mobile` menggunakan `TokenAuthentication` sementara `SessionAuthentication` tetap diaktifkan pada backend Django?**
   * **`SessionAuthentication` (Django)**: Bersifat *stateful* berbasis *session cookie* (`sessionid`) yang disimpan otomatis oleh browser serta mewajibkan token CSRF (`csrftoken`) pada permintaan mutasi (`POST`/`PATCH`/`DELETE`) untuk melindungi aplikasi web dari serangan *Cross-Site Request Forgery*.
   * **`TokenAuthentication` (DRF)**: Bersifat *stateless* per permintaan (tanpa cookie/CSRF); klien menukar kredensial di `POST /api/v1/auth/token/` untuk memperoleh kunci token, lalu melampirkannya pada header `Authorization: Token <key>` di setiap permintaan terautentikasi, dan mencabutnya di `POST /api/v1/auth/logout/`.
   * **Alasan keduanya dipakai bersamaan**: Aplikasi mobile native Flutter (Android/iOS) tidak memiliki manajemen cookie browser dan alur CSRF seperti halaman HTML Django, sehingga `TokenAuthentication` jauh lebih bersih, eksplisit, dan *cross-platform* (termasuk Flutter Web via CORS). Sementara itu, halaman web portofolio Django (beserta AJAX pada halaman Projects/Education dan Browsable API DRF) tetap menggunakan login berbasis sesi browser, sehingga `SessionAuthentication` tetap dipertahankan sebagai urutan kedua di `DEFAULT_AUTHENTICATION_CLASSES` (dengan `TokenAuthentication` di urutan pertama agar permintaan mobile tanpa token menerima `401 Unauthorized`, bukan `403 Forbidden`).

4. **Jelaskan peran job `build` (`very_good_workflows`) dan `build_apk` dalam pipeline `.github/workflows/main.yaml` milikmu (termasuk pemeriksaan apa saja yang dijalankan `very_good_workflows` di balik layar). Mengapa berkas `*.g.dart` dimasukkan ke `.gitignore` meskipun CI membutuhkannya untuk menganalisis dan membangun aplikasi?**
   * **Peran job `build` (`VeryGoodOpenSource/very_good_workflows/.../flutter_package.yml@v2`)**: Bertindak sebagai gerbang **Continuous Integration (CI)** otomatis pada setiap `push` ke `main` dan `pull_request`. Di balik layar, workflow ini menginstal dependensi (`flutter pub get`), menjalankan langkah `setup` (`dart run build_runner build --delete-conflicting-outputs`), memeriksa format kode (`dart format --output=none --set-exit-if-changed .`), menjalankan analisis statis (`flutter analyze`), mengeksekusi seluruh pengujian otomatis beserta laporan cakupan (`flutter test --coverage` dengan mengecualikan `**/*.g.dart`), serta memverifikasi ambang `min_coverage`.
   * **Peran job `build_apk`**: Bertindak sebagai tahap **Continuous Delivery (CD)** yang hanya berjalan jika job `build` lulus (`needs: build`). Job ini menginstal Flutter, menjalankan `flutter pub get` dan `build_runner`, mengompilasi `flutter build apk --release` (dengan `--dart-define=API_BASE_URL=${{ vars.API_BASE_URL }}` yang mengarah ke PWS bila variabel diset), lalu mengunggah berkas `build/app/outputs/flutter-apk/app-release.apk` sebagai artefak `app-release-apk` melalui `actions/upload-artifact@v4`.
   * **Mengapa `*.g.dart` dimasukkan ke `.gitignore`**: Berkas `*.g.dart` merupakan kode turunan (*generated artifacts*) yang sepenuhnya deterministik dari sumber model (`project.dart`, `education.dart`). Mengabaikannya di Git menjaga *diff* dan *pull request* tetap bersih dari ratusan baris *boilerplate*, mencegah *merge conflict* yang tidak perlu antar-branch, dan menjamin tidak ada berkas hasil generasi usang yang tertinggal—karena baik pengembang lokal maupun pipeline CI (`setup` di `build` dan langkah `build_runner` di `build_apk`) selalu membuatnya ulang secara segar dari sumber terkini.

#### AI Disclosure (Assignment 9)
* **Tools yang digunakan:** Antigravity AI Assistant.
* **Ringkasan Log Prompting & Strategi:**
  1. *Prompt 1 (Tutorial 10 — Flutter & Django):* Mengintegrasikan `Project`, `ApiClient`, `AuthState`, `LoginScreen`, `auth_guard`, dan `.github/workflows/main.yaml` di Flutter serta mengonfigurasi `django-cors-headers`, `rest_framework.authtoken`, dan endpoint `/api/v1/auth/token/` + `/api/v1/auth/logout/` di repositori backend Django `myportofolio`.
  2. *Prompt 2 (Assignment 9 — Integrasi Education):* Meminta implementasi penuh bagian **Education** mengikuti checklist dan rubrik nilai 4: model `@JsonSerializable` (`Education`), ekstensi `ApiClient` (`GET`, `POST`, `PATCH`, `DELETE`, `star`), `EducationListScreen`, `EducationDetailScreen`, refactor `EducationFormPage` terautentikasi, unit/widget test `MockClient`, dan dokumentasi `README.md`.
* **Analisis Kritis Keterbatasan AI & Perbaikan Manual:**
  * *Ketidaksesuaian Skema Contoh PDF vs Backend Asli:* Pada awalnya, kode yang dihasilkan mengikuti contoh skema PDF Tutorial 10 (`title`, `tech_stack`, `project_url`) dan model lokal Assignment 8 (`DateTime` + IPK/URL). Setelah meninjau langsung `main/serializers.py` pada repositori backend Django, ditemukan bahwa `ProjectSerializer` menggunakan `name`/`date`/`description` dan `EducationSerializer` menggunakan `institution`/`degree`/`description`/`started_year`/`ended_year`. Kedua model dan formulir di Flutter disinkronkan secara eksplisit agar integrasi *end-to-end* berjalan tanpa `400 Bad Request`.
  * *Kompatibilitas Flutter 3.50 (`material_ui`), Linter Ketat (`very_good_analysis`), & CI:* `flutter analyze` mendeteksi 11 peringatan *deprecated* pada `package:flutter/material.dart` di Flutter 3.50+ yang akan menggagalkan `very_good_workflows`. Dilakukan penambahan paket `material_ui` dan migrasi impor secara menyeluruh ke `package:material_ui/material_ui.dart`, pembaruan batas `sdk: ^3.8.0` sesuai peringatan `json_serializable`, serta penerapan aturan analisis ketat `very_good_analysis` (`MaterialPageRoute<void>` eksplisit, `on Object catch`, urutan dependensi alfabetis, dan batas panjang baris 80 karakter) hingga `flutter analyze` lulus dengan 0 isu.
  * *Bug Indikator Loading pada Dialog & Remote PWS:* Pengujian otomatis mengungkap bahwa `_isSubmitting` pada formulir masih bernilai `true` selama `AlertDialog` terbuka (membuat spinner terus berputar di belakang dialog) sehingga diperbaiki dengan mereset `_isSubmitting = false` sebelum `showDialog`. Selain itu, pemeriksaan remote Git menemukan PWS men-*deploy* dari branch `master`, sehingga backend di-*push* eksplisit melalui `git push pws main:master`. Seluruh kode diverifikasi ulang dengan `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, `flutter test`, dan `manage.py test main`.