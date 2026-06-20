import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_flutter_app/core/di/injection_container.dart';
import 'package:my_flutter_app/core/routes/app_routes.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/core/widgets/section_header.dart';
import 'package:my_flutter_app/presentation/cubits/doctor/doctor_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/doctor/doctor_state.dart';
import 'package:my_flutter_app/presentation/cubits/hospital/hospital_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/hospital/hospital_state.dart';
import 'package:my_flutter_app/presentation/cubits/navigation/navigation_cubit.dart';
import 'package:my_flutter_app/presentation/screens/chat/chat_screen.dart';
import 'package:my_flutter_app/presentation/screens/doctors/doctors_screen.dart';
import 'package:my_flutter_app/presentation/screens/profile/profile_screen.dart';
import 'package:my_flutter_app/presentation/widgets/doctor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NavigationCubit _navCubit;
  late final DoctorCubit _doctorCubit;
  late final HospitalCubit _hospitalCubit;

  @override
  void initState() {
    super.initState();
    _navCubit = sl<NavigationCubit>();
    _doctorCubit = sl<DoctorCubit>()..loadDoctors();
    _hospitalCubit = sl<HospitalCubit>()..loadHospitals();
  }

  @override
  void dispose() {
    _navCubit.close();
    _doctorCubit.close();
    _hospitalCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _navCubit),
        BlocProvider.value(value: _doctorCubit),
        BlocProvider.value(value: _hospitalCubit),
      ],
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: [
                _buildHomeTab(),
                const ChatScreen(),
                BlocProvider.value(
                  value: _doctorCubit,
                  child: const DoctorsScreen(),
                ),
                const ProfileScreen(),
              ],
            ),
            bottomNavigationBar: _buildBottomNav(currentIndex),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(
          top: BorderSide(
            color: AppTheme.divider.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => _navCubit.updateIndex(i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_rounded),
            label: 'AI Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_rounded),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting().animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 20),
            _buildQuickActions().animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Top Rated Doctors',
              actionText: 'See All',
              onAction: () => _navCubit.updateIndex(2),
            ),
            const SizedBox(height: 8),
            _buildDoctorsList().animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Nearby Hospitals',
              actionText: 'See All',
              onAction: () => Navigator.pushNamed(context, AppRoutes.hospitals),
            ),
            const SizedBox(height: 8),
            _buildHospitalsList().animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Ahmed 👋',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'How are you feeling today?',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryLight],
              ),
            ),
            child: Center(
              child: Text(
                'A',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        'AI Symptom\nChecker',
        Icons.smart_toy_rounded,
        [AppTheme.primary, AppTheme.primaryLight],
        () => _navCubit.updateIndex(1),
      ),
      _QuickAction(
        'Find\nDoctor',
        Icons.medical_services_rounded,
        [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
        () => _navCubit.updateIndex(2),
      ),
      _QuickAction(
        'Emergency\nHelp',
        Icons.emergency_rounded,
        [AppTheme.critical, const Color(0xFFF87171)],
        () => Navigator.pushNamed(context, AppRoutes.hospitals),
      ),
      _QuickAction(
        'Book\nAppointment',
        Icons.calendar_month_rounded,
        [AppTheme.moderate, const Color(0xFFFBBF24)],
        () => Navigator.pushNamed(context, AppRoutes.booking),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: actions.length,
        itemBuilder: (ctx, i) {
          final a = actions[i];
          return GestureDetector(
            onTap: a.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    a.colors[0].withValues(alpha: 0.15),
                    a.colors[1].withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(color: a.colors[0].withValues(alpha: 0.2)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: a.colors),
                    ),
                    child: Icon(a.icon, color: Colors.white, size: 22),
                  ),
                  Text(
                    a.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().scale(
            delay: (100 * i).ms,
            duration: 300.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            curve: Curves.easeOutBack,
          );
        },
      ),
    );
  }

  Widget _buildDoctorsList() {
    return BlocBuilder<DoctorCubit, DoctorState>(
      builder: (ctx, state) {
        if (state is DoctorLoaded) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.doctors.length > 4 ? 4 : state.doctors.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 180,
                  child: DoctorCard(doctor: state.doctors[i], compact: true),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(color: AppTheme.primary),
          ),
        );
      },
    );
  }

  Widget _buildHospitalsList() {
    return BlocBuilder<HospitalCubit, HospitalState>(
      builder: (ctx, state) {
        if (state is HospitalLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.hospitals.length > 3 ? 3 : state.hospitals.length,
            itemBuilder: (ctx, i) {
              final h = state.hospitals[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.divider.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: h.emergencyAvailable
                            ? AppTheme.criticalBg
                            : AppTheme.infoBg,
                      ),
                      child: Icon(
                        Icons.local_hospital_rounded,
                        color: h.emergencyAvailable
                            ? AppTheme.critical
                            : AppTheme.info,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            h.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            h.distance,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (h.is24Hours)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.mildBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '24/7',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.mild,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
  _QuickAction(this.label, this.icon, this.colors, this.onTap);
}
