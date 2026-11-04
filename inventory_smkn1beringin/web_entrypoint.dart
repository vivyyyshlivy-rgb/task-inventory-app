import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

// ======================================================
// DATA GLOBAL
// Data diletakkan di luar Dashboard agar TIDAK HILANG
// ketika logout.
// ======================================================

final List<TaskItem> taskData = [
  const TaskItem(
    id: '1',
    nama: 'Mengerjakan Tugas Flutter',
    kategori: 'Tugas',
    status: 'Belum Selesai',
  ),
  const TaskItem(
    id: '2',
    nama: 'Laptop',
    kategori: 'Inventaris',
    status: 'Selesai',
  ),
];

// ======================================================
// MODEL DATA
// ======================================================

class TaskItem {
  final String id;
  final String nama;
  final String kategori;
  final String status;

  const TaskItem({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.status,
  });
}

// ======================================================
// MAIN APP
// ======================================================

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PROJECT TASK MANAGER SMK NEGERI 1',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF102A43),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF102A43),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ======================================================
// SCREEN 1 - LOGIN
// ======================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _obscurePassword = true;

  // ====================================================
  // USERNAME DAN PASSWORD YANG BENAR
  // ====================================================

  static const String correctEmail =
      'Shilvyalychia@Gmail.com';

  static const String correctPassword = '123456';

  // ====================================================
  // LOGIN
  // ====================================================

  void _login() {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // EMAIL SALAH
    if (email.toLowerCase() != correctEmail.toLowerCase()) {
      _showMessage('Username / Email salah');
      return;
    }

    // PASSWORD SALAH
    if (password != correctPassword) {
      _showMessage('Password salah');
      return;
    }

    // LOGIN BERHASIL
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    );
  }

  // ====================================================
  // PESAN KECIL
  // Tidak menggunakan kotak merah panjang.
  // ====================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ====================================================
  // TAMPILAN LOGIN
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BACKGROUND BIRU TUA
      backgroundColor: const Color(0xFF102A43),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Container(
              width: double.infinity,

              constraints: const BoxConstraints(
                maxWidth: 430,
              ),

              padding: const EdgeInsets.all(28),

              // KOTAK PUTIH DI TENGAH
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  children: [

                    // ==================================================
                    // LOGO
                    // ==================================================

                    Container(
                      width: 110,
                      height: 110,

                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF102A43),
                          width: 2,
                        ),
                      ),

                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.png',

                          fit: BoxFit.contain,

                          errorBuilder:
                              (context, error, stackTrace) {
                            return const Icon(
                              Icons.school,
                              size: 65,
                              color: Color(0xFF102A43),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // JUDUL
                    // ==================================================

                    const Text(
                      'PROJECT TASK MANAGER',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102A43),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'SMK NEGERI 1 BERINGIN',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Silakan login untuk melanjutkan',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==================================================
                    // USERNAME / EMAIL
                    // ==================================================

                    TextFormField(
                      controller: _emailController,

                      keyboardType:
                          TextInputType.emailAddress,

                      decoration: InputDecoration(
                        labelText: 'Username / Gmail',

                        hintText:
                            'Masukkan username/email',

                        prefixIcon: const Icon(
                          Icons.person_outline,
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),

                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),

                          borderSide:
                              const BorderSide(
                            color: Color(0xFF102A43),
                            width: 2,
                          ),
                        ),
                      ),

                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Username/email wajib diisi';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // PASSWORD
                    // ==================================================

                    TextFormField(
                      controller: _passwordController,

                      obscureText: _obscurePassword,

                      keyboardType:
                          TextInputType.number,

                      maxLength: 6,

                      decoration: InputDecoration(
                        labelText: 'Password',

                        hintText:
                            'Masukkan 6 digit password',

                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },

                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),

                        counterText: '',

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),

                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),

                          borderSide:
                              const BorderSide(
                            color: Color(0xFF102A43),
                            width: 2,
                          ),
                        ),
                      ),

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Password wajib diisi';
                        }

                        if (value.length != 6) {
                          return 'Password harus 6 karakter';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // LOGIN BUTTON
                    // ==================================================

                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton.icon(
                        onPressed: _login,

                        icon: const Icon(
                          Icons.login,
                        ),

                        label: const Text(
                          'LOGIN',

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF102A43),

                          foregroundColor:
                              Colors.white,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================
// SCREEN 2 - DASHBOARD
// ======================================================

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  // ====================================================
  // TAMBAH DATA
  // ====================================================

  Future<void> _tambahData() async {
    final hasil = await Navigator.push<TaskItem>(
      context,

      MaterialPageRoute(
        builder: (context) =>
            const FormDataScreen(),
      ),
    );

    if (!mounted) return;

    if (hasil != null) {
      setState(() {
        taskData.add(hasil);
      });

      _showMessage(
        'Data berhasil ditambahkan',
      );
    }
  }

  // ====================================================
  // HAPUS DATA
  // ====================================================

  void _konfirmasiHapus(TaskItem item) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Hapus Data?',
          ),

          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${item.nama}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child: const Text(
                'Batal',
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              onPressed: () {
                setState(() {
                  taskData.removeWhere(
                    (data) =>
                        data.id == item.id,
                  );
                });

                Navigator.pop(
                  dialogContext,
                );

                _showMessage(
                  'Data berhasil dihapus',
                );
              },

              child: const Text(
                'Hapus',
              ),
            ),
          ],
        );
      },
    );
  }

  // ====================================================
  // DETAIL
  // ====================================================

  Future<void> _lihatDetail(
    TaskItem item,
  ) async {
    final hasil = await Navigator.push<bool>(
      context,

      MaterialPageRoute(
        builder: (context) =>
            DetailScreen(item: item),
      ),
    );

    if (!mounted) return;

    if (hasil == true) {
      setState(() {
        taskData.removeWhere(
          (data) => data.id == item.id,
        );
      });

      _showMessage(
        'Data berhasil dihapus',
      );
    }
  }

  // ====================================================
  // LOGOUT
  // ====================================================

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (context) =>
            const LoginScreen(),
      ),

      (route) => false,
    );
  }

  // ====================================================
  // MESSAGE
  // ====================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ====================================================
  // WARNA STATUS
  // ====================================================

  Color _statusColor(String status) {
    if (status == 'Selesai') {
      return Colors.green;
    }

    if (status == 'Dalam Proses') {
      return Colors.blue;
    }

    if (status == 'Belum Selesai') {
      return Colors.orange;
    }

    return Colors.purple;
  }

  // ====================================================
  // DASHBOARD
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ==================================================
      // APP BAR
      // ==================================================

      appBar: AppBar(
        title: const Text(
          'PROJECT TASK MANAGER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Logout',

            onPressed: _logout,

            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      // ==================================================
      // BODY
      // ==================================================

      body: Column(
        children: [

          // ==================================================
          // HEADER
          // ==================================================

          Container(
            width: double.infinity,

            margin: const EdgeInsets.fromLTRB(
              16,
              14,
              16,
              10,
            ),

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: const Color(0xFF102A43),

              borderRadius:
                  BorderRadius.circular(18),
            ),

            child: Row(
              children: [

                // LOGO
                Image.asset(
                  'assets/logo.png',

                  width: 65,
                  height: 65,

                  fit: BoxFit.contain,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return const Icon(
                      Icons.school,
                      size: 58,
                      color: Colors.white,
                    );
                  },
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: Text(
                    'PROJECT TASK MANAGER\n'
                    'SMK NEGERI 1 BERINGIN',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // TOTAL DATA
          // ==================================================

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            child: Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor:
                      Color(0xFFE0EAF3),

                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFF102A43),
                  ),
                ),

                title: const Text(
                  'Total Data',
                ),

                subtitle: const Text(
                  'Tugas dan inventaris',
                ),

                trailing: Text(
                  '${taskData.length}',

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102A43),
                  ),
                ),
              ),
            ),
          ),

          // ==================================================
          // JUDUL
          // ==================================================

          const Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              8,
            ),

            child: Align(
              alignment: Alignment.centerLeft,

              child: Text(
                'Daftar Tugas & Inventaris',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ==================================================
          // LIST
          // ==================================================

          Expanded(
            child: taskData.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada data.\n'
                      'Tekan + untuk menambahkan data.',

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  )

                : ListView.builder(
                    padding:
                        const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      90,
                    ),

                    itemCount:
                        taskData.length,

                    itemBuilder:
                        (context, index) {

                      final item =
                          taskData[index];

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 10,
                        ),

                        child: ListTile(
                          contentPadding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),

                          // ICON
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color(
                              0xFFE0EAF3,
                            ),

                            child: Icon(
                              item.kategori ==
                                      'Inventaris'
                                  ? Icons
                                      .inventory_2_outlined
                                  : item.kategori ==
                                          'Tugas'
                                      ? Icons
                                          .assignment_outlined
                                      : Icons
                                          .category_outlined,

                              color:
                                  const Color(
                                0xFF102A43,
                              ),
                            ),
                          ),

                          // NAMA
                          title: Text(
                            item.nama,

                            maxLines: 2,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          // KETERANGAN
                          subtitle: Padding(
                            padding:
                                const EdgeInsets
                                    .only(
                              top: 4,
                            ),

                            child: Text(
                              'Kategori: ${item.kategori}\n'
                              'Status: ${item.status}',

                              maxLines: 2,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style: TextStyle(
                                color:
                                    _statusColor(
                                  item.status,
                                ),

                                fontWeight:
                                    FontWeight.w600,

                                height: 1.4,
                              ),
                            ),
                          ),

                          // TOMBOL
                          trailing: Wrap(
                            spacing: 0,

                            children: [

                              // DETAIL
                              IconButton(
                                tooltip:
                                    'Detail',

                                icon:
                                    const Icon(
                                  Icons
                                      .visibility_outlined,

                                  color:
                                      Color(
                                    0xFF102A43,
                                  ),
                                ),

                                onPressed: () =>
                                    _lihatDetail(
                                  item,
                                ),
                              ),

                              // HAPUS
                              IconButton(
                                tooltip:
                                    'Hapus',

                                icon:
                                    const Icon(
                                  Icons
                                      .delete_outline,

                                  color:
                                      Colors.red,
                                ),

                                onPressed: () =>
                                    _konfirmasiHapus(
                                  item,
                                ),
                              ),
                            ],
                          ),

                          onTap: () =>
                              _lihatDetail(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ==================================================
      // TAMBAH DATA
      // ==================================================

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _tambahData,

        backgroundColor:
            const Color(0xFF102A43),

        foregroundColor:
            Colors.white,

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          'Tambah Data',
        ),
      ),
    );
  }
}

