import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// MODEL AKUN
// ============================================================
class UserAccount {
  static const String roleUser = 'User';
  static const String roleAdmin = 'Admin';
  static const String roleSuperAdmin = 'AdminUtama';

  final String username;
  final String password;
  final String role;
  bool isApproved;

  UserAccount({
    required this.username,
    required this.password,
    required this.role,
    this.isApproved = false,
  });

  bool get isSuperAdmin => role == roleSuperAdmin;

  bool get isAdmin => role == roleAdmin || role == roleSuperAdmin;

  String get roleLabel {
    if (isSuperAdmin) return 'Admin Utama';
    if (role == roleAdmin) return 'Admin';
    return 'User';
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'role': role,
        'isApproved': isApproved,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      username: json['username']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      role: json['role']?.toString() ?? roleUser,
      isApproved: json['isApproved'] as bool? ?? false,
    );
  }
}

// ============================================================
// MODEL TASK DAN INVENTARIS
// ============================================================
class ItemModel {
  final String id;
  final String title;
  final String category;
  String status;
  final String createdBy;
  final String description;

  ItemModel({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.createdBy,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'status': status,
        'createdBy': createdBy,
        'description': description,
      };

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Task',
      status: json['status']?.toString() ?? 'Pending',
      createdBy: json['createdBy']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

// ============================================================
// MODEL RIWAYAT PERSETUJUAN
// ============================================================
class ApprovalHistory {
  final String username;
  final String role;
  final String action;
  final String processedBy;
  final DateTime dateTime;

  ApprovalHistory({
    required this.username,
    required this.role,
    required this.action,
    required this.processedBy,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'role': role,
        'action': action,
        'processedBy': processedBy,
        'dateTime': dateTime.toIso8601String(),
      };

  factory ApprovalHistory.fromJson(Map<String, dynamic> json) {
    return ApprovalHistory(
      username: json['username']?.toString() ?? '',
      role: json['role']?.toString() ?? 'User',
      action: json['action']?.toString() ?? 'Ditolak',
      processedBy: json['processedBy']?.toString() ?? '',
      dateTime: DateTime.tryParse(
            json['dateTime']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}

// ============================================================
// DATA APLIKASI
// ============================================================
class AppData {
  static const String _usersKey = 'users_v1';
  static const String _itemsKey = 'items_v1';
  static const String _approvalHistoryKey = 'approval_history_v1';

  static List<UserAccount> registeredUsers = [];
  static List<ItemModel> globalItemList = [];
  static List<ApprovalHistory> approvalHistory = [];

  static bool _loaded = false;

  static UserAccount _seedSuperAdmin() {
    return UserAccount(
      username: 'adminutama',
      password: '123456',
      role: UserAccount.roleSuperAdmin,
      isApproved: true,
    );
  }

  // Memuat akun, entry, dan riwayat saat aplikasi dibuka.
  static Future<void> load() async {
    if (_loaded) return;

    final prefs = await SharedPreferences.getInstance();

    final usersRaw = prefs.getString(_usersKey);
    final itemsRaw = prefs.getString(_itemsKey);
    final historyRaw = prefs.getString(_approvalHistoryKey);

    // Memuat akun terdaftar.
    if (usersRaw != null) {
      try {
        final decoded = jsonDecode(usersRaw) as List;

        registeredUsers = decoded
            .map(
              (e) => UserAccount.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      } catch (_) {
        registeredUsers = [];
      }

      registeredUsers.removeWhere(
        (u) => u.username.toLowerCase() == 'admin1',
      );

      if (!registeredUsers.any((u) => u.isSuperAdmin)) {
        registeredUsers.insert(0, _seedSuperAdmin());
      }

      for (final user in registeredUsers) {
        if (user.isSuperAdmin) {
          user.isApproved = true;
        }
      }
    } else {
      registeredUsers = [_seedSuperAdmin()];
    }

    // Memuat kembali Task dan Inventaris yang tersimpan.
    if (itemsRaw != null) {
      try {
        final decodedItems = jsonDecode(itemsRaw) as List;

        globalItemList = decodedItems
            .map(
              (e) => ItemModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      } catch (_) {
        globalItemList = [];
      }
    } else {
      globalItemList = [];
    }

    // Memuat riwayat persetujuan.
    if (historyRaw != null) {
      try {
        final decodedHistory = jsonDecode(historyRaw) as List;

        approvalHistory = decodedHistory
            .map(
              (e) => ApprovalHistory.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      } catch (_) {
        approvalHistory = [];
      }
    } else {
      approvalHistory = [];
    }

    _loaded = true;
    await save();
  }

  // Menyimpan akun, entry, dan riwayat ke penyimpanan lokal.
  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _usersKey,
      jsonEncode(
        registeredUsers.map((u) => u.toJson()).toList(),
      ),
    );

    await prefs.setString(
      _itemsKey,
      jsonEncode(
        globalItemList.map((item) => item.toJson()).toList(),
      ),
    );

    await prefs.setString(
      _approvalHistoryKey,
      jsonEncode(
        approvalHistory.map((h) => h.toJson()).toList(),
      ),
    );
  }

  // Mendaftarkan akun baru.
  static Future<bool> registerUser(UserAccount user) async {
    final exists = registeredUsers.any(
      (u) => u.username.toLowerCase() == user.username.toLowerCase(),
    );

    if (exists) return false;

    user.isApproved = false;
    registeredUsers.add(user);

    await save();
    return true;
  }

  // Semua entry baru otomatis Pending.
  static Future<void> addItem(
    ItemModel item, {
    required bool submittedByAdmin,
  }) async {
    item.status = 'Pending';
    globalItemList.insert(0, item);

    await save();
  }

  // Mengubah status hanya oleh Admin atau Admin Utama.
  static Future<bool> updateItemStatus(
    ItemModel item,
    String newStatus,
    UserAccount actor,
  ) async {
    if (!actor.isAdmin) return false;

    const allowedStatuses = ['Pending', 'Proses', 'Selesai'];

    if (!allowedStatuses.contains(newStatus)) return false;

    final index = globalItemList.indexWhere((i) => i.id == item.id);

    if (index == -1) return false;

    globalItemList[index].status = newStatus;

    await save();
    return true;
  }

  // Hanya Admin Utama yang dapat menyetujui akun.
  static Future<bool> approveUser(
    UserAccount target,
    UserAccount actor,
  ) async {
    if (!actor.isSuperAdmin) return false;

    final index = registeredUsers.indexWhere(
      (u) => u.username == target.username,
    );

    if (index == -1) return false;

    final user = registeredUsers[index];

    if (user.isApproved) return false;

    user.isApproved = true;

    approvalHistory.insert(
      0,
      ApprovalHistory(
        username: user.username,
        role: user.roleLabel,
        action: 'Disetujui',
        processedBy: actor.username,
        dateTime: DateTime.now(),
      ),
    );

    await save();
    return true;
  }

  // Hanya Admin Utama yang dapat menolak akun.
  static Future<bool> rejectUser(
    UserAccount target,
    UserAccount actor,
  ) async {
    if (!actor.isSuperAdmin) return false;
    if (target.isSuperAdmin) return false;

    final index = registeredUsers.indexWhere(
      (u) => u.username == target.username,
    );

    if (index == -1) return false;

    final user = registeredUsers[index];

    approvalHistory.insert(
      0,
      ApprovalHistory(
        username: user.username,
        role: user.roleLabel,
        action: 'Ditolak',
        processedBy: actor.username,
        dateTime: DateTime.now(),
      ),
    );

    registeredUsers.removeAt(index);

    await save();
    return true;
  }

  // Hanya Admin dan Admin Utama yang dapat menghapus entry.
  static Future<bool> deleteItem(
    String id,
    UserAccount actor,
  ) async {
    if (!actor.isAdmin) return false;

    final index = globalItemList.indexWhere((i) => i.id == id);

    if (index == -1) return false;

    globalItemList.removeAt(index);

    await save();
    return true;
  }
}

// ============================================================
// WARNA APLIKASI
// ============================================================
class AppColors {
  static const bg = Color(0xFF020617);
  static const surface = Color(0xFF0A1428);
  static const card = Color(0xFF0F1D38);
  static const border = Color(0xFF1E3358);
  static const primary = Color(0xFF1D4ED8);
  static const primaryDark = Color(0xFF1E3A8A);
  static const accent = Color(0xFF38BDF8);
  static const text = Color(0xFFE2E8F0);
  static const muted = Color(0xFF94A3B8);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
}

Color statusColor(String status) {
  switch (status) {
    case 'Pending':
      return AppColors.danger;
    case 'Proses':
      return AppColors.warning;
    case 'Selesai':
      return AppColors.success;
    default:
      return AppColors.muted;
  }
}

// ============================================================
// INPUT DECORATION
// ============================================================
InputDecoration appInputDecoration({
  required String label,
  String? hint,
  IconData? icon,
  Widget? suffix,
}) {
  OutlineInputBorder makeBorder(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: AppColors.muted),
    hintStyle: TextStyle(color: AppColors.muted.withAlpha(140)),
    prefixIcon: icon == null
        ? null
        : Icon(icon, size: 22, color: AppColors.muted),
    suffixIcon: suffix,
    filled: true,
    fillColor: AppColors.card,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    border: makeBorder(AppColors.border),
    enabledBorder: makeBorder(AppColors.border),
    focusedBorder: makeBorder(AppColors.accent, 2),
    errorBorder: makeBorder(AppColors.danger),
    focusedErrorBorder: makeBorder(AppColors.danger, 2),
  );
}

// ============================================================
// NOTIFIKASI
// ============================================================
void showAppSnack(
  BuildContext context,
  String message, {
  Color color = AppColors.primary,
  IconData icon = Icons.info_outline_rounded,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

// ============================================================
// LATAR BELAKANG
// ============================================================
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF000814),
            Color(0xFF0A1B3D),
            Color(0xFF020617),
          ],
        ),
      ),
      child: child,
    );
  }
}

// ============================================================
// SEGMENT BAR
// ============================================================
class SegmentBar extends StatelessWidget {
  final List<MapEntry<int, Color>> segments;
  final double height;

