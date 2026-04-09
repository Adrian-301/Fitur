import 'package:flutter/material.dart';

// Model Program Favorit
class ProgramFavorit {
  final String id;
  final String judul;
  final String presenter;
  final String jamSiaran;
  final String hari;
  final String deskripsi;
  final IconData ikon;
  final Color warna;
  final DateTime ditambahkan;

  ProgramFavorit({
    required this.id,
    required this.judul,
    required this.presenter,
    required this.jamSiaran,
    required this.hari,
    required this.deskripsi,
    required this.ikon,
    required this.warna,
    required this.ditambahkan,
  });
}

// Program Favorit Screen

class FavoritProgramScreen extends StatefulWidget {
  const FavoritProgramScreen({super.key});

  @override
  State<FavoritProgramScreen> createState() => _FavoritProgramScreenState();
}

class _FavoritProgramScreenState extends State<FavoritProgramScreen> {
  final List<ProgramFavorit> _favoritList = [
    ProgramFavorit(
      id: '1',
      judul: 'Urban Morning Vibes',
      presenter: 'DJ Reza & Karina',
      jamSiaran: '06:00 – 09:00',
      hari: 'Senin – Jumat',
      deskripsi: 'Mulai pagi dengan energi positif bersama hits terbaik.',
      ikon: Icons.wb_sunny_rounded,
      warna: const Color(0xFFF59E0B),
      ditambahkan: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ProgramFavorit(
      id: '2',
      judul: 'Urban Night Sessions',
      presenter: 'DJ Luna',
      jamSiaran: '21:00 – 00:00',
      hari: 'Setiap Hari',
      deskripsi: 'Deep vibes dan chill music untuk menutup harimu.',
      ikon: Icons.nights_stay_rounded,
      warna: const Color(0xFF7C3AED),
      ditambahkan: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  // Daftar semua program yang tersedia untuk dipilih
  final List<Map<String, dynamic>> _semuaProgram = [
    {
      'judul': 'Urban Morning Vibes',
      'presenter': 'DJ Reza & Karina',
      'jamSiaran': '06:00 – 09:00',
      'hari': 'Senin – Jumat',
      'deskripsi': 'Mulai pagi dengan energi positif bersama hits terbaik.',
      'ikon': Icons.wb_sunny_rounded,
      'warna': const Color(0xFFF59E0B),
    },
    {
      'judul': 'The Rush Hour',
      'presenter': 'DJ Andre',
      'jamSiaran': '16:00 – 19:00',
      'hari': 'Senin – Jumat',
      'deskripsi':
          'Teman setia perjalanan pulang kamu dengan lagu-lagu terpopuler.',
      'ikon': Icons.directions_car_rounded,
      'warna': const Color(0xFFEF4444),
    },
    {
      'judul': 'Urban Night Sessions',
      'presenter': 'DJ Luna',
      'jamSiaran': '21:00 – 00:00',
      'hari': 'Setiap Hari',
      'deskripsi': 'Deep vibes dan chill music untuk menutup harimu.',
      'ikon': Icons.nights_stay_rounded,
      'warna': const Color(0xFF7C3AED),
    },
    {
      'judul': 'Weekend Takeover',
      'presenter': 'DJ Bima & Sari',
      'jamSiaran': '13:00 – 17:00',
      'hari': 'Sabtu – Minggu',
      'deskripsi': 'Full weekend energy! Non-stop hits dan games seru.',
      'ikon': Icons.celebration_rounded,
      'warna': const Color(0xFF10B981),
    },
    {
      'judul': 'Deep Talk Radio',
      'presenter': 'Nadia & Tim',
      'jamSiaran': '19:00 – 21:00',
      'hari': 'Selasa & Kamis',
      'deskripsi':
          'Diskusi mendalam tentang isu sosial, budaya, dan gaya hidup.',
      'ikon': Icons.mic_rounded,
      'warna': const Color(0xFF3B82F6),
    },
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _tambahFavorit(Map<String, dynamic> program) {
    final sudahAda = _favoritList.any((f) => f.judul == program['judul']);
    if (sudahAda) {
      _showSnackbar('Program sudah ada di favorit', isError: true);
      return;
    }

    setState(() {
      _favoritList.add(
        ProgramFavorit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          judul: program['judul'],
          presenter: program['presenter'],
          jamSiaran: program['jamSiaran'],
          hari: program['hari'],
          deskripsi: program['deskripsi'],
          ikon: program['ikon'],
          warna: program['warna'],
          ditambahkan: DateTime.now(),
        ),
      );
    });
    _showSnackbar('${program['judul']} ditambahkan ke favorit');
  }

  void _hapusFavorit(String id, String judul) {
    setState(() => _favoritList.removeWhere((f) => f.id == id));
    _showSnackbar('$judul dihapus dari favorit');
  }

  void _showSnackbar(String pesan, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          pesan,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        backgroundColor: isError
            ? const Color(0xFFEF4444)
            : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<ProgramFavorit> get _filteredFavorit {
    if (_searchQuery.isEmpty) return _favoritList;
    return _favoritList
        .where(
          (f) =>
              f.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              f.presenter.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void _showTambahDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TambahProgramSheet(
        semuaProgram: _semuaProgram,
        favoritList: _favoritList,
        onTambah: _tambahFavorit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildSearchBar()),
          if (_favoritList.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else if (_filteredFavorit.isEmpty)
            SliverFillRemaining(child: _buildNoResult())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _FavoritCard(
                      program: _filteredFavorit[index],
                      onHapus: () => _hapusFavorit(
                        _filteredFavorit[index].id,
                        _filteredFavorit[index].judul,
                      ),
                    ),
                  ),
                  childCount: _filteredFavorit.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTambahDialog,
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Tambah Program',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFF0A0A14),
      surfaceTintColor: Colors.transparent,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Program Favorit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Urban Radio 106.3 FM',
            style: TextStyle(
              color: Color(0xFFA855F7),
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF7C3AED).withOpacity(0.3),
              width: 0.5,
            ),
          ),
          child: Text(
            '${_favoritList.length} Program',
            style: const TextStyle(
              color: Color(0xFFA855F7),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 0.5,
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Cari program favorit...',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 20,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withOpacity(0.3),
                      size: 18,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: const Color(0xFF7C3AED).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum Ada Program Favorit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan program siaran favoritmu\nagar mudah ditemukan kembali.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 40,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'Tidak ditemukan',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Favorit Card

class _FavoritCard extends StatelessWidget {
  final ProgramFavorit program;
  final VoidCallback onHapus;

  const _FavoritCard({required this.program, required this.onHapus});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(program.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onHapus(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_rounded, color: Color(0xFFEF4444), size: 22),
            SizedBox(height: 4),
            Text(
              'Hapus',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: program.warna.withOpacity(0.15),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: program.warna.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Icon(program.ikon, color: program.warna, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.judul,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    program.presenter,
                    style: TextStyle(
                      color: program.warna,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 10,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${program.hari}  ·  ${program.jamSiaran}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _konfirmasiHapus(context),
              icon: Icon(
                Icons.favorite_rounded,
                color: const Color(0xFF7C3AED).withOpacity(0.7),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _konfirmasiHapus(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus dari Favorit?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Text(
          'Hapus "${program.judul}" dari daftar program favorit?',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onHapus();
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tambah Program

class _TambahProgramSheet extends StatefulWidget {
  final List<Map<String, dynamic>> semuaProgram;
  final List<ProgramFavorit> favoritList;
  final Function(Map<String, dynamic>) onTambah;

  const _TambahProgramSheet({
    required this.semuaProgram,
    required this.favoritList,
    required this.onTambah,
  });

  @override
  State<_TambahProgramSheet> createState() => _TambahProgramSheetState();
}

class _TambahProgramSheetState extends State<_TambahProgramSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pilih Program',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tambahkan ke daftar program favorit kamu',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.semuaProgram.map((program) {
            final sudahFavorit =
                widget.favoritList.any((f) => f.judul == program['judul']);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ProgramPilihan(
                program: program,
                sudahFavorit: sudahFavorit,
                onTambah: () {
                  widget.onTambah(program);
                  setState(() {});
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ProgramPilihan extends StatelessWidget {
  final Map<String, dynamic> program;
  final bool sudahFavorit;
  final VoidCallback onTambah;

  const _ProgramPilihan({
    required this.program,
    required this.sudahFavorit,
    required this.onTambah,
  });

  @override
  Widget build(BuildContext context) {
    final Color warna = program['warna'] as Color;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sudahFavorit
            ? const Color(0xFF7C3AED).withOpacity(0.08)
            : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: sudahFavorit
              ? const Color(0xFF7C3AED).withOpacity(0.3)
              : Colors.white.withOpacity(0.06),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: warna.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              program['ikon'] as IconData,
              color: warna,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program['judul'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${program['hari']}  ·  ${program['jamSiaran']}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: sudahFavorit ? null : onTambah,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: sudahFavorit
                    ? const Color(0xFF7C3AED).withOpacity(0.15)
                    : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                sudahFavorit
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: sudahFavorit
                    ? const Color(0xFFA855F7)
                    : Colors.white.withOpacity(0.3),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
