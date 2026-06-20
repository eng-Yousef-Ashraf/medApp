import 'package:my_flutter_app/core/config/api_config.dart';
import 'package:my_flutter_app/data/datasources/groq_data_source.dart';
import 'package:my_flutter_app/domain/entities/doctor.dart';
import 'package:my_flutter_app/domain/entities/hospital.dart';
import 'package:my_flutter_app/domain/entities/message.dart';
import 'package:my_flutter_app/domain/entities/user.dart';

class LocalDataSource {
  AppUser? _currentUser;
  final List<Message> _chatHistory = [];

  /// Groq data source – only active when an API key has been configured.
  final GroqDataSource? _groqDataSource = ApiConfig.isGroqConfigured
      ? GroqDataSource()
      : null;

  // ── Fake User ──
  final AppUser fakeUser = const AppUser(
    id: 'u1',
    name: 'Ahmed',
    email: 'ahmed@medlink.com',
    photoUrl: null,
    phone: '+1 555-0123',
  );

  // ── Fake Doctors ──
  List<Doctor> getDoctors() => _doctors;

  /// Returns up to [limit] doctors whose specialty matches [specialty].
  List<Doctor> getDoctorsBySpecialty(String specialty, {int limit = 2}) =>
      _doctors
          .where((d) => d.specialty == specialty)
          .take(limit)
          .toList();
  
  static final List<Doctor> _doctors = [
    // ── Cardiology ──
    Doctor(
      id: 'd1',
      name: 'Dr. Ahmed Mostafa El-Sayed',
      specialty: 'Cardiology',
      rating: 4.9,
      reviewCount: 214,
      bio: 'د. أحمد مصطفى السيد أستاذ مساعد في أمراض القلب والأوعية الدموية بكلية الطب جامعة القاهرة. متخصص في قسطرة القلب وعلاج اضطرابات النظم، وأجرى أكثر من 3000 إجراء قلبي.',
      address: 'مستشفى القلب التخصصي، المعادي، القاهرة',
      phone: '+20 100 123 4567',
      imageUrl: '',
      availableSlots: ['09:00 ص', '10:00 ص', '11:30 ص', '02:00 م', '03:30 م'],
      education: 'دكتوراه طب القلب – جامعة القاهرة',
      experienceYears: 18,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r1', patientName: 'محمد علي', rating: 5.0, comment: 'طبيب ممتاز ومتعاون جداً، شرح الحالة بدقة وأعطاني خطة علاجية واضحة.', date: DateTime(2026, 4, 10)),
        DoctorReview(id: 'r2', patientName: 'سمر حسن', rating: 4.8, comment: 'من أفضل أطباء القلب في مصر. الانتظار قصير والمعالجة احترافية.', date: DateTime(2026, 3, 18)),
      ],
    ),
    Doctor(
      id: 'd2',
      name: 'Dr. Heba Nasser Fouad',
      specialty: 'Cardiology',
      rating: 4.8,
      reviewCount: 163,
      bio: 'د. هبة ناصر فؤاد استشارية في أمراض القلب والأوعية الدموية بمستشفى عين شمس التخصصي. خبرة واسعة في أمراض القلب الوقائية وفشل القلب وارتفاع ضغط الدم.',
      address: 'مستشفى عين شمس التخصصي، عين شمس، القاهرة',
      phone: '+20 111 234 5678',
      imageUrl: '',
      availableSlots: ['08:30 ص', '10:00 ص', '01:00 م', '04:00 م'],
      education: 'ماجستير أمراض القلب – جامعة عين شمس',
      experienceYears: 14,
      languages: ['العربية', 'الإنجليزية', 'الفرنسية'],
      reviews: [
        DoctorReview(id: 'r3', patientName: 'أحمد فاروق', rating: 4.9, comment: 'طبيبة متميزة واهتمامها بالمريض واضح من أول لقاء.', date: DateTime(2026, 4, 2)),
        DoctorReview(id: 'r4', patientName: 'نهى إبراهيم', rating: 4.7, comment: 'تشخيص دقيق وخطة علاجية منطقية. أنصح بها بشدة.', date: DateTime(2026, 3, 5)),
      ],
    ),