  const SegmentBar({
    super.key,
    required this.segments,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    final visible = segments.where((s) => s.key > 0).toList();

    if (visible.isEmpty) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: height,
        child: Row(
          children: visible
              .map(
                (s) => Expanded(
                  flex: s.key,
                  child: ColoredBox(color: s.value),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ============================================================
// LEGEND DOT
// ============================================================
class LegendDot extends StatelessWidget {
  final String label;
  final Color color;

  const LegendDot({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SUMMARY CARD
// ============================================================
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BARIS MENU
// ============================================================
class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuRow(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AppColors.text)),
      ],
    );
  }
}

// ============================================================
// KARTU TASK DAN INVENTARIS
// ============================================================
class ItemCard extends StatelessWidget {
  final ItemModel item;
  final UserAccount user;
  final VoidCallback onChanged;

  const ItemCard({
    super.key,
    required this.item,
    required this.user,
    required this.onChanged,
  });

  // Hanya Admin dan Admin Utama yang bisa menghapus.
  bool get _canDelete => user.isAdmin;

  Future<void> _delete(BuildContext context) async {
    if (!user.isAdmin) {
      showAppSnack(
        context,
        'Hanya Admin dan Admin Utama yang bisa menghapus.',
        color: AppColors.danger,
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'Hapus Record?',
          style: TextStyle(color: AppColors.text),
        ),
        content: Text(
          '"${item.title}" akan dihapus.',
          style: const TextStyle(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final deleted = await AppData.deleteItem(item.id, user);

    if (!context.mounted) return;

    if (!deleted) {
      showAppSnack(
        context,
        'Kamu tidak memiliki izin untuk menghapus.',
        color: AppColors.danger,
      );
      return;
    }

    showAppSnack(
      context,
      'Record berhasil dihapus',
      color: AppColors.danger,
      icon: Icons.delete_outline_rounded,
    );

    onChanged();
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.muted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DETAIL RECORD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const Divider(height: 28, color: AppColors.border),
            _detailRow('Kategori', item.category),
            _detailRow('Status', item.status),
            _detailRow('Dibuat oleh', item.createdBy),
            _detailRow(
              'Deskripsi',
              item.description.isEmpty ? '-' : item.description,
            ),
          ],
        ),
      ),
    );
  }

  void _changeStatus(BuildContext context) {
    if (!user.isAdmin) return;

    String temp = item.status;

    const options = [
      ['Pending', 'Pending Approval'],
      ['Proses', 'In-Progress (Proses)'],
      ['Selesai', 'Completed (Selesai)'],
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'UBAH STATUS (ADMIN)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((option) {
                final isSelected = temp == option[0];

                return GestureDetector(
                  onTap: () {
                    setModal(() {
                      temp = option[0];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? statusColor(option[0]).withAlpha(35)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? statusColor(option[0])
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: statusColor(option[0]),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option[1],
                            style: const TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await AppData.updateItemStatus(
                      item,
                      temp,
                      user,
                    );

                    if (!ctx.mounted) return;
                    Navigator.pop(ctx);

                    if (context.mounted) {
                      showAppSnack(
                        context,
                        success
                            ? 'Status berhasil diperbarui'
                            : 'Gagal memperbarui status',
                        color: success
                            ? AppColors.success
                            : AppColors.danger,
                      );
                    }

                    onChanged();
                  },
                  child: const Text('Simpan Perubahan Status'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isInv = item.category == 'Inventaris';
    final accent = isInv ? AppColors.warning : AppColors.accent;
    final sColor = statusColor(item.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isInv
                  ? Icons.inventory_2_outlined
                  : Icons.task_alt_rounded,
              color: accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                    Text(
                      'By: ${item.createdBy}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: sColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_canDelete)
            IconButton(
              tooltip: 'Hapus',
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.danger,
              ),
              onPressed: () => _delete(context),
            ),
          PopupMenuButton<String>(
            color: AppColors.card,
            onSelected: (value) {
              if (value == 'detail') _showDetail(context);
              if (value == 'status') _changeStatus(context);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'detail',
                child: _MenuRow(
                  Icons.info_outline_rounded,
                  'Detail',
                ),
              ),
              if (user.isAdmin)
                const PopupMenuItem(
                  value: 'status',
                  child: _MenuRow(
                    Icons.edit_note_rounded,
                    'Ubah Status',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}