// ======================================================
// SCREEN 3 - FORM TAMBAH DATA
// ======================================================

class FormDataScreen extends StatefulWidget {
  const FormDataScreen({super.key});

  @override
  State<FormDataScreen> createState() =>
      _FormDataScreenState();
}

class _FormDataScreenState
    extends State<FormDataScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _namaController =
      TextEditingController();

  final TextEditingController
      _kategoriLainnyaController =
      TextEditingController();

  final TextEditingController
      _statusLainnyaController =
      TextEditingController();

  String _kategori = 'Tugas';

  String _status = 'Belum Selesai';

  // ====================================================
  // SIMPAN DATA
  // ====================================================

  void _simpanData() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    String kategoriFinal = _kategori;

    String statusFinal = _status;

    // KALAU MEMILIH LAINNYA
    if (_kategori == 'Lainnya') {
      kategoriFinal =
          _kategoriLainnyaController.text.trim();
    }

    if (_status == 'Lainnya') {
      statusFinal =
          _statusLainnyaController.text.trim();
    }

    final dataBaru = TaskItem(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),

      nama:
          _namaController.text.trim(),

      kategori: kategoriFinal,

      status: statusFinal,
    );

    Navigator.pop(
      context,
      dataBaru,
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kategoriLainnyaController.dispose();
    _statusLainnyaController.dispose();
    super.dispose();
  }

  // ====================================================
  // FORM
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Tambah Data'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  'Tambah Data Baru',

                  style: TextStyle(
                    fontSize: 23,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Masukkan informasi tugas atau inventaris.',

                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // NAMA
                // ==================================================

                TextFormField(
                  controller:
                      _namaController,

                  textCapitalization:
                      TextCapitalization
                          .sentences,

                  decoration:
                      InputDecoration(
                    labelText:
                        'Nama Data',

                    hintText:
                        'Contoh: Membuat laporan Flutter',

                    prefixIcon:
                        const Icon(
                      Icons.edit_note,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(14),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Nama data wajib diisi';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ==================================================
                // KATEGORI
                // ==================================================

                DropdownButtonFormField<String>(
                  value: _kategori,

                  decoration:
                      InputDecoration(
                    labelText:
                        'Pilih Kategori',

                    prefixIcon:
                        const Icon(
                      Icons.category_outlined,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(14),
                    ),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: 'Tugas',
                      child:
                          Text('Tugas'),
                    ),

                    DropdownMenuItem(
                      value: 'Inventaris',
                      child:
                          Text('Inventaris'),
                    ),

                    // OPSI LAINNYA
                    DropdownMenuItem(
                      value: 'Lainnya',
                      child:
                          Text('Lainnya'),
                    ),
                  ],

                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _kategori = value;
                    });
                  },
                ),

                const SizedBox(height: 14),

                // ==================================================
                // INPUT KATEGORI LAINNYA
                // ==================================================

                if (_kategori == 'Lainnya')
                  TextFormField(
                    controller:
                        _kategoriLainnyaController,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Masukkan Kategori Lainnya',

                      hintText:
                          'Contoh: Proyek',

                      prefixIcon:
                          const Icon(
                        Icons.add_box_outlined,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),
                    ),

                    validator: (value) {
                      if (_kategori ==
                              'Lainnya' &&
                          (value == null ||
                              value
                                  .trim()
                                  .isEmpty)) {
                        return 'Kategori lainnya wajib diisi';
                      }

                      return null;
                    },
                  ),

                const SizedBox(height: 20),

                // ==================================================
                // STATUS
                // ==================================================

                DropdownButtonFormField<String>(
                  value: _status,

                  decoration:
                      InputDecoration(
                    labelText:
                        'Pilih Status',

                    prefixIcon:
                        const Icon(
                      Icons.check_circle_outline,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(14),
                    ),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value:
                          'Belum Selesai',
                      child: Text(
                        'Belum Selesai',
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          'Dalam Proses',
                      child: Text(
                        'Dalam Proses',
                      ),
                    ),

                    DropdownMenuItem(
                      value: 'Selesai',
                      child:
                          Text('Selesai'),
                    ),

                    // OPSI LAINNYA
                    DropdownMenuItem(
                      value: 'Lainnya',
                      child:
                          Text('Lainnya'),
                    ),
                  ],

                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _status = value;
                    });
                  },
                ),

                const SizedBox(height: 14),

                // ==================================================
                // INPUT STATUS LAINNYA
                // ==================================================

                if (_status == 'Lainnya')
                  TextFormField(
                    controller:
                        _statusLainnyaController,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Masukkan Status Lainnya',

                      hintText:
                          'Contoh: Ditunda',

                      prefixIcon:
                          const Icon(
                        Icons.edit_note,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),
                    ),

                    validator: (value) {
                      if (_status ==
                              'Lainnya' &&
                          (value == null ||
                              value
                                  .trim()
                                  .isEmpty)) {
                        return 'Status lainnya wajib diisi';
                      }

                      return null;
                    },
                  ),

                const SizedBox(height: 28),

                // ==================================================
                // SIMPAN
                // ==================================================

                SizedBox(
                  width:
                      double.infinity,

                  height: 52,

                  child:
                      ElevatedButton.icon(
                    onPressed:
                        _simpanData,

                    icon:
                        const Icon(
                      Icons.save_outlined,
                    ),

                    label:
                        const Text(
                      'SIMPAN DATA',

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF102A43,
                      ),

                      foregroundColor:
                          Colors.white,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // BATAL
                // ==================================================

                SizedBox(
                  width:
                      double.infinity,

                  height: 48,

                  child:
                      OutlinedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },

                    child:
                        const Text(
                      'Batal',
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================
// SCREEN 4 - DETAIL
// ======================================================

class DetailScreen extends StatelessWidget {
  final TaskItem item;

  const DetailScreen({
    super.key,
    required this.item,
  });

  // ====================================================
  // HAPUS DATA
  // ====================================================

  void _hapus(BuildContext context) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text('Hapus Data?'),

          content: Text(
            'Apakah kamu yakin ingin '
            'menghapus "${item.nama}"?',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child:
                  const Text('Batal'),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,

                foregroundColor:
                    Colors.white,
              ),

              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                Navigator.pop(
                  context,
                  true,
                );
              },

              child:
                  const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // ====================================================
  // DETAIL SCREEN
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Detail Data'),
      ),

      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,

            children: [

              const SizedBox(
                height: 10,
              ),

              const Icon(
                Icons.description_outlined,

                size: 80,

                color:
                    Color(0xFF102A43),
              ),

              const SizedBox(
                height: 18,
              ),

              // ==================================================
              // KARTU INFORMASI
              // ==================================================

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      const Text(
                        'Informasi Data',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const Divider(
                        height: 28,
                      ),

                      _detailRow(
                        'ID Data',
                        item.id,
                      ),

                      _detailRow(
                        'Nama',
                        item.nama,
                      ),

                      _detailRow(
                        'Kategori',
                        item.kategori,
                      ),

                      _detailRow(
                        'Status',
                        item.status,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // ==================================================
              // HAPUS
              // ==================================================

              SizedBox(
                width:
                    double.infinity,

                child:
                    ElevatedButton.icon(
                  onPressed: () {
                    _hapus(context);
                  },

                  icon:
                      const Icon(
                    Icons.delete_outline,
                  ),

                  label:
                      const Text(
                    'Hapus Data',
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,

                    foregroundColor:
                        Colors.white,

                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // ==================================================
              // KEMBALI
              // ==================================================

              SizedBox(
                width:
                    double.infinity,

                child:
                    OutlinedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  style:
                      OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                  ),

                  child:
                      const Text(
                    'Kembali ke Dashboard',
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================================================
  // DETAIL ROW
  // ====================================================

  Widget _detailRow(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            label,

            style:
                const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            value,

            style:
                const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}