    // ── Neurology ──
    Doctor(
      id: 'd3',
      name: 'Dr. Khaled Abdel-Fattah Rabie',
      specialty: 'Neurology',
      rating: 4.9,
      reviewCount: 187,
      bio: 'د. خالد عبد الفتاح ربيع أستاذ الأمراض العصبية بجامعة الإسكندرية. متخصص في الصداع النصفي والصرع والأمراض التنكسية العصبية، ونشر أكثر من 40 بحثاً علمياً دولياً.',
      address: 'مستشفى الإسكندرية الدولي، سيدي جابر، الإسكندرية',
      phone: '+20 122 345 6789',
      imageUrl: '',
      availableSlots: ['09:00 ص', '10:30 ص', '12:00 م', '03:00 م'],
      education: 'دكتوراه الأمراض العصبية – جامعة الإسكندرية',
      experienceYears: 22,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r5', patientName: 'ياسمين صالح', rating: 5.0, comment: 'طبيب استثنائي. شخّص حالتي التي أربك فيها الكثيرون من قبله.', date: DateTime(2026, 4, 14)),
        DoctorReview(id: 'r6', patientName: 'كريم عزت', rating: 4.8, comment: 'صبور جداً ويشرح بأسلوب بسيط وواضح.', date: DateTime(2026, 3, 22)),
      ],
    ),
    Doctor(
      id: 'd4',
      name: 'Dr. Rania Mahmoud Soliman',
      specialty: 'Neurology',
      rating: 4.7,
      reviewCount: 129,
      bio: 'د. رانيا محمود سليمان استشارية الأعصاب بمستشفى دار الفؤاد. متخصصة في التصلب المتعدد واضطرابات النوم وإعادة التأهيل العصبي.',
      address: 'مستشفى دار الفؤاد، السادس من أكتوبر، الجيزة',
      phone: '+20 100 456 7890',
      imageUrl: '',
      availableSlots: ['10:00 ص', '11:30 ص', '01:30 م', '04:30 م'],
      education: 'ماجستير الأمراض العصبية – جامعة القاهرة',
      experienceYears: 12,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r7', patientName: 'لمياء طارق', rating: 4.7, comment: 'متخصصة ودودة وتولي اهتماماً كبيراً لراحة المريض النفسية.', date: DateTime(2026, 4, 8)),
      ],
    ),

    // ── Pediatrics ──
    Doctor(
      id: 'd5',
      name: 'Dr. Mona Samir Abdallah',
      specialty: 'Pediatrics',
      rating: 4.9,
      reviewCount: 342,
      bio: 'د. منى سمير عبدالله رائدة في طب الأطفال بمستشفى أبو الريش للأطفال التابع لجامعة القاهرة. تتخصص في أمراض الجهاز الهضمي للأطفال وصحة حديثي الولادة.',
      address: 'مستشفى أبو الريش للأطفال، المنيل، القاهرة',
      phone: '+20 111 567 8901',
      imageUrl: '',
      availableSlots: ['09:00 ص', '09:30 ص', '10:30 ص', '11:00 ص', '02:00 م', '03:00 م'],
      education: 'دكتوراه طب الأطفال – جامعة القاهرة',
      experienceYears: 16,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r8', patientName: 'ولاء حسين', rating: 5.0, comment: 'أطفالي يحبونها! تجعل كل زيارة ممتعة وبلا قلق.', date: DateTime(2026, 4, 19)),
        DoctorReview(id: 'r9', patientName: 'هاني مجدي', rating: 4.9, comment: 'لطيفة جداً مع الأطفال ومعلوماتها ممتازة.', date: DateTime(2026, 3, 11)),
      ],
    ),
    Doctor(
      id: 'd6',
      name: 'Dr. Tarek Naguib Hassan',
      specialty: 'Pediatrics',
      rating: 4.8,
      reviewCount: 211,
      bio: 'د. طارق نجيب حسن استشاري طب الأطفال بمستشفى الدمرداش الجامعي. خبرة واسعة في أمراض الجهاز التنفسي عند الأطفال وأمراض الحساسية والمناعة.',
      address: 'مستشفى الدمرداش الجامعي، عين شمس، القاهرة',
      phone: '+20 122 678 9012',
      imageUrl: '',
      availableSlots: ['08:00 ص', '09:30 ص', '11:00 ص', '01:00 م', '03:30 م'],
      education: 'ماجستير طب الأطفال – جامعة عين شمس',
      experienceYears: 13,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r10', patientName: 'داليا عمر', rating: 4.8, comment: 'طبيب صبور ومدروس في تشخيصه، أنصح به للأطفال الخائفين من الأطباء.', date: DateTime(2026, 4, 6)),
      ],
    ),

    // ── Orthopedics ──
    Doctor(
      id: 'd7',
      name: 'Dr. Amr Gamal El-Din',
      specialty: 'Orthopedics',
      rating: 4.8,
      reviewCount: 156,
      bio: 'د. عمرو جمال الدين جراح العظام والمفاصل بمستشفى كليوباترا. متخصص في جراحة الركبة والورك وإصابات الملاعب، ويستخدم أحدث تقنيات التنظير المفصلي.',
      address: 'مستشفى كليوباترا، هليوبوليس، القاهرة',
      phone: '+20 100 789 0123',
      imageUrl: '',
      availableSlots: ['08:00 ص', '10:00 ص', '01:00 م', '04:00 م'],
      education: 'دكتوراه جراحة العظام – جامعة القاهرة',
      experienceYears: 15,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r11', patientName: 'إسلام رأفت', rating: 4.9, comment: 'أصلح رباط الـ ACL الخاص بي ببراعة. التعافي كان سريعاً بفضل إرشاداته.', date: DateTime(2026, 4, 7)),
        DoctorReview(id: 'r12', patientName: 'منار صبري', rating: 4.7, comment: 'متمكن جداً في مجاله وتفسيره للأشعة دقيق.', date: DateTime(2026, 2, 28)),
      ],
    ),
    Doctor(
      id: 'd8',
      name: 'Dr. Dina Fawzy Khalil',
      specialty: 'Orthopedics',
      rating: 4.7,
      reviewCount: 98,
      bio: 'د. دينا فوزي خليل استشارية جراحة العمود الفقري بمستشفى الشيخ زايد التخصصي. متخصصة في آلام أسفل الظهر وانزلاق الغضاريف والجراحة بالمنظار.',
      address: 'مستشفى الشيخ زايد التخصصي، الشيخ زايد، الجيزة',
      phone: '+20 111 890 1234',
      imageUrl: '',
      availableSlots: ['09:30 ص', '11:00 ص', '02:00 م', '04:30 م'],
      education: 'ماجستير جراحة العظام – جامعة عين شمس',
      experienceYears: 11,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r13', patientName: 'علاء بدر', rating: 4.7, comment: 'حلت مشكلة الانزلاق الغضروفي التي عانيت منها سنوات. شكراً دكتورة دينا.', date: DateTime(2026, 3, 20)),
      ],
    ),

    // ── Dermatology ──
    Doctor(
      id: 'd9',
      name: 'Dr. Nadia Hassan El-Gohary',
      specialty: 'Dermatology',
      rating: 4.9,
      reviewCount: 278,
      bio: 'د. ناديا حسن الجوهري أستاذة مشاركة في الجلدية والتناسلية بجامعة الزقازيق. متخصصة في الأمراض الجلدية المناعية والليزر والتجميل الطبي.',
      address: 'عيادة كايرو ديرما، مدينة نصر، القاهرة',
      phone: '+20 122 901 2345',
      imageUrl: '',
      availableSlots: ['10:00 ص', '11:30 ص', '01:00 م', '03:30 م', '05:00 م'],
      education: 'دكتوراه الأمراض الجلدية – جامعة الزقازيق',
      experienceYears: 19,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r14', patientName: 'شيماء النجار', rating: 5.0, comment: 'علجت مشكلة البهاق التي عانيت منها سنوات. نتائج مذهلة!', date: DateTime(2026, 4, 15)),
        DoctorReview(id: 'r15', patientName: 'تامر شوقي', rating: 4.8, comment: 'طبيبة محترفة وعلاجاتها الليزرية ممتازة.', date: DateTime(2026, 3, 1)),
      ],
    ),
    Doctor(
      id: 'd10',
      name: 'Dr. Sherif Anwar Mostafa',
      specialty: 'Dermatology',
      rating: 4.7,
      reviewCount: 144,
      bio: 'د. شريف أنور مصطفى استشاري الجلدية والتناسلية بمستشفى النيل بدر. خبرة في علاج حب الشباب والصدفية والأمراض الجلدية المعقدة.',
      address: 'مستشفى النيل بدر، بدر، القاهرة',
      phone: '+20 100 012 3456',
      imageUrl: '',
      availableSlots: ['09:00 ص', '10:30 ص', '12:00 م', '04:00 م'],
      education: 'ماجستير الأمراض الجلدية – جامعة المنصورة',
      experienceYears: 10,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r16', patientName: 'أميرة جلال', rating: 4.7, comment: 'تشخيص صحيح من أول مرة وعلاج فعّال جداً لحب الشباب المزمن.', date: DateTime(2026, 4, 3)),
      ],
    ),

    // ── General Practice ──
    Doctor(
      id: 'd11',
      name: 'Dr. Omar Abdel-Rahman Zaki',
      specialty: 'General Practice',
      rating: 4.7,
      reviewCount: 445,
      bio: 'د. عمر عبد الرحمن زكي طبيب عائلة موثوق بخبرة 22 عاماً في الطب العام والوقائي. يؤمن بالنهج الشامل للرعاية الصحية ويتابع مرضاه بشكل منتظم.',
      address: 'مركز القاهرة الطبي، الدقي، الجيزة',
      phone: '+20 111 123 4560',
      imageUrl: '',
      availableSlots: ['08:00 ص', '08:30 ص', '09:00 ص', '09:30 ص', '10:00 ص', '01:00 م', '02:00 م'],
      education: 'بكالوريوس الطب والجراحة – جامعة القاهرة',
      experienceYears: 22,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r17', patientName: 'رشا سيد', rating: 4.6, comment: 'طبيب العائلة منذ سنوات. دائماً موثوق وملتزم.', date: DateTime(2026, 4, 4)),
        DoctorReview(id: 'r18', patientName: 'وليد حمدي', rating: 4.8, comment: 'يتعامل مع المريض باحترام ويشرح كل شيء بوضوح.', date: DateTime(2026, 3, 12)),
      ],
    ),
    Doctor(
      id: 'd12',
      name: 'Dr. Eman Ibrahim Saleh',
      specialty: 'General Practice',
      rating: 4.6,
      reviewCount: 318,
      bio: 'د. إيمان إبراهيم صالح طبيبة عائلة في مستشفى الهلال الطبي. متخصصة في إدارة الأمراض المزمنة كالسكري وارتفاع ضغط الدم والوقاية الصحية.',
      address: 'مستشفى الهلال الطبي، شبرا، القاهرة',
      phone: '+20 122 234 5671',
      imageUrl: '',
      availableSlots: ['08:30 ص', '09:30 ص', '10:30 ص', '12:30 م', '02:30 م'],
      education: 'بكالوريوس الطب والجراحة – جامعة عين شمس',
      experienceYears: 15,
      languages: ['العربية'],
      reviews: [
        DoctorReview(id: 'r19', patientName: 'ماجدة فهمي', rating: 4.5, comment: 'طبيبة متفانية وتُعطي وقتاً كافياً لكل مريض.', date: DateTime(2026, 3, 28)),
      ],
    ),

    // ── Psychiatry ──
    Doctor(
      id: 'd13',
      name: 'Dr. Yasmin Nour El-Din Fekry',
      specialty: 'Psychiatry',
      rating: 4.9,
      reviewCount: 132,
      bio: 'د. ياسمين نور الدين فكري طبيبة نفسية واستشارية في اضطرابات القلق والاكتئاب واضطراب ما بعد الصدمة. تجمع بين العلاج الدوائي والعلاج المعرفي السلوكي.',
      address: 'مركز النفس والمجتمع، المهندسين، الجيزة',
      phone: '+20 100 345 6782',
      imageUrl: '',
      availableSlots: ['10:00 ص', '11:00 ص', '01:00 م', '03:00 م', '05:00 م'],
      education: 'دكتوراه الطب النفسي – جامعة القاهرة',
      experienceYears: 13,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r20', patientName: 'مجهول الهوية', rating: 5.0, comment: 'غيّرت حياتي بالفعل. أسلوبها في العلاج رحيم وفعّال للغاية.', date: DateTime(2026, 4, 17)),
        DoctorReview(id: 'r21', patientName: 'سارة فتحي', rating: 4.9, comment: 'تعاملت مع أزمة القلق لديّ بمهنية عالية وأحسست بالأمان منذ الجلسة الأولى.', date: DateTime(2026, 3, 7)),
      ],
    ),
    Doctor(
      id: 'd14',
      name: 'Dr. Hossam Adel Bayoumi',
      specialty: 'Psychiatry',
      rating: 4.8,
      reviewCount: 97,
      bio: 'د. حسام عادل بيومي استشاري الطب النفسي بمستشفى العباسية للصحة النفسية. متخصص في الفصام واضطرابات المزاج وإدمان المخدرات وعلاج الأزواج.',
      address: 'مستشفى العباسية للصحة النفسية، العباسية، القاهرة',
      phone: '+20 111 456 7893',
      imageUrl: '',
      availableSlots: ['09:00 ص', '11:00 ص', '02:00 م', '04:00 م'],
      education: 'ماجستير الطب النفسي – جامعة عين شمس',
      experienceYears: 17,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r22', patientName: 'مجهول الهوية', rating: 4.8, comment: 'طبيب يفهم ما تشعر به دون أن تحتاج لشرح كثير. موهوب حقاً.', date: DateTime(2026, 3, 25)),
      ],
    ),

    // ── Emergency Medicine ──
    Doctor(
      id: 'd15',
      name: 'Dr. Mahmoud Fathy Gaber',
      specialty: 'Emergency Medicine',
      rating: 4.8,
      reviewCount: 89,
      bio: 'د. محمود فتحي جابر رئيس قسم الطوارئ بمستشفى المجمع الطبي بالمعادي. خبرة واسعة في الإسعافات الأولية وإنعاش القلب والرئة وإدارة الحوادث الجماعية.',
      address: 'مستشفى المجمع الطبي، المعادي، القاهرة',
      phone: '+20 122 567 8904',
      imageUrl: '',
      availableSlots: ['متاح على مدار 24 ساعة في الطوارئ'],
      education: 'ماجستير طب الطوارئ – جامعة القاهرة',
      experienceYears: 16,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r23', patientName: 'نادية عصام', rating: 5.0, comment: 'أنقذ ابني في لحظة حرجة. سرعة تصرفه كانت استثنائية.', date: DateTime(2026, 4, 11)),
        DoctorReview(id: 'r24', patientName: 'عمرو لبيب', rating: 4.6, comment: 'طبيب ذو خبرة في المواقف الصعبة ويعمل بهدوء وكفاءة عالية.', date: DateTime(2026, 3, 3)),
      ],
    ),
    Doctor(
      id: 'd16',
      name: 'Dr. Amira Saad El-Wakil',
      specialty: 'Emergency Medicine',
      rating: 4.7,
      reviewCount: 71,
      bio: 'د. أميرة سعد الوكيل استشارية طب الطوارئ بمستشفى الشرطة العام. متخصصة في إدارة الصدمات والإسعافات الأولية المتقدمة والتعامل مع حالات التسمم.',
      address: 'مستشفى الشرطة العام، العجوزة، الجيزة',
      phone: '+20 100 678 9015',
      imageUrl: '',
      availableSlots: ['متاح على مدار 24 ساعة في الطوارئ'],
      education: 'بكالوريوس الطب والجراحة + دبلوم طب الطوارئ – جامعة عين شمس',
      experienceYears: 9,
      languages: ['العربية', 'الإنجليزية'],
      reviews: [
        DoctorReview(id: 'r25', patientName: 'جمال حمدي', rating: 4.7, comment: 'طبيبة متمكنة وهادئة في أصعب اللحظات. أُوصي بها.', date: DateTime(2026, 2, 20)),
      ],
    ),
  ];

  // ── Fake Hospitals ──
  List<Hospital> getHospitals() => _hospitals;

  static final List<Hospital> _hospitals = [
    const Hospital(
      id: 'h1',
      name: 'مستشفى القصر العيني الجامعي',
      address: 'شارع القصر العيني، المنيل، القاهرة',
      phone: '+20 2 2364 8000',
      latitude: 30.0271,
      longitude: 31.2272,
      emergencyAvailable: true,
      distance: '1.2 km',
      rating: 4.4,
      is24Hours: true,
    ),
    const Hospital(
      id: 'h2',
      name: 'مستشفى دار الفؤاد',
      address: 'طريق أبو قير، السادس من أكتوبر، الجيزة',
      phone: '+20 2 3827 0000',
      latitude: 30.0131,
      longitude: 31.0001,
      emergencyAvailable: true,
      distance: '2.8 km',
      rating: 4.8,
      is24Hours: true,
    ),
    const Hospital(
      id: 'h3',
      name: 'مستشفى كليوباترا',
      address: 'شارع عباس العقاد، مدينة نصر، القاهرة',
      phone: '+20 2 2290 0100',
      latitude: 30.0639,
      longitude: 31.3365,
      emergencyAvailable: true,
      distance: '0.9 km',
      rating: 4.6,
      is24Hours: true,
    ),
    const Hospital(
      id: 'h4',
      name: 'مستشفى المعادي العسكري',
      address: 'شارع النصر، المعادي، القاهرة',
      phone: '+20 2 2516 1000',
      latitude: 29.9612,
      longitude: 31.2589,
      emergencyAvailable: true,
      distance: '3.5 km',
      rating: 4.5,
      is24Hours: true,
    ),
    const Hospital(
      id: 'h5',
      name: 'مستشفى الشيخ زايد التخصصي',
      address: 'حي الشيخ زايد، الجيزة',
      phone: '+20 2 3854 9000',
      latitude: 30.0278,
      longitude: 30.9453,
      emergencyAvailable: false,
      distance: '4.1 km',
      rating: 4.9,
      is24Hours: false,
    ),
    const Hospital(
      id: 'h6',
      name: 'مستشفى عين شمس التخصصي',
      address: 'شارع الخليفة المأمون، عين شمس، القاهرة',
      phone: '+20 2 2482 5000',
      latitude: 30.1274,
      longitude: 31.3344,
      emergencyAvailable: true,
      distance: '5.2 km',
      rating: 4.5,
      is24Hours: true,
    ),
  ];

  // ── AI Symptom Response Data ──
  static final Map<String, Map<String, dynamic>> symptomResponses = {
    'chest pain': {
      'urgency': UrgencyLevel.critical,
      'response': '⚠️ Chest pain can be a sign of a serious cardiac event such as a heart attack. This requires immediate medical attention.',
      'firstAid': '🚨 EMERGENCY FIRST AID:\n\n1. Call emergency services (911) immediately\n2. Sit upright in a comfortable position\n3. If prescribed, take nitroglycerin as directed\n4. Chew one regular aspirin (325mg) if not allergic\n5. Loosen any tight clothing\n6. Stay calm and wait for emergency services\n7. If the person becomes unconscious, begin CPR',
    },
    'difficulty breathing': {
      'urgency': UrgencyLevel.critical,
      'response': '⚠️ Difficulty breathing or shortness of breath can indicate a serious respiratory or cardiac condition requiring urgent care.',
      'firstAid': '🚨 EMERGENCY FIRST AID:\n\n1. Call emergency services (911) immediately\n2. Sit the person upright — do NOT lay them flat\n3. Loosen any tight clothing around neck and chest\n4. If they have an inhaler, help them use it\n5. Open windows for fresh air if indoors\n6. Stay with the person and keep them calm\n7. Monitor breathing rate until help arrives',
    },
    'severe bleeding': {
      'urgency': UrgencyLevel.critical,
      'response': '⚠️ Severe or uncontrollable bleeding is a medical emergency. Immediate action is required to prevent shock.',
      'firstAid': '🚨 EMERGENCY FIRST AID:\n\n1. Call emergency services (911) immediately\n2. Apply firm, direct pressure with a clean cloth\n3. Do NOT remove the cloth — add more layers if needed\n4. Elevate the injured area above heart level if possible\n5. Apply a tourniquet only as last resort for limb bleeding\n6. Keep the person warm to prevent shock\n7. Monitor consciousness until help arrives',
    },
    'stroke': {
      'urgency': UrgencyLevel.critical,
      'response': '⚠️ Stroke symptoms require immediate emergency care. Remember FAST: Face drooping, Arm weakness, Speech difficulty, Time to call 911.',
      'firstAid': '🚨 EMERGENCY FIRST AID:\n\n1. Call 911 IMMEDIATELY — time is critical\n2. Note the exact time symptoms started\n3. Do NOT give the person anything to eat or drink\n4. Lay them on their side if unconscious\n5. Do NOT give aspirin (could worsen bleeding stroke)\n6. Keep them comfortable and still\n7. Be ready to perform CPR if needed',
    },
    'unconscious': {
      'urgency': UrgencyLevel.critical,
      'response': '⚠️ Loss of consciousness is a medical emergency. The person needs immediate professional medical evaluation.',
      'firstAid': '🚨 EMERGENCY FIRST AID:\n\n1. Call 911 immediately\n2. Check for breathing — look, listen, feel\n3. If not breathing, begin CPR: 30 chest compressions, 2 rescue breaths\n4. If breathing, place in recovery position (on their side)\n5. Do NOT put anything in their mouth\n6. Check for medical ID bracelets\n7. Monitor until emergency services arrive',
    },
    'fever': {
      'urgency': UrgencyLevel.moderate,
      'response': '🟠 A fever indicates your body is fighting an infection. While usually not immediately dangerous, persistent high fever (above 103°F/39.4°C) needs medical attention within 24 hours.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Take acetaminophen (Tylenol) or ibuprofen as directed\n2. Stay well hydrated — drink water, clear broths, electrolyte drinks\n3. Rest as much as possible\n4. Use a lukewarm (not cold) compress on forehead\n5. Wear light, comfortable clothing\n6. Monitor temperature every 4 hours\n\n⚠️ Seek immediate care if fever exceeds 103°F (39.4°C) or lasts more than 3 days',
    },
    'cough': {
      'urgency': UrgencyLevel.moderate,
      'response': '🟠 A persistent cough could indicate various conditions from a common cold to bronchitis. If it persists beyond 2 weeks or produces blood, see a doctor.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Stay hydrated with warm liquids (tea with honey, warm water)\n2. Use a humidifier to add moisture to the air\n3. Try over-the-counter cough suppressants for dry cough\n4. Honey (1 tablespoon) can soothe throat — NOT for children under 1\n5. Elevate your head while sleeping\n6. Avoid irritants like smoke and strong odors\n\n⚠️ See a doctor if cough lasts more than 2 weeks or produces blood',
    },
    'vomiting': {
      'urgency': UrgencyLevel.moderate,
      'response': '🟠 Vomiting can be caused by many conditions including food poisoning, viral infections, or digestive issues. Persistent vomiting risks dehydration.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Stop eating solid food for a few hours\n2. Sip small amounts of clear fluids frequently\n3. Try oral rehydration solutions (ORS) or sports drinks\n4. Gradually introduce bland foods (crackers, rice, toast)\n5. Avoid dairy, fatty, or spicy foods\n6. Rest in an opponent or side-lying position\n\n⚠️ Seek immediate care if vomiting blood, severe abdominal pain, or signs of dehydration',
    },
    'abdominal pain': {
      'urgency': UrgencyLevel.moderate,
      'response': '🟠 Abdominal pain can range from minor digestive issues to conditions requiring medical attention. The location and severity help determine the cause.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Rest in a comfortable position\n2. Apply a warm compress to the abdomen\n3. Avoid solid food temporarily if nauseous\n4. Sip clear fluids\n5. Avoid aspirin and ibuprofen (can worsen stomach pain)\n6. Try antacids for upper abdominal discomfort\n\n⚠️ Seek immediate care if pain is severe, sudden, or accompanied by fever, vomiting blood, or rigid abdomen',
    },
    'sprain': {
      'urgency': UrgencyLevel.moderate,
      'response': '🟠 Sprains involve stretched or torn ligaments. Most can be treated at home with RICE protocol, but severe sprains may need medical evaluation.',
      'firstAid': '💊 HOME CARE (RICE Protocol):\n\n1. REST — Stop activity and avoid putting weight on the injury\n2. ICE — Apply ice wrapped in cloth for 20 min every 2-3 hours\n3. COMPRESSION — Wrap with elastic bandage (not too tight)\n4. ELEVATION — Keep injured area above heart level\n5. Take ibuprofen for pain and inflammation\n6. Avoid heat, alcohol, and massage for first 48 hours\n\n⚠️ See a doctor if you cannot bear weight, have severe swelling, or suspect a fracture',
    },
    'headache': {
      'urgency': UrgencyLevel.mild,
      'response': '🟢 Headaches are very common and usually not serious. Tension headaches and migraines are the most frequent types.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Take over-the-counter pain relievers (acetaminophen or ibuprofen)\n2. Rest in a quiet, dark room\n3. Apply a cold or warm compress to forehead/neck\n4. Stay hydrated — dehydration commonly causes headaches\n5. Gently massage temples and neck muscles\n6. Try deep breathing or relaxation techniques\n\n⚠️ Seek care if headache is sudden and severe ("worst ever"), with fever and stiff neck, or after a head injury',
    },
    'cold': {
      'urgency': UrgencyLevel.mild,
      'response': '🟢 Common cold symptoms including runny nose, sneezing, and mild congestion usually resolve on their own within 7-10 days.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Rest and get plenty of sleep\n2. Drink lots of fluids (water, warm tea, soup)\n3. Use saline nasal spray for congestion\n4. Take OTC decongestants or antihistamines\n5. Gargle with warm salt water for sore throat\n6. Use a humidifier to ease congestion\n7. Honey and lemon in warm water can soothe symptoms\n\nMost colds resolve in 7-10 days without medical treatment',
    },
    'sore throat': {
      'urgency': UrgencyLevel.mild,
      'response': '🟢 Sore throats are usually caused by viral infections and improve on their own. However, strep throat requires antibiotic treatment.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Gargle with warm salt water (1/2 tsp salt in 8oz water)\n2. Drink warm liquids — tea with honey, broth\n3. Suck on throat lozenges or ice chips\n4. Use OTC pain relievers (acetaminophen or ibuprofen)\n5. Use a humidifier\n6. Rest your voice\n\n⚠️ See a doctor if sore throat lasts more than a week, has white patches, or comes with high fever',
    },
    'cut': {
      'urgency': UrgencyLevel.mild,
      'response': '🟢 Minor cuts and scrapes can usually be treated at home. Proper wound care prevents infection and promotes healing.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Wash hands before treating the wound\n2. Stop bleeding by applying gentle pressure with clean cloth\n3. Clean the wound under running water\n4. Apply antibiotic ointment (Neosporin)\n5. Cover with a sterile bandage\n6. Change the bandage daily\n7. Watch for signs of infection (redness, swelling, warmth, pus)\n\n⚠️ Seek care if the cut is deep, won\'t stop bleeding, or shows signs of infection',
    },
    'allergies': {
      'urgency': UrgencyLevel.mild,
      'response': '🟢 Allergy symptoms like sneezing, itchy eyes, and runny nose are usually manageable with over-the-counter medications.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Take antihistamines (cetirizine, loratadine, or diphenhydramine)\n2. Use nasal corticosteroid sprays for congestion\n3. Apply cool compresses to itchy eyes\n4. Avoid known allergens when possible\n5. Shower after being outdoors to remove pollen\n6. Keep windows closed during high pollen days\n\n⚠️ SEEK EMERGENCY CARE if experiencing anaphylaxis: difficulty breathing, swelling of face/throat, rapid heartbeat',
    },
    'burn': {
      'urgency': UrgencyLevel.moderate,
      'response': '🟠 Burns need proper assessment. Minor burns can be treated at home, but severe burns with blistering or charring require medical attention.',
      'firstAid': '💊 FIRST AID FOR BURNS:\n\n1. Cool the burn under cool (not ice cold) running water for 10-20 min\n2. Do NOT apply ice, butter, or toothpaste\n3. Remove jewelry or tight items near the burn area\n4. Cover loosely with sterile, non-stick bandage\n5. Take OTC pain relievers\n6. Apply aloe vera gel for minor burns\n\n⚠️ Seek immediate care if burn is larger than 3 inches, on face/hands/feet/joints, or shows blistering/charring',
    },
    'dizziness': {
      'urgency': UrgencyLevel.moderate,
      'response': '🟠 Dizziness can be caused by dehydration, low blood pressure, inner ear issues, or more serious conditions. Persistent dizziness should be evaluated.',
      'firstAid': '💊 HOME CARE ADVICE:\n\n1. Sit or lie down immediately to prevent falls\n2. Drink water — dehydration is a common cause\n3. Avoid sudden movements, especially standing up quickly\n4. Focus on a fixed point to reduce spinning sensation\n5. Eat something if you haven\'t recently (low blood sugar)\n6. Avoid caffeine, alcohol, and tobacco\n\n⚠️ Seek immediate care if dizziness comes with chest pain, severe headache, slurred speech, or numbness',
    },
  };

  // ── Auth Methods ──
  AppUser? getCurrentUser() => _currentUser;
  
  Future<AppUser> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = fakeUser;
    return fakeUser;
  }

  Future<AppUser> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = AppUser(id: 'u1', name: name, email: email);
    return _currentUser!;
  }

  Future<AppUser> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = fakeUser;
    return fakeUser;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  // ── Chat Methods ──
  List<Message> getChatHistory() => List.unmodifiable(_chatHistory);
  
  void addMessage(Message message) => _chatHistory.add(message);
  
  void clearChatHistory() {
    _chatHistory.clear();
    _groqDataSource?.resetSession();
  }

  Future<Message> generateAiResponse(String userText) async {
    // ── Use Groq Cloud API if the key is configured ──
    if (_groqDataSource != null) {
      return _groqDataSource.generateResponse(userText);
    }

    // ── Fallback: keyword-based offline responses ──
    await Future.delayed(const Duration(milliseconds: 1500));
    final lowerText = userText.toLowerCase();
    for (final entry in symptomResponses.entries) {
      if (lowerText.contains(entry.key)) {
        return Message(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
          text: entry.value['response'] as String,
          isUser: false,
          timestamp: DateTime.now(),
          urgencyLevel: entry.value['urgency'] as UrgencyLevel,
          firstAidAdvice: entry.value['firstAid'] as String,
        );
      }
    }
    return Message(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      text: 'Thank you for describing your symptoms. Based on what you\'ve told me, I\'d recommend monitoring your condition. Could you provide more details about:\n\n• When did the symptoms start?\n• How severe is the discomfort (1-10)?\n• Any other symptoms you\'re experiencing?\n\nThis will help me give you better guidance.',
      isUser: false,
      timestamp: DateTime.now(),
      urgencyLevel: UrgencyLevel.info,
      firstAidAdvice: null,
    );
  }
}
