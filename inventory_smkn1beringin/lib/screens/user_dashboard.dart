import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'login_screen.dart';
import 'add_item_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  final UserAccount user;
  const UserDashboardScreen({super.key, required this.user});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  String _selectedCategoryFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final items = AppData.globalItemList;
    final totalItems = items.length;
    final totalTask = items.where((i) => i.category == 'Task').length;
    final totalInventaris = items.where((i) => i.category == 'Inventaris').length;
    final totalPending = items.where((i) => i.status == 'Pending').length;
    final totalProses = items.where((i) => i.status == 'Proses').length;
    final totalSelesai = items.where((i) => i.status == 'Selesai').length;

    final filteredList = items.where((item) {
      if (_selectedCategoryFilter == 'All') return true;
      return item.category == _selectedCategoryFilter;
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
              child: const Icon(Icons.dashboard_rounded,
                  size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('User Workspace',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text('Akun: ${widget.user.username}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.muted),
            tooltip: 'Logout',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
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
              // --- Banner ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selamat Datang, ${widget.user.username}!',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text(
                            'Pantau status inventaris dan tugas operasional Anda.',
                            style: TextStyle(
                                color: Color(0xFFBFDBFE), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.analytics_rounded,
                        size: 48, color: Colors.white30),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Ringkasan ---
              const Text('RINGKASAN METRIK',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.muted)),
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
                      title: 'Total Item',
                      value: '$totalItems',
                      icon: Icons.inventory_2_outlined,
                      color: AppColors.accent),
                  SummaryCard(
                      title: 'Total Task',
                      value: '$totalTask',
                      icon: Icons.task_alt_rounded,
                      color: const Color(0xFF60A5FA)),
                  SummaryCard(
                      title: 'Inventaris',
                      value: '$totalInventaris',
                      icon: Icons.widgets_outlined,
                      color: AppColors.warning),
                  SummaryCard(
                      title: 'Pending',
                      value: '$totalPending',
                      icon: Icons.pending_actions_rounded,
                      color: AppColors.danger),
                ],
              ),
              const SizedBox(height: 24),

              // --- Chart ---
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('Penyelesaian Status Task & Inventaris',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text)),
                        ),
                        Icon(Icons.bar_chart_rounded, color: AppColors.accent),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SegmentBar(segments: [
                      MapEntry(totalSelesai, AppColors.success),
                      MapEntry(totalProses, AppColors.warning),
                      MapEntry(totalPending, AppColors.danger),
                    ]),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        LegendDot(
                            label: 'Selesai: $totalSelesai',
                            color: AppColors.success),
                        LegendDot(
                            label: 'Proses: $totalProses',
                            color: AppColors.warning),
                        LegendDot(
                            label: 'Pending: $totalPending',
                            color: AppColors.danger),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // --- Header + Filter ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Daftar Record Data',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text)),
                  Text('${filteredList.length} Item',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: ['All', 'Task', 'Inventaris'].map((category) {
                  final isSelected = _selectedCategoryFilter == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.card,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.muted,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.border),
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedCategoryFilter = category),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // --- List ---
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
                      Icon(Icons.inbox_rounded,
                          size: 48, color: AppColors.muted),
                      SizedBox(height: 12),
                      Text('Belum Ada Data Tersedia',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.text)),
                      SizedBox(height: 4),
                      Text('Gunakan tombol di bawah untuk menambah record baru.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 12, color: AppColors.muted)),
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
                builder: (context) => AddItemScreen(user: widget.user)),
          );
          if (result == true) setState(() {});
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Entry',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}