// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مِفتاح';

  @override
  String get welcomeEyebrow => 'إدارة الأملاك المؤجرة';

  @override
  String get welcomeTitle => 'عمارتك كلها في شاشة واحدة';

  @override
  String get welcomeSubtitle =>
      'المستأجر يدفع إيجاره ويطلب الصيانة من جواله، والمالك يتابع التحصيل والوحدات لحظة بلحظة.';

  @override
  String get roleTenant => 'أنا مستأجر';

  @override
  String get roleTenantDesc => 'ادفع إيجارك، تابع عقدك واطلب صيانة';

  @override
  String get roleOwner => 'أنا مالك أو مكتب عقار';

  @override
  String get roleOwnerDesc => 'الواجهة الحية، التحصيل، الصيانة والتقارير';

  @override
  String get demoNote => 'نسخة تجريبية ببيانات واقعية من الرياض';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navPayments => 'الدفعات';

  @override
  String get navMaintenance => 'الصيانة';

  @override
  String get navLease => 'العقد';

  @override
  String get navFacade => 'الواجهة';

  @override
  String get navProperties => 'العقارات';

  @override
  String get navCollections => 'التحصيل';

  @override
  String get navReports => 'التقارير';

  @override
  String get statusPaid => 'مدفوع';

  @override
  String get statusDueSoon => 'قرّب';

  @override
  String get statusLate => 'متأخر';

  @override
  String get statusVacant => 'شاغرة';

  @override
  String get statusUnpaid => 'مستحق';

  @override
  String get kindApartment => 'شقة';

  @override
  String get kindVilla => 'فيلا';

  @override
  String get kindShop => 'محل';

  @override
  String get kindOffice => 'مكتب';

  @override
  String get freqAnnual => 'دفعة سنوية';

  @override
  String get freqSemiAnnual => 'نصف سنوي';

  @override
  String get freqQuarterly => 'ربع سنوي';

  @override
  String get freqMonthly => 'شهري';

  @override
  String get methodMada => 'بطاقة مدى';

  @override
  String get methodBank => 'تحويل بنكي';

  @override
  String get methodCash => 'نقدًا';

  @override
  String get catAc => 'تكييف';

  @override
  String get catPlumbing => 'سباكة';

  @override
  String get catElectrical => 'كهرباء';

  @override
  String get catAppliances => 'أجهزة ومطبخ';

  @override
  String get catOther => 'صيانة عامة';

  @override
  String get tsOpen => 'تم الاستلام';

  @override
  String get tsAssigned => 'تم تعيين فني';

  @override
  String get tsInProgress => 'جاري العمل';

  @override
  String get tsDone => 'تم الإنجاز';

  @override
  String get slotMorning => 'الصباح';

  @override
  String get slotAfternoon => 'بعد الظهر';

  @override
  String get slotEvening => 'المساء';

  @override
  String goodMorning(String name) {
    return 'صباح الخير، $name';
  }

  @override
  String goodEvening(String name) {
    return 'مساء الخير، $name';
  }

  @override
  String get notifications => 'الإشعارات';

  @override
  String get tapCardHint => 'اضغط على الكارت عشان تشوف عقدك';

  @override
  String get payRent => 'ادفع الإيجار';

  @override
  String get payNowLate => 'ادفع الآن، الدفعة متأخرة';

  @override
  String get noOpenRequests => 'ما فيه طلبات مفتوحة';

  @override
  String get allGood => 'اضغط لطلب صيانة';

  @override
  String paidOfTotal(int paid, int total) {
    return '$paid من $total';
  }

  @override
  String get installmentsThisLease => 'دفعات مسددة';

  @override
  String get myHome => 'وحدتي';

  @override
  String bedrooms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count غرفة نوم',
      few: '$count غرف نوم',
      two: 'غرفتين نوم',
      one: 'غرفة نوم',
    );
    return '$_temp0';
  }

  @override
  String areaSqm(int n) {
    return '$n م²';
  }

  @override
  String floorN(int n) {
    return 'الدور $n';
  }

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get newRequest => 'طلب صيانة جديد';

  @override
  String get myLease => 'عقدي';

  @override
  String get contactOwner => 'تواصل مع المالك';

  @override
  String get contactOwnerBody => 'مكتب إدارة العقار يرد عليك خلال ساعات العمل.';

  @override
  String get officeName => 'المكتب';

  @override
  String get officeNameValue => 'الأفق لإدارة الأملاك';

  @override
  String get officeLicense => 'ترخيص فال 1200012345';

  @override
  String get phone => 'الهاتف';

  @override
  String get workingHours => 'ساعات العمل';

  @override
  String get workingHoursValue => 'الأحد إلى الخميس، 9 ص – 6 م';

  @override
  String get done => 'تم';

  @override
  String get allPaid => 'كل الدفعات مسددة';

  @override
  String get nextInstallment => 'الدفعة الجاية';

  @override
  String get lateShort => 'متأخرة';

  @override
  String get daysShort => 'يوم';

  @override
  String leaseEnds(String date) {
    return 'العقد ينتهي $date';
  }

  @override
  String wasDue(String date) {
    return 'كانت مستحقة $date';
  }

  @override
  String dueOn(String date) {
    return 'تستحق $date';
  }

  @override
  String get leaseDetails => 'تفاصيل العقد';

  @override
  String get unit => 'الوحدة';

  @override
  String get leasePeriod => 'مدة العقد';

  @override
  String get annualRent => 'الإيجار السنوي';

  @override
  String get paymentPlan => 'طريقة السداد';

  @override
  String get paySubtitle => 'ادفع بأمان، والإيصال يوصلك فورًا.';

  @override
  String payAmount(String amount) {
    return 'ادفع $amount';
  }

  @override
  String installmentN(int n) {
    return 'الدفعة رقم $n';
  }

  @override
  String get rent => 'الإيجار';

  @override
  String get vat => 'ضريبة القيمة المضافة';

  @override
  String get vatExempt => 'معفى (سكني)';

  @override
  String get vat15 => '15%';

  @override
  String get payWith => 'طريقة الدفع';

  @override
  String get applePayNote => 'أكّد الدفع ببصمة الوجه أو الإصبع على جهازك.';

  @override
  String stcPayNote(String phone) {
    return 'بيوصلك طلب الدفع على محفظة STC Pay المسجلة برقم $phone.';
  }

  @override
  String get bankName => 'البنك';

  @override
  String get bankNameValue => 'مصرف الراجحي';

  @override
  String get beneficiary => 'المستفيد';

  @override
  String get bankNote =>
      'اكتب رقم الوحدة في ملاحظة التحويل. في الديمو يتسجل التحويل مباشرة.';

  @override
  String get secureNote => 'نسخة تجريبية: ما فيه أي خصم حقيقي من حسابك.';

  @override
  String get paymentDone => 'تم الدفع بنجاح';

  @override
  String get paymentDoneBody => 'وصلت دفعتك للمالك وتحدّث سجل دفعاتك.';

  @override
  String get receipt => 'الإيصال';

  @override
  String get receiptBody => 'إيصال إلكتروني معتمد من مكتب العقار.';

  @override
  String get receiptNo => 'رقم الإيصال';

  @override
  String get paidOn => 'تاريخ الدفع';

  @override
  String get method => 'الطريقة';

  @override
  String get tenant => 'المستأجر';

  @override
  String get ejarContract => 'عقد إيجار';

  @override
  String get installmentLabel => 'الدفعة';

  @override
  String installmentOf(int n, int total) {
    return 'الدفعة $n من $total';
  }

  @override
  String get totalPaid => 'الإجمالي';

  @override
  String get backHome => 'رجوع للرئيسية';

  @override
  String get copyReceipt => 'نسخ الإيصال';

  @override
  String get copied => 'تم النسخ';

  @override
  String get paymentsSubtitle => 'كل دفعاتك وإيصالاتك في مكان واحد.';

  @override
  String get paidThisLease => 'المدفوع من العقد';

  @override
  String get remaining => 'المتبقي';

  @override
  String get upcoming => 'الجاية';

  @override
  String get paidHistory => 'المدفوعة';

  @override
  String get nothingDue => 'ما عليك أي دفعات حاليًا';

  @override
  String get maintenanceSubtitle => 'اطلب فني وتابع طلبك خطوة بخطوة.';

  @override
  String get newRequestHint => 'تكييف، سباكة، كهرباء والمزيد';

  @override
  String get activeRequests => 'طلبات مفتوحة';

  @override
  String get pastRequests => 'طلبات سابقة';

  @override
  String get noPastRequests => 'ما فيه طلبات سابقة';

  @override
  String get urgent => 'عاجل';

  @override
  String get stepWhat => 'وش المشكلة؟';

  @override
  String get stepDescribe => 'وصّف لنا المشكلة';

  @override
  String get stepWhen => 'متى يناسبك الفني؟';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get sendRequest => 'إرسال الطلب';

  @override
  String requestSent(int n) {
    return 'تم إرسال طلبك #$n';
  }

  @override
  String get describeHint => 'مثال: المكيف يطلع صوت ومو يبرد من أمس';

  @override
  String get urgentTitle => 'الطلب عاجل';

  @override
  String get urgentBody => 'تسريب مويه، انقطاع كهرباء أو خطر';

  @override
  String visitDay(String date) {
    return 'الزيارة يوم $date';
  }

  @override
  String get category => 'النوع';

  @override
  String get priority => 'الأولوية';

  @override
  String get normal => 'عادي';

  @override
  String get details => 'التفاصيل';

  @override
  String get presetAc1 => 'المكيف ما يبرد';

  @override
  String get presetAc2 => 'صوت عالي من المكيف';

  @override
  String get presetAc3 => 'تسريب مويه من المكيف';

  @override
  String get presetPl1 => 'تسريب تحت المغسلة';

  @override
  String get presetPl2 => 'السخان ما يسخن';

  @override
  String get presetPl3 => 'انسداد في التصريف';

  @override
  String get presetEl1 => 'الكهرباء تفصل';

  @override
  String get presetEl2 => 'أفياش ما تشتغل';

  @override
  String get presetEl3 => 'إضاءة معطلة';

  @override
  String get presetAp1 => 'الفرن ما يشتغل';

  @override
  String get presetAp2 => 'باب الكراج يعلق';

  @override
  String get presetOt1 => 'قفل الباب يعلق';

  @override
  String get presetOt2 => 'تشققات في الجدار';

  @override
  String get technician => 'الفني';

  @override
  String get change => 'تغيير';

  @override
  String get preferredTime => 'الوقت المفضل';

  @override
  String get cost => 'التكلفة';

  @override
  String get costSar => 'التكلفة (ر.س)';

  @override
  String get thanksRating => 'شكرًا لتقييمك';

  @override
  String get assignTechnician => 'تعيين فني';

  @override
  String get assigned => 'تم تعيين الفني وإشعار المستأجر';

  @override
  String get startWork => 'بدء العمل';

  @override
  String get markDone => 'إنهاء الطلب';

  @override
  String get confirm => 'تأكيد';

  @override
  String get ticketClosed => 'تم إنهاء الطلب';

  @override
  String get tenantRating => 'تقييم المستأجر';

  @override
  String get rateService => 'قيّم الخدمة';

  @override
  String get yourRating => 'تقييمك';

  @override
  String get leaseSubtitle => 'عقدك موثّق في منصة إيجار.';

  @override
  String get ejarRegistered => 'موثّق في إيجار';

  @override
  String daysLeftInLease(int n) {
    return 'باقي $n يوم';
  }

  @override
  String get nationalId => 'رقم الهوية';

  @override
  String get property => 'العقار';

  @override
  String get leaseType => 'نوع العقد';

  @override
  String get residential => 'سكني';

  @override
  String get commercial => 'تجاري';

  @override
  String get commercialVat => 'تجاري (+15% ضريبة)';

  @override
  String get securityDeposit => 'مبلغ التأمين';

  @override
  String get schedule => 'جدول الدفعات';

  @override
  String get renewTitle => 'تبي تجدد عقدك؟';

  @override
  String get renewBody => 'أرسل طلب التجديد للمالك قبل انتهاء العقد بوقت كافي.';

  @override
  String get requestRenewal => 'طلب تجديد';

  @override
  String get renewalSent => 'تم إرسال طلب التجديد';

  @override
  String get renewalSentBody => 'المالك بيراجع الطلب ويتواصل معك.';

  @override
  String get preferences => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get lightMode => 'الوضع النهاري';

  @override
  String get switchToOwner => 'جرّب واجهة المالك';

  @override
  String get switchToTenant => 'جرّب واجهة المستأجر';

  @override
  String get resetDemo => 'إعادة تعيين الديمو';

  @override
  String get demoReset => 'رجعت البيانات التجريبية لحالتها الأولى';

  @override
  String get backToWelcome => 'شاشة البداية';

  @override
  String get tenants => 'المستأجرين';

  @override
  String get settings => 'الإعدادات';

  @override
  String get collectedThisMonth => 'المحصّل هذا الشهر';

  @override
  String paymentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دفعة',
      few: '$count دفعات',
      two: 'دفعتين',
      one: 'دفعة واحدة',
      zero: 'ما فيه دفعات',
    );
    return '$_temp0';
  }

  @override
  String get overdue => 'متأخرات';

  @override
  String get openTickets => 'طلبات صيانة';

  @override
  String get occupancy => 'الإشغال';

  @override
  String occupancyBody(int a, int b) {
    return '$a وحدة مؤجرة من أصل $b';
  }

  @override
  String get liveFacade => 'الواجهة الحية';

  @override
  String get viewProperty => 'عرض العقار';

  @override
  String get needsAttention => 'يحتاج متابعة';

  @override
  String lateRent(String name) {
    return 'إيجار متأخر: $name';
  }

  @override
  String daysLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متأخر $count يوم',
      few: 'متأخر $count أيام',
      two: 'متأخر يومين',
      one: 'متأخر يوم',
    );
    return '$_temp0';
  }

  @override
  String newTicket(String category) {
    return 'طلب $category';
  }

  @override
  String leaseEnding(String name) {
    return 'عقد ينتهي: $name';
  }

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بعد $count يوم',
      few: 'بعد $count أيام',
      two: 'بعد يومين',
      one: 'بكرة',
      zero: 'اليوم',
    );
    return '$_temp0';
  }

  @override
  String get overdueSince => 'متأخر من';

  @override
  String get vacantSince => 'الوحدة شاغرة وجاهزة للتأجير.';

  @override
  String get openUnit => 'ملف الوحدة';

  @override
  String get leaseIt => 'أجّر الوحدة';

  @override
  String propertiesSubtitle(int p, int u) {
    return '$p عقارات · $u وحدة';
  }

  @override
  String get newLease => 'عقد جديد';

  @override
  String get units => 'الوحدات';

  @override
  String get yearIncome => 'دخل 12 شهر';

  @override
  String builtIn(String year) {
    return 'بناء $year';
  }

  @override
  String get all => 'الكل';

  @override
  String get rooms => 'الغرف';

  @override
  String get area => 'المساحة';

  @override
  String get unitVacantTitle => 'الوحدة شاغرة';

  @override
  String get unitVacantBody =>
      'أضف المستأجر والعقد في أقل من دقيقة، والشباك ينوّر في الواجهة مباشرة.';

  @override
  String get renewal => 'التجديد';

  @override
  String get renewalRequested => 'المستأجر طلب التجديد';

  @override
  String get maintenanceHistory => 'سجل الصيانة';

  @override
  String get collectionRate => 'نسبة التحصيل هذا الشهر';

  @override
  String collectedOf(String a, String b) {
    return '$a من $b';
  }

  @override
  String get collected => 'محصّل';

  @override
  String get dueThisMonth => 'مستحق هذا الشهر';

  @override
  String get nothingHere => 'ما فيه شي هنا';

  @override
  String get sendReminder => 'تذكير';

  @override
  String get reminderSent => 'تم التذكير';

  @override
  String get recordCash => 'تسجيل دفعة';

  @override
  String get paymentRecorded => 'تم تسجيل الدفعة والشباك نوّر';

  @override
  String viaWhatsApp(String phone) {
    return 'عبر واتساب إلى $phone';
  }

  @override
  String reminderLateMsg(String name, String unit, String amount, String date) {
    return 'السلام عليكم $name، نذكّرك إن دفعة الإيجار لوحدة $unit بقيمة $amount كانت مستحقة بتاريخ $date. تقدر تدفع من تطبيق مفتاح. شكرًا لك.';
  }

  @override
  String reminderSoonMsg(String name, String unit, String amount, String date) {
    return 'السلام عليكم $name، نذكّرك إن دفعة الإيجار لوحدة $unit بقيمة $amount مستحقة بتاريخ $date. تقدر تدفع مبكر من تطبيق مفتاح.';
  }

  @override
  String get send => 'إرسال';

  @override
  String reminderSentTo(String name) {
    return 'تم إرسال التذكير إلى $name';
  }

  @override
  String boardSubtitle(int open, String spend) {
    return '$open طلب مفتوح · صرف الصيانة $spend. اسحب الكرت لتغيير حالته.';
  }

  @override
  String get dropHere => 'اسحب الطلب هنا';

  @override
  String movedTo(String status) {
    return 'انتقل إلى: $status';
  }

  @override
  String get reportsSubtitle => 'دخلك وإشغالك خلال آخر 12 شهر.';

  @override
  String get allProperties => 'كل العقارات';

  @override
  String get income12m => 'الدخل خلال 12 شهر';

  @override
  String bestMonth(String month) {
    return 'أعلى شهر: $month';
  }

  @override
  String get byProperty => 'حسب العقار';

  @override
  String get occupancyByProperty => 'الإشغال حسب العقار';

  @override
  String get methodsMix => 'طرق الدفع';

  @override
  String tenantsSubtitle(int n) {
    return '$n مستأجر بعقود سارية';
  }

  @override
  String get searchTenants => 'ابحث بالاسم أو رقم الوحدة';

  @override
  String get chooseUnit => 'اختر الوحدة';

  @override
  String get tenantDetails => 'بيانات المستأجر';

  @override
  String get leaseTerms => 'شروط العقد';

  @override
  String vacantUnitsCount(int n) {
    return '$n وحدات شاغرة';
  }

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get mobile => 'رقم الجوال';

  @override
  String get phoneInvalid => 'رقم جوال سعودي يبدأ بـ 5 ومكوّن من 9 أرقام';

  @override
  String get nationalIdOrIqama => 'رقم الهوية أو الإقامة';

  @override
  String get fillSample => 'تعبئة ببيانات تجريبية';

  @override
  String get startDate => 'بداية العقد';

  @override
  String get today => 'اليوم';

  @override
  String get firstOfNextMonth => 'أول الشهر الجاي';

  @override
  String get annualRentSar => 'الإيجار السنوي (ر.س)';

  @override
  String get installment => 'الدفعات';

  @override
  String get ejarNote =>
      'بعد التأكيد يتسجل العقد في إيجار ويوصل المستأجر رابط التوثيق.';

  @override
  String get createLease => 'إنشاء العقد';

  @override
  String get leaseCreated => 'تم إنشاء العقد وتأجير الوحدة';

  @override
  String get city => 'المدينة';

  @override
  String get riyadh => 'الرياض';

  @override
  String get vatNumber => 'الرقم الضريبي';

  @override
  String get builtWith => 'مبني بـ Flutter · Android و iOS والويب';

  @override
  String get frameTitle => 'إدارة الإيجارات بشكل يليق بعقارك';

  @override
  String get frameSubtitle =>
      'تطبيق للمستأجر والمالك في نفس الوقت: دفع الإيجار، الصيانة، العقود والتحصيل، بواجهة حية تبيّن حالة كل وحدة.';

  @override
  String get featureFacade => 'واجهة حية: كل شباك وحدة ولونه حالة الإيجار';

  @override
  String get featureKeyCard => 'كارت مفتاح رقمي للمستأجر بيتقلب ويبيّن العقد';

  @override
  String get featurePayments =>
      'دفع بمدى و Apple Pay و STC Pay مع إيصالات فورية';

  @override
  String get featureMaintenance =>
      'طلبات صيانة بخط زمني ولوحة سحب وإفلات للمالك';

  @override
  String get featureBilingual => 'عربي وإنجليزي، ليلي ونهاري';

  @override
  String get frameTryIt => 'جرّب الآن';

  @override
  String get downloadApk => 'حمّل نسخة أندرويد';
}
