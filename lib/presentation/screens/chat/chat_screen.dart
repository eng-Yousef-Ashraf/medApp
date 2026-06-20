import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_flutter_app/core/di/injection_container.dart';
import 'package:my_flutter_app/core/routes/app_routes.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/core/widgets/urgency_badge.dart';
import 'package:my_flutter_app/data/datasources/local_data_source.dart';
import 'package:my_flutter_app/domain/entities/doctor.dart';
import 'package:my_flutter_app/domain/entities/message.dart';
import 'package:my_flutter_app/presentation/cubits/chat/chat_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/chat/chat_state.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late final ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = sl<ChatCubit>()..loadMessages();
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _chatCubit.close();
    super.dispose();
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();
    _chatCubit.sendMessage(text);
    Future.delayed(100.ms, _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent + 200,
        duration: 300.ms,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryLight],
                  ),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'MedLink AI',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppTheme.textMuted,
              ),
              onPressed: () => _chatCubit.clearChat(),
            ),
          ],
        ),
        body: Column(
          children: [
            // Welcome banner
            _buildWelcome(),
            // Messages
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (ctx, state) {
                  if (state is ChatLoaded && !state.isAiTyping) {
                    Future.delayed(100.ms, _scrollToBottom);
                  }
                },
                builder: (ctx, state) {
                  if (state is ChatLoaded) {
                    if (state.messages.isEmpty) return const SizedBox();
                    return ListView.builder(
                      controller: _scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      itemCount:
                          state.messages.length + (state.isAiTyping ? 1 : 0),
                      itemBuilder: (ctx, i) {
                        if (i == state.messages.length && state.isAiTyping)
                          return _buildTypingIndicator();
                        return _buildMessageBubble(state.messages[i]);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            // Input
            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (ctx, state) {
        if (state is ChatLoaded && state.messages.isEmpty) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withValues(alpha: 0.15),
                  AppTheme.primaryLight.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.smart_toy_rounded,
                  size: 40,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'AI Health Assistant',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Describe your symptoms and I\'ll assess the urgency and provide first-aid guidance.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _chipSuggestion('I have a headache'),
                    _chipSuggestion('Chest pain'),
                    _chipSuggestion('Fever'),
                    _chipSuggestion('Sore throat'),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms);
        }
        return const SizedBox();
      },
    );
  }

  Widget _chipSuggestion(String text) {
    return GestureDetector(
      onTap: () {
        _msgCtrl.text = text;
        _send();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppTheme.bgCard,
          border: Border.all(color: AppTheme.divider),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message msg) {
    final isUser = msg.isUser;
    return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryLight],
                    ),
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? AppTheme.primary : AppTheme.bgCard,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isUser ? 18 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 18),
                        ),
                        border: isUser
                            ? null
                            : Border.all(
                                color: _getBorderColor(msg.urgencyLevel),
                                width: msg.urgencyLevel != UrgencyLevel.none
                                    ? 1
                                    : 0,
                              ),
                      ),
                      child: Text(
                        msg.text,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isUser ? Colors.white : AppTheme.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    if (!isUser && msg.urgencyLevel != UrgencyLevel.none) ...[
                      const SizedBox(height: 8),
                      UrgencyBadge(level: msg.urgencyLevel),
                    ],
                    if (!isUser && msg.firstAidAdvice != null) ...[
                      const SizedBox(height: 8),
                      _buildFirstAidCard(msg.firstAidAdvice!),
                    ],
                    if (!isUser && msg.recommendedSpecialty != null) ...[
                      const SizedBox(height: 8),
                      _buildDoctorRecommendationCard(
                        context,
                        msg.recommendedSpecialty!,
                      ),
                    ],
                  ],
                ),
              ),
              if (isUser) const SizedBox(width: 8),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: isUser ? 0.1 : -0.1, end: 0);
  }

  Color _getBorderColor(UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.critical:
        return AppTheme.critical.withValues(alpha: 0.4);
      case UrgencyLevel.moderate:
        return AppTheme.moderate.withValues(alpha: 0.4);
      case UrgencyLevel.mild:
        return AppTheme.mild.withValues(alpha: 0.4);
      case UrgencyLevel.info:
        return AppTheme.info.withValues(alpha: 0.4);
      case UrgencyLevel.none:
        return Colors.transparent;
    }
  }

  Widget _buildFirstAidCard(String advice) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.medical_information_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'First Aid Instructions',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            advice,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorRecommendationCard(
    BuildContext context,
    String specialty,
  ) {
    final localDs = sl<LocalDataSource>();
    final doctors = localDs.getDoctorsBySpecialty(specialty, limit: 2);
    if (doctors.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_search_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Recommended: $specialty Specialist',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...doctors.map(
            (doctor) => _buildDoctorTile(context, doctor),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorTile(BuildContext context, Doctor doctor) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.doctorDetail,
        arguments: doctor,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.divider.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 22,
              backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
              child: Text(
                doctor.name.split(' ').map((w) => w[0]).take(2).join(),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: AppTheme.moderate,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${doctor.rating}  •  ${doctor.experienceYears}y exp',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Book button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryLight],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Book',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryLight],
              ),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) =>
                    Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.textMuted,
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat())
                        .fadeIn(delay: (i * 200).ms, duration: 400.ms)
                        .then()
                        .fadeOut(duration: 400.ms),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(
          top: BorderSide(color: AppTheme.divider.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgCtrl,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Describe your symptoms...',
                hintStyle: GoogleFonts.inter(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.bgDark,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryLight],
              ),
            ),
            child: IconButton(
              onPressed: _send,
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
