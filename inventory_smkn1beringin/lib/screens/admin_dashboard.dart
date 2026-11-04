import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'login_screen.dart';
import 'add_item_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final UserAccount user;

  const AdminDashboardScreen({
    super.key,
    required this.user,
  });

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {
  String _selectedStatusFilter = 'All';

  bool get _isSuper => widget.user.isSuperAdmin;

  List<UserAccount> get _pendingUsers =>
      AppData.registeredUsers
          .where((u) => !u.isApproved)
          .toList();

  Future<void> _approve(UserAccount user) async {
    if (!_isSuper) return;

    final success = await AppData.approveUser(
      user,
      widget.user,
    );

    if (!mounted) return;

    setState(() {});

    showAppSnack(
      context,
      success
          ? 'Akun "${user.username}" disetujui'
          : 'Akun gagal disetujui',
      color: success
          ? AppColors.success
          : AppColors.danger,
      icon: success
          ? Icons.check_circle_outline_rounded
          : Icons.error_outline_rounded,
    );
  }

  Future<void> _reject(UserAccount user) async {
    if (!_isSuper) return;

    final success = await AppData.rejectUser(
      user,
      widget.user,
    );

    if (!mounted) return;

    setState(() {});

    showAppSnack(
      context,
      success
          ? 'Registrasi "${user.username}" ditolak'
          : 'Registrasi gagal ditolak',
      color: success
          ? AppColors.danger
          : AppColors.warning,
      icon: success
          ? Icons.cancel_outlined
          : Icons.error_outline_rounded,
    );
  }

  Widget _buildApprovalSection() {
    final pending = _pendingUsers;

    if (!_isSuper) {
      if (pending.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.lock_clock_rounded,
              color: AppColors.warning,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${pending.length} akun menunggu persetujuan Admin Utama.',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PERSETUJUAN REGISTRASI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.muted,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: pending.isEmpty
                      ? AppColors.border
                      : AppColors.warning.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${pending.length} menunggu',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: pending.isEmpty
                        ? AppColors.muted
                        : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (pending.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Tidak ada permintaan registrasi baru.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.muted,
                ),
              ),
            )
          else
            ...pending.map(
              (user) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.fromLTRB(
                  14,
                  10,
                  6,
                  10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warning.withAlpha(110),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 20,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            'Mendaftar sebagai ${user.roleLabel}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Setujui',
                      icon: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 28,
                      ),
                      onPressed: () => _approve(user),
                    ),
                    IconButton(
                      tooltip: 'Tolak',
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: AppColors.danger,
                        size: 28,
                      ),
                      onPressed: () => _reject(user),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    if (!_isSuper) return const SizedBox.shrink();

    final history = AppData.approvalHistory;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: AppColors.accent,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'RIWAYAT PERSETUJUAN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (history.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Belum ada riwayat persetujuan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.muted,
                ),
              ),
            )
          else
            ...history.map((entry) {
              final approved = entry.action == 'Disetujui';
              final color = approved
                  ? AppColors.success
                  : AppColors.danger;

              final date = entry.dateTime;
              final dateText =
                  '${date.day.toString().padLeft(2, '0')}/'
                  '${date.month.toString().padLeft(2, '0')}/'
                  '${date.year}';
              final timeText =
                  '${date.hour.toString().padLeft(2, '0')}:'
                  '${date.minute.toString().padLeft(2, '0')}';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: color.withAlpha(35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        approved
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${entry.role} • ${entry.action}',
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Diproses oleh: ${entry.processedBy}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '$dateText • $timeText',
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
            }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = AppData.globalItemList;
    final totalItems = items.length;
    final totalPending =
        items.where((i) => i.status == 'Pending').length;
    final totalProses =
        items.where((i) => i.status == 'Proses').length;
    final totalSelesai =
        items.where((i) => i.status == 'Selesai').length;
    final totalTask =
        items.where((i) => i.category == 'Task').length;
    final totalInventaris =
        items.where((i) => i.category == 'Inventaris').length;

    final filteredList = items.where((item) {
      if (_selectedStatusFilter == 'All') return true;
      return item.status == _selectedStatusFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isSuper ? 'Admin Utama' : 'Admin Control Center',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Akun: ${widget.user.username}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.muted,
            ),
            tooltip: 'Logout',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(70),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Panel Pengawasan & Validasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Terdapat $totalPending record berstatus Pending yang perlu ditindaklanjuti.',
                            style: const TextStyle(
                              color: Color(0xFFBFDBFE),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.security_rounded,
                      size: 48,
                      color: Colors.white30,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildApprovalSection(),
              _buildHistorySection(),

              const Text(
                'RINGKASAN OPERASIONAL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SummaryCard(
                    title: 'Need Action',
                    value: '$totalPending',
                    icon: Icons.pending_actions_rounded,
                    color: AppColors.danger,
                  ),
                  SummaryCard(
                    title: 'In Progress',
                    value: '$totalProses',
                    icon: Icons.sync_rounded,
                    color: AppColors.warning,
                  ),
                  SummaryCard(
                    title: 'Completed',
                    value: '$totalSelesai',
                    icon: Icons.verified_rounded,
                    color: AppColors.success,
                  ),
                  SummaryCard(
                    title: 'Total Data',
                    value: '$totalItems',
                    icon: Icons.storage_rounded,
                    color: AppColors.accent,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Analisis Distribusi Data',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        Icon(
                          Icons.pie_chart_outline_rounded,
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Proporsi Kategori:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentBar(
                      height: 10,
                      segments: [
                        MapEntry(totalTask, AppColors.accent),
                        MapEntry(
                          totalInventaris,
                          AppColors.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        LegendDot(
                          label: 'Task ($totalTask)',
                          color: AppColors.accent,
                        ),
                        LegendDot(
                          label: 'Inventaris ($totalInventaris)',
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Proporsi Status:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentBar(
                      height: 10,
                      segments: [
                        MapEntry(totalSelesai, AppColors.success),
                        MapEntry(totalProses, AppColors.warning),
                        MapEntry(totalPending, AppColors.danger),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Manajemen Record',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    '${filteredList.length} Items',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Pending', 'Proses', 'Selesai']
                      .map((status) {
                    final selected =
                        _selectedStatusFilter == status;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(status),
                        selected: selected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.card,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppColors.muted,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: selected
                                ? AppColors.accent
                                : AppColors.border,
                          ),
                        ),
                        onSelected: (_) {
                          setState(() {
                            _selectedStatusFilter = status;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              if (filteredList.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.folder_off_outlined,
                        size: 48,
                        color: AppColors.muted,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tidak Ada Data Dalam Kategori Ini',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...filteredList.map(
                  (item) => ItemCard(
                    key: ValueKey(item.id),
                    item: item,
                    user: widget.user,
                    onChanged: () => setState(() {}),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddItemScreen(user: widget.user),
            ),
          );

          if (result == true && mounted) {
            setState(() {});
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Entry',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}