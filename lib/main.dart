import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'playlist.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const UrbanRadioApp());
}

class UrbanRadioApp extends StatelessWidget {
  const UrbanRadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urban Radio 106.3 FM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}

// Data Models
class Program {
  final String judul;
  final String presenter;
  final String jamMulai;
  final String jamSelesai;
  final String deskripsi;
  final IconData ikon;
  final Color warna;
  final bool sedangBerjalan;

  const Program({
    required this.judul,
    required this.presenter,
    required this.jamMulai,
    required this.jamSelesai,
    required this.deskripsi,
    required this.ikon,
    required this.warna,
    this.sedangBerjalan = false,
  });
}

class Berita {
  final String judul;
  final String ringkasan;
  final String waktu;
  final String kategori;

  const Berita({
    required this.judul,
    required this.ringkasan,
    required this.waktu,
    required this.kategori,
  });
}

// Dummy Data
final List<Program> daftarProgram = [
  const Program(
    judul: 'Urban Morning Vibes',
    presenter: 'DJ Reza & Karina',
    jamMulai: '06:00',
    jamSelesai: '09:00',
    deskripsi: 'Mulai pagi dengan energi positif bersama hits terbaik.',
    ikon: Icons.wb_sunny_rounded,
    warna: Color(0xFFF59E0B),
    sedangBerjalan: false,
  ),
  const Program(
    judul: 'The Rush Hour',
    presenter: 'DJ Andre',
    jamMulai: '16:00',
    jamSelesai: '19:00',
    deskripsi:
        'Teman setia perjalanan pulang kamu dengan lagu-lagu terpopuler.',
    ikon: Icons.directions_car_rounded,
    warna: Color(0xFFEF4444),
    sedangBerjalan: true,
  ),
  const Program(
    judul: 'Urban Night Sessions',
    presenter: 'DJ Luna',
    jamMulai: '21:00',
    jamSelesai: '00:00',
    deskripsi: 'Deep vibes dan chill music untuk menutup harimu.',
    ikon: Icons.nights_stay_rounded,
    warna: Color(0xFF7C3AED),
    sedangBerjalan: false,
  ),
  const Program(
    judul: 'Weekend Takeover',
    presenter: 'DJ Bima & Sari',
    jamMulai: '13:00',
    jamSelesai: '17:00',
    deskripsi: 'Full weekend energy! Non-stop hits dan games seru.',
    ikon: Icons.celebration_rounded,
    warna: Color(0xFF10B981),
    sedangBerjalan: false,
  ),
];

final List<Berita> daftarBerita = [
  const Berita(
    judul: 'Urban Radio Raih Penghargaan Radio Terbaik 2024',
    ringkasan:
        'Urban Radio 106.3 FM berhasil meraih penghargaan Best Urban Radio Station dari KPI Awards tahun ini.',
    waktu: '2 jam lalu',
    kategori: 'Penghargaan',
  ),
  const Berita(
    judul: 'Konser Urban Fest akan Digelar Bulan Depan',
    ringkasan:
        'Urban Radio menghadirkan konser musik Urban Fest dengan lineup artis internasional dan lokal terbaik.',
    waktu: '5 jam lalu',
    kategori: 'Event',
  ),
  const Berita(
    judul: 'DJ Reza Rilis Single Baru Kolaborasi dengan Raisa',
    ringkasan:
        'Presenter Urban Morning Vibes, DJ Reza, merilis single kolaborasi terbaru yang langsung masuk tangga lagu.',
    waktu: '1 hari lalu',
    kategori: 'Musik',
  ),
];

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    const _HomeContent(),
    const FavoritProgramScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1E),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08), width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.radio_rounded,
                label: 'Beranda',
                isActive: _selectedIndex == 0,
                pulseAnimation:
                    _selectedIndex == 0 ? _pulseAnimation : null,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _NavItem(
                icon: Icons.favorite_rounded,
                label: 'Program Favorit',
                isActive: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Animation<double>? pulseAnimation;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color:
              isActive
                  ? const Color(0xFF7C3AED).withOpacity(0.15)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            pulseAnimation != null
                ? AnimatedBuilder(
                  animation: pulseAnimation!,
                  builder:
                      (context, child) => Transform.scale(
                        scale: pulseAnimation!.value,
                        child: Icon(
                          icon,
                          color:
                              isActive
                                  ? const Color(0xFFA855F7)
                                  : Colors.white38,
                          size: 22,
                        ),
                      ),
                )
                : Icon(
                  icon,
                  color:
                      isActive ? const Color(0xFFA855F7) : Colors.white38,
                  size: 22,
                ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFA855F7),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Home Content
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(child: _buildOnAirBanner()),
        SliverToBoxAdapter(child: _buildSectionHeader('Jadwal Siaran')),
        SliverToBoxAdapter(child: _buildJadwalSiaran()),
        SliverToBoxAdapter(child: _buildSectionHeader('Berita & Artikel')),
        SliverToBoxAdapter(child: _buildBeritaList()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
      backgroundColor: const Color(0xFF0A0A14),
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A0A2E), Color(0xFF0A0A14)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF7C3AED).withOpacity(0.4),
                        width: 0.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.radio_rounded,
                      color: Color(0xFFA855F7),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'URBAN RADIO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        '106.3 FM · Jakarta',
                        style: TextStyle(
                          color: Color(0xFFA855F7),
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _LiveBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnAirBanner() {
    final program = daftarProgram.firstWhere(
      (p) => p.sedangBerjalan,
      orElse: () => daftarProgram[0],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              program.warna.withOpacity(0.25),
              program.warna.withOpacity(0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: program.warna.withOpacity(0.4),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      _PulseDot(),
                      SizedBox(width: 5),
                      Text(
                        'ON AIR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '${program.jamMulai} – ${program.jamSelesai}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: program.warna.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: program.warna.withOpacity(0.5),
                      width: 0.5,
                    ),
                  ),
                  child: Icon(program.ikon, color: program.warna, size: 26),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        program.presenter,
                        style: TextStyle(
                          color: program.warna,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              program.deskripsi,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFFA855F7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalSiaran() {
    return SizedBox(
      height: 168,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: daftarProgram.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final p = daftarProgram[index];
          return _ProgramCard(program: p);
        },
      ),
    );
  }

  Widget _buildBeritaList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: daftarBerita
            .map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _BeritaCard(berita: b),
                ))
            .toList(),
      ),
    );
  }
}

// Program
class _ProgramCard extends StatelessWidget {
  final Program program;
  const _ProgramCard({required this.program});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: program.sedangBerjalan
              ? program.warna.withOpacity(0.5)
              : Colors.white.withOpacity(0.06),
          width: program.sedangBerjalan ? 1 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: program.warna.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(program.ikon, color: program.warna, size: 16),
              ),
              const Spacer(),
              if (program.sedangBerjalan)
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            program.judul,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${program.jamMulai} – ${program.jamSelesai}',
            style: TextStyle(color: program.warna, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// Berita
class _BeritaCard extends StatelessWidget {
  final Berita berita;
  const _BeritaCard({required this.berita});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  berita.kategori,
                  style: const TextStyle(
                    color: Color(0xFFA855F7),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                berita.waktu,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            berita.judul,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            berita.ringkasan,
            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontSize: 11,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Live Badge
class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEF4444).withOpacity(0.4),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Opacity(
              opacity: _anim.value,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            'LIVE',
            style: TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Pulse Dot (static version for inside containers)

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: 0.5 + _ctrl.value * 0.5,
        child: Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
