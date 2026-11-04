import 'package:flutter/material.dart';
import '../models/item_model.dart';

class AddItemScreen extends StatefulWidget {
  final UserAccount user;

  const AddItemScreen({super.key, required this.user});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCategory = 'Task';
  String _selectedStatus = 'Pending';

  final List<String> _categories = ['Task', 'Inventaris'];
  final List<String> _statuses = ['Pending', 'Proses', 'Selesai'];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final newItem = ItemModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      category: _selectedCategory,
      status: widget.user.isAdmin ? _selectedStatus : 'Pending',
      createdBy: widget.user.username,
      description: _descController.text.trim(),
    );

    AppData.globalItemList.insert(0, newItem);
    await AppData.save();

    if (!mounted) return;

    showAppSnack(
      context,
      'Data berhasil disimpan!',
      color: AppColors.success,
      icon: Icons.check_circle_rounded,
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.user.isAdmin;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Tambah Tugas / Inventaris'),
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Penginput: ${widget.user.username}',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: AppColors.text),
                  decoration: appInputDecoration(
                    label: 'Nama Tugas / Barang *',
                    hint: 'Masukkan nama tugas atau barang',
                    icon: Icons.edit_note_rounded,
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty
                          ? 'Nama wajib diisi'
                          : null,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Kategori',
                  style: TextStyle(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  dropdownColor: AppColors.card,
                  decoration: appInputDecoration(
                    label: 'Pilih kategori',
                    icon: Icons.category_outlined,
                  ),
                  items: _categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _selectedCategory = v);
                    }
                  },
                ),
                const SizedBox(height: 18),

                // Hanya admin yang dapat memilih status.
                if (isAdmin) ...[
                  const Text(
                    'Status',
                    style: TextStyle(color: AppColors.text),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    dropdownColor: AppColors.card,
                    decoration: appInputDecoration(
                      label: 'Status data',
                      icon: Icons.flag_outlined,
                    ),
                    items: _statuses
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _selectedStatus = v);
                      }
                    },
                  ),
                ] else
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.danger.withAlpha(100),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.pending_actions_rounded,
                          color: AppColors.danger,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Status otomatis Pending. Menunggu persetujuan admin.',
                            style: TextStyle(color: AppColors.text),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 18),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.text),
                  decoration: appInputDecoration(
                    label: 'Deskripsi (Opsional)',
                    hint: 'Masukkan keterangan tambahan',
                    icon: Icons.description_outlined,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save_rounded),
                    label: Text(
                      isAdmin ? 'Simpan Data' : 'Kirim ke Admin',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}