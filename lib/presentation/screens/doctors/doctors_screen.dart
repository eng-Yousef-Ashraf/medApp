import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_flutter_app/core/routes/app_routes.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/presentation/cubits/doctor/doctor_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/doctor/doctor_state.dart';
import 'package:my_flutter_app/presentation/widgets/doctor_card.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});
  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final _searchCtrl = TextEditingController();
  final List<String> _specialties = ['All', 'Cardiology', 'Neurology', 'Pediatrics', 'Orthopedics', 'Dermatology', 'General Practice', 'Psychiatry', 'Emergency Medicine'];
  String _selected = 'All';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text('Find Doctors', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        ),
        const SizedBox(height: 16),
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchCtrl,
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search doctors...', prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
              filled: true, fillColor: AppTheme.bgCard,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onChanged: (q) => context.read<DoctorCubit>().searchDoctors(q),
          ),
        ),
        const SizedBox(height: 16),
        // Filter chips
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _specialties.length,
            itemBuilder: (ctx, i) {
              final s = _specialties[i];
              final active = s == _selected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selected = s);
                    context.read<DoctorCubit>().filterBySpecialty(s);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppTheme.primary : AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? AppTheme.primary : AppTheme.divider),
                    ),
                    child: Text(s, style: GoogleFonts.inter(fontSize: 13, fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? Colors.white : AppTheme.textSecondary)),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Doctor list
        Expanded(
          child: BlocBuilder<DoctorCubit, DoctorState>(
            builder: (ctx, state) {
              if (state is DoctorLoading) return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
              if (state is DoctorLoaded) {
                if (state.doctors.isEmpty) return Center(child: Text('No doctors found', style: GoogleFonts.inter(color: AppTheme.textMuted)));
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.doctors.length,
                  itemBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.doctorDetail, arguments: state.doctors[i]),
                      child: DoctorCard(doctor: state.doctors[i]),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ]),
    );
  }
}
