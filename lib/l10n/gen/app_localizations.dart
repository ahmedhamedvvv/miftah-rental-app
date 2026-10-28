import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'مِفتاح'**
  String get appName;

  /// No description provided for @welcomeEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الأملاك المؤجرة'**
  String get welcomeEyebrow;

  /// No description provided for @welcomeTitle.
  ///
  /// In ar, this message translates to:
  /// **'عمارتك كلها في شاشة واحدة'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'المستأجر يدفع إيجاره ويطلب الصيانة من جواله، والمالك يتابع التحصيل والوحدات لحظة بلحظة.'**
  String get welcomeSubtitle;

  /// No description provided for @roleTenant.
  ///
  /// In ar, this message translates to:
  /// **'أنا مستأجر'**
  String get roleTenant;

  /// No description provided for @roleTenantDesc.
  ///
  /// In ar, this message translates to:
  /// **'ادفع إيجارك، تابع عقدك واطلب صيانة'**
  String get roleTenantDesc;

  /// No description provided for @roleOwner.
  ///
  /// In ar, this message translates to:
  /// **'أنا مالك أو مكتب عقار'**
  String get roleOwner;

  /// No description provided for @roleOwnerDesc.
  ///
  /// In ar, this message translates to:
  /// **'الواجهة الحية، التحصيل، الصيانة والتقارير'**
  String get roleOwnerDesc;

  /// No description provided for @demoNote.
  ///
  /// In ar, this message translates to:
  /// **'نسخة تجريبية ببيانات واقعية من الرياض'**
  String get demoNote;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navPayments.
  ///
  /// In ar, this message translates to:
  /// **'الدفعات'**
  String get navPayments;

  /// No description provided for @navMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'الصيانة'**
  String get navMaintenance;

  /// No description provided for @navLease.
  ///
  /// In ar, this message translates to:
  /// **'العقد'**
  String get navLease;

  /// No description provided for @navFacade.
  ///
  /// In ar, this message translates to:
  /// **'الواجهة'**
  String get navFacade;

  /// No description provided for @navProperties.
  ///
  /// In ar, this message translates to:
  /// **'العقارات'**
  String get navProperties;

  /// No description provided for @navCollections.
  ///
  /// In ar, this message translates to:
  /// **'التحصيل'**
  String get navCollections;

  /// No description provided for @navReports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get navReports;

  /// No description provided for @statusPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوع'**
  String get statusPaid;

  /// No description provided for @statusDueSoon.
  ///
  /// In ar, this message translates to:
  /// **'قرّب'**
  String get statusDueSoon;

  /// No description provided for @statusLate.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get statusLate;

  /// No description provided for @statusVacant.
  ///
  /// In ar, this message translates to:
  /// **'شاغرة'**
  String get statusVacant;

  /// No description provided for @statusUnpaid.
  ///
  /// In ar, this message translates to:
  /// **'مستحق'**
  String get statusUnpaid;

  /// No description provided for @kindApartment.
  ///
  /// In ar, this message translates to:
  /// **'شقة'**
  String get kindApartment;

  /// No description provided for @kindVilla.
  ///
  /// In ar, this message translates to:
  /// **'فيلا'**
  String get kindVilla;

  /// No description provided for @kindShop.
  ///
  /// In ar, this message translates to:
  /// **'محل'**
  String get kindShop;

  /// No description provided for @kindOffice.
  ///
  /// In ar, this message translates to:
  /// **'مكتب'**
  String get kindOffice;

  /// No description provided for @freqAnnual.
  ///
  /// In ar, this message translates to:
  /// **'دفعة سنوية'**
  String get freqAnnual;

  /// No description provided for @freqSemiAnnual.
  ///
  /// In ar, this message translates to:
  /// **'نصف سنوي'**
  String get freqSemiAnnual;

  /// No description provided for @freqQuarterly.
  ///
  /// In ar, this message translates to:
  /// **'ربع سنوي'**
  String get freqQuarterly;

  /// No description provided for @freqMonthly.
  ///
  /// In ar, this message translates to:
  /// **'شهري'**
  String get freqMonthly;

  /// No description provided for @methodMada.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة مدى'**
  String get methodMada;

  /// No description provided for @methodBank.
  ///
  /// In ar, this message translates to:
  /// **'تحويل بنكي'**
  String get methodBank;

  /// No description provided for @methodCash.
  ///
  /// In ar, this message translates to:
  /// **'نقدًا'**
  String get methodCash;

  /// No description provided for @catAc.
  ///
  /// In ar, this message translates to:
  /// **'تكييف'**
  String get catAc;

  /// No description provided for @catPlumbing.
  ///
  /// In ar, this message translates to:
  /// **'سباكة'**
  String get catPlumbing;

  /// No description provided for @catElectrical.
  ///
  /// In ar, this message translates to:
  /// **'كهرباء'**
  String get catElectrical;

  /// No description provided for @catAppliances.
  ///
  /// In ar, this message translates to:
  /// **'أجهزة ومطبخ'**
  String get catAppliances;

  /// No description provided for @catOther.
  ///
  /// In ar, this message translates to:
  /// **'صيانة عامة'**
  String get catOther;

  /// No description provided for @tsOpen.
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام'**
  String get tsOpen;

  /// No description provided for @tsAssigned.
  ///
  /// In ar, this message translates to:
  /// **'تم تعيين فني'**
  String get tsAssigned;

  /// No description provided for @tsInProgress.
  ///
  /// In ar, this message translates to:
  /// **'جاري العمل'**
  String get tsInProgress;

  /// No description provided for @tsDone.
  ///
  /// In ar, this message translates to:
  /// **'تم الإنجاز'**
  String get tsDone;

  /// No description provided for @slotMorning.
  ///
  /// In ar, this message translates to:
  /// **'الصباح'**
  String get slotMorning;

  /// No description provided for @slotAfternoon.
  ///
  /// In ar, this message translates to:
  /// **'بعد الظهر'**
  String get slotAfternoon;

  /// No description provided for @slotEvening.
  ///
  /// In ar, this message translates to:
  /// **'المساء'**
  String get slotEvening;

  /// No description provided for @goodMorning.
  ///
  /// In ar, this message translates to:
  /// **'صباح الخير، {name}'**
  String goodMorning(String name);

  /// No description provided for @goodEvening.
  ///
  /// In ar, this message translates to:
  /// **'مساء الخير، {name}'**
  String goodEvening(String name);

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @tapCardHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على الكارت عشان تشوف عقدك'**
  String get tapCardHint;

  /// No description provided for @payRent.
  ///
  /// In ar, this message translates to:
  /// **'ادفع الإيجار'**
  String get payRent;

  /// No description provided for @payNowLate.
  ///
  /// In ar, this message translates to:
  /// **'ادفع الآن، الدفعة متأخرة'**
  String get payNowLate;

  /// No description provided for @noOpenRequests.
  ///
  /// In ar, this message translates to:
  /// **'ما فيه طلبات مفتوحة'**
  String get noOpenRequests;

  /// No description provided for @allGood.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لطلب صيانة'**
  String get allGood;

  /// No description provided for @paidOfTotal.
  ///
  /// In ar, this message translates to:
  /// **'{paid} من {total}'**
  String paidOfTotal(int paid, int total);

  /// No description provided for @installmentsThisLease.
  ///
  /// In ar, this message translates to:
  /// **'دفعات مسددة'**
  String get installmentsThisLease;

  /// No description provided for @myHome.
  ///
  /// In ar, this message translates to:
  /// **'وحدتي'**
  String get myHome;

  /// No description provided for @bedrooms.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{غرفة نوم} =2{غرفتين نوم} few{{count} غرف نوم} other{{count} غرفة نوم}}'**
  String bedrooms(int count);

  /// No description provided for @areaSqm.
  ///
  /// In ar, this message translates to:
  /// **'{n} م²'**
  String areaSqm(int n);

  /// No description provided for @floorN.
  ///
  /// In ar, this message translates to:
  /// **'الدور {n}'**
  String floorN(int n);

  /// No description provided for @quickActions.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات سريعة'**
  String get quickActions;

  /// No description provided for @newRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب صيانة جديد'**
  String get newRequest;

  /// No description provided for @myLease.
  ///
  /// In ar, this message translates to:
  /// **'عقدي'**
  String get myLease;

  /// No description provided for @contactOwner.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع المالك'**
  String get contactOwner;

  /// No description provided for @contactOwnerBody.
  ///
  /// In ar, this message translates to:
  /// **'مكتب إدارة العقار يرد عليك خلال ساعات العمل.'**
  String get contactOwnerBody;

  /// No description provided for @officeName.
  ///
  /// In ar, this message translates to:
  /// **'المكتب'**
  String get officeName;

  /// No description provided for @officeNameValue.
  ///
  /// In ar, this message translates to:
  /// **'الأفق لإدارة الأملاك'**
  String get officeNameValue;

  /// No description provided for @officeLicense.
  ///
  /// In ar, this message translates to:
  /// **'ترخيص فال 1200012345'**
  String get officeLicense;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'الهاتف'**
  String get phone;

  /// No description provided for @workingHours.
  ///
  /// In ar, this message translates to:
  /// **'ساعات العمل'**
  String get workingHours;

  /// No description provided for @workingHoursValue.
  ///
  /// In ar, this message translates to:
  /// **'الأحد إلى الخميس، 9 ص – 6 م'**
  String get workingHoursValue;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @allPaid.
  ///
  /// In ar, this message translates to:
  /// **'كل الدفعات مسددة'**
  String get allPaid;

  /// No description provided for @nextInstallment.
  ///
  /// In ar, this message translates to:
  /// **'الدفعة الجاية'**
  String get nextInstallment;

  /// No description provided for @lateShort.
  ///
  /// In ar, this message translates to:
  /// **'متأخرة'**
  String get lateShort;

  /// No description provided for @daysShort.
  ///
  /// In ar, this message translates to:
  /// **'يوم'**
  String get daysShort;

  /// No description provided for @leaseEnds.
  ///
  /// In ar, this message translates to:
  /// **'العقد ينتهي {date}'**
  String leaseEnds(String date);

  /// No description provided for @wasDue.
  ///
  /// In ar, this message translates to:
  /// **'كانت مستحقة {date}'**
  String wasDue(String date);

  /// No description provided for @dueOn.
  ///
  /// In ar, this message translates to:
  /// **'تستحق {date}'**
  String dueOn(String date);

  /// No description provided for @leaseDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل العقد'**
  String get leaseDetails;

  /// No description provided for @unit.
  ///
  /// In ar, this message translates to:
  /// **'الوحدة'**
  String get unit;

  /// No description provided for @leasePeriod.
  ///
  /// In ar, this message translates to:
  /// **'مدة العقد'**
  String get leasePeriod;

  /// No description provided for @annualRent.
  ///
  /// In ar, this message translates to:
  /// **'الإيجار السنوي'**
  String get annualRent;

  /// No description provided for @paymentPlan.
  ///
  /// In ar, this message translates to:
  /// **'طريقة السداد'**
  String get paymentPlan;

  /// No description provided for @paySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ادفع بأمان، والإيصال يوصلك فورًا.'**
  String get paySubtitle;

  /// No description provided for @payAmount.
  ///
  /// In ar, this message translates to:
  /// **'ادفع {amount}'**
  String payAmount(String amount);

  /// No description provided for @installmentN.
  ///
  /// In ar, this message translates to:
  /// **'الدفعة رقم {n}'**
  String installmentN(int n);

  /// No description provided for @rent.
  ///
  /// In ar, this message translates to:
  /// **'الإيجار'**
  String get rent;

  /// No description provided for @vat.
  ///
  /// In ar, this message translates to:
  /// **'ضريبة القيمة المضافة'**
  String get vat;

  /// No description provided for @vatExempt.
  ///
  /// In ar, this message translates to:
  /// **'معفى (سكني)'**
  String get vatExempt;

  /// No description provided for @vat15.
  ///
  /// In ar, this message translates to:
  /// **'15%'**
  String get vat15;

  /// No description provided for @payWith.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get payWith;

  /// No description provided for @applePayNote.
  ///
  /// In ar, this message translates to:
  /// **'أكّد الدفع ببصمة الوجه أو الإصبع على جهازك.'**
  String get applePayNote;

  /// No description provided for @stcPayNote.
  ///
  /// In ar, this message translates to:
  /// **'بيوصلك طلب الدفع على محفظة STC Pay المسجلة برقم {phone}.'**
  String stcPayNote(String phone);

  /// No description provided for @bankName.
  ///
  /// In ar, this message translates to:
  /// **'البنك'**
  String get bankName;

  /// No description provided for @bankNameValue.
  ///
  /// In ar, this message translates to:
  /// **'مصرف الراجحي'**
  String get bankNameValue;

  /// No description provided for @beneficiary.
  ///
  /// In ar, this message translates to:
  /// **'المستفيد'**
  String get beneficiary;

  /// No description provided for @bankNote.
  ///
  /// In ar, this message translates to:
  /// **'اكتب رقم الوحدة في ملاحظة التحويل. في الديمو يتسجل التحويل مباشرة.'**
  String get bankNote;

  /// No description provided for @secureNote.
  ///
  /// In ar, this message translates to:
  /// **'نسخة تجريبية: ما فيه أي خصم حقيقي من حسابك.'**
  String get secureNote;

  /// No description provided for @paymentDone.
  ///
  /// In ar, this message translates to:
  /// **'تم الدفع بنجاح'**
  String get paymentDone;

  /// No description provided for @paymentDoneBody.
  ///
  /// In ar, this message translates to:
  /// **'وصلت دفعتك للمالك وتحدّث سجل دفعاتك.'**
  String get paymentDoneBody;

  /// No description provided for @receipt.
  ///
  /// In ar, this message translates to:
  /// **'الإيصال'**
  String get receipt;

  /// No description provided for @receiptBody.
  ///
  /// In ar, this message translates to:
  /// **'إيصال إلكتروني معتمد من مكتب العقار.'**
  String get receiptBody;

  /// No description provided for @receiptNo.
  ///
  /// In ar, this message translates to:
  /// **'رقم الإيصال'**
  String get receiptNo;

  /// No description provided for @paidOn.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الدفع'**
  String get paidOn;

  /// No description provided for @method.
  ///
  /// In ar, this message translates to:
  /// **'الطريقة'**
  String get method;

  /// No description provided for @tenant.
  ///
  /// In ar, this message translates to:
  /// **'المستأجر'**
  String get tenant;

  /// No description provided for @ejarContract.
  ///
  /// In ar, this message translates to:
  /// **'عقد إيجار'**
  String get ejarContract;

  /// No description provided for @installmentLabel.
  ///
  /// In ar, this message translates to:
  /// **'الدفعة'**
  String get installmentLabel;

  /// No description provided for @installmentOf.
  ///
  /// In ar, this message translates to:
  /// **'الدفعة {n} من {total}'**
  String installmentOf(int n, int total);

  /// No description provided for @totalPaid.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get totalPaid;

  /// No description provided for @backHome.
  ///
  /// In ar, this message translates to:
  /// **'رجوع للرئيسية'**
  String get backHome;

  /// No description provided for @copyReceipt.
  ///
  /// In ar, this message translates to:
  /// **'نسخ الإيصال'**
  String get copyReceipt;

  /// No description provided for @copied.
  ///
  /// In ar, this message translates to:
  /// **'تم النسخ'**
  String get copied;

  /// No description provided for @paymentsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كل دفعاتك وإيصالاتك في مكان واحد.'**
  String get paymentsSubtitle;

  /// No description provided for @paidThisLease.
  ///
  /// In ar, this message translates to:
  /// **'المدفوع من العقد'**
  String get paidThisLease;

  /// No description provided for @remaining.
  ///
  /// In ar, this message translates to:
  /// **'المتبقي'**
  String get remaining;

  /// No description provided for @upcoming.
  ///
  /// In ar, this message translates to:
  /// **'الجاية'**
  String get upcoming;

  /// No description provided for @paidHistory.
  ///
  /// In ar, this message translates to:
  /// **'المدفوعة'**
  String get paidHistory;

  /// No description provided for @nothingDue.
  ///
  /// In ar, this message translates to:
  /// **'ما عليك أي دفعات حاليًا'**
  String get nothingDue;

  /// No description provided for @maintenanceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اطلب فني وتابع طلبك خطوة بخطوة.'**
  String get maintenanceSubtitle;

  /// No description provided for @newRequestHint.
  ///
  /// In ar, this message translates to:
  /// **'تكييف، سباكة، كهرباء والمزيد'**
  String get newRequestHint;

  /// No description provided for @activeRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات مفتوحة'**
  String get activeRequests;

  /// No description provided for @pastRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات سابقة'**
  String get pastRequests;

  /// No description provided for @noPastRequests.
  ///
  /// In ar, this message translates to:
  /// **'ما فيه طلبات سابقة'**
  String get noPastRequests;

  /// No description provided for @urgent.
  ///
  /// In ar, this message translates to:
  /// **'عاجل'**
  String get urgent;

  /// No description provided for @stepWhat.
  ///
  /// In ar, this message translates to:
  /// **'وش المشكلة؟'**
  String get stepWhat;

  /// No description provided for @stepDescribe.
  ///
  /// In ar, this message translates to:
  /// **'وصّف لنا المشكلة'**
  String get stepDescribe;

  /// No description provided for @stepWhen.
  ///
  /// In ar, this message translates to:
  /// **'متى يناسبك الفني؟'**
  String get stepWhen;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @sendRequest.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الطلب'**
  String get sendRequest;

  /// No description provided for @requestSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلبك #{n}'**
  String requestSent(int n);

  /// No description provided for @describeHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: المكيف يطلع صوت ومو يبرد من أمس'**
  String get describeHint;

  /// No description provided for @urgentTitle.
  ///
  /// In ar, this message translates to:
  /// **'الطلب عاجل'**
  String get urgentTitle;

  /// No description provided for @urgentBody.
  ///
  /// In ar, this message translates to:
  /// **'تسريب مويه، انقطاع كهرباء أو خطر'**
  String get urgentBody;

  /// No description provided for @visitDay.
  ///
  /// In ar, this message translates to:
  /// **'الزيارة يوم {date}'**
  String visitDay(String date);

  /// No description provided for @category.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get category;

  /// No description provided for @priority.
  ///
  /// In ar, this message translates to:
  /// **'الأولوية'**
  String get priority;

  /// No description provided for @normal.
  ///
  /// In ar, this message translates to:
  /// **'عادي'**
  String get normal;

  /// No description provided for @details.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get details;

  /// No description provided for @presetAc1.
  ///
  /// In ar, this message translates to:
  /// **'المكيف ما يبرد'**
  String get presetAc1;

  /// No description provided for @presetAc2.
  ///
  /// In ar, this message translates to:
  /// **'صوت عالي من المكيف'**
  String get presetAc2;

  /// No description provided for @presetAc3.
  ///
  /// In ar, this message translates to:
  /// **'تسريب مويه من المكيف'**
  String get presetAc3;

  /// No description provided for @presetPl1.
  ///
  /// In ar, this message translates to:
  /// **'تسريب تحت المغسلة'**
  String get presetPl1;

  /// No description provided for @presetPl2.
  ///
  /// In ar, this message translates to:
  /// **'السخان ما يسخن'**
  String get presetPl2;

  /// No description provided for @presetPl3.
  ///
  /// In ar, this message translates to:
  /// **'انسداد في التصريف'**
  String get presetPl3;

  /// No description provided for @presetEl1.
  ///
  /// In ar, this message translates to:
  /// **'الكهرباء تفصل'**
  String get presetEl1;

  /// No description provided for @presetEl2.
  ///
  /// In ar, this message translates to:
  /// **'أفياش ما تشتغل'**
  String get presetEl2;

  /// No description provided for @presetEl3.
  ///
  /// In ar, this message translates to:
  /// **'إضاءة معطلة'**
  String get presetEl3;

  /// No description provided for @presetAp1.
  ///
  /// In ar, this message translates to:
  /// **'الفرن ما يشتغل'**
  String get presetAp1;

  /// No description provided for @presetAp2.
  ///
  /// In ar, this message translates to:
  /// **'باب الكراج يعلق'**
  String get presetAp2;

  /// No description provided for @presetOt1.
  ///
  /// In ar, this message translates to:
  /// **'قفل الباب يعلق'**
  String get presetOt1;

  /// No description provided for @presetOt2.
  ///
  /// In ar, this message translates to:
  /// **'تشققات في الجدار'**
  String get presetOt2;

  /// No description provided for @technician.
  ///
  /// In ar, this message translates to:
  /// **'الفني'**
  String get technician;

  /// No description provided for @change.
  ///
  /// In ar, this message translates to:
  /// **'تغيير'**
  String get change;

  /// No description provided for @preferredTime.
  ///
  /// In ar, this message translates to:
  /// **'الوقت المفضل'**
  String get preferredTime;

  /// No description provided for @cost.
  ///
  /// In ar, this message translates to:
  /// **'التكلفة'**
  String get cost;

  /// No description provided for @costSar.
  ///
  /// In ar, this message translates to:
  /// **'التكلفة (ر.س)'**
  String get costSar;

  /// No description provided for @thanksRating.
  ///
  /// In ar, this message translates to:
  /// **'شكرًا لتقييمك'**
  String get thanksRating;

  /// No description provided for @assignTechnician.
  ///
  /// In ar, this message translates to:
  /// **'تعيين فني'**
  String get assignTechnician;

  /// No description provided for @assigned.
  ///
  /// In ar, this message translates to:
  /// **'تم تعيين الفني وإشعار المستأجر'**
  String get assigned;

  /// No description provided for @startWork.
  ///
  /// In ar, this message translates to:
  /// **'بدء العمل'**
  String get startWork;

  /// No description provided for @markDone.
  ///
  /// In ar, this message translates to:
  /// **'إنهاء الطلب'**
  String get markDone;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @ticketClosed.
  ///
  /// In ar, this message translates to:
  /// **'تم إنهاء الطلب'**
  String get ticketClosed;

  /// No description provided for @tenantRating.
  ///
  /// In ar, this message translates to:
  /// **'تقييم المستأجر'**
  String get tenantRating;

  /// No description provided for @rateService.
  ///
  /// In ar, this message translates to:
  /// **'قيّم الخدمة'**
  String get rateService;

  /// No description provided for @yourRating.
  ///
  /// In ar, this message translates to:
  /// **'تقييمك'**
  String get yourRating;

  /// No description provided for @leaseSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'عقدك موثّق في منصة إيجار.'**
  String get leaseSubtitle;

  /// No description provided for @ejarRegistered.
  ///
  /// In ar, this message translates to:
  /// **'موثّق في إيجار'**
  String get ejarRegistered;

  /// No description provided for @daysLeftInLease.
  ///
  /// In ar, this message translates to:
  /// **'باقي {n} يوم'**
  String daysLeftInLease(int n);

  /// No description provided for @nationalId.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهوية'**
  String get nationalId;

  /// No description provided for @property.
  ///
  /// In ar, this message translates to:
  /// **'العقار'**
  String get property;

  /// No description provided for @leaseType.
  ///
  /// In ar, this message translates to:
  /// **'نوع العقد'**
  String get leaseType;

  /// No description provided for @residential.
  ///
  /// In ar, this message translates to:
  /// **'سكني'**
  String get residential;

  /// No description provided for @commercial.
  ///
  /// In ar, this message translates to:
  /// **'تجاري'**
  String get commercial;

  /// No description provided for @commercialVat.
  ///
  /// In ar, this message translates to:
  /// **'تجاري (+15% ضريبة)'**
  String get commercialVat;

  /// No description provided for @securityDeposit.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ التأمين'**
  String get securityDeposit;

  /// No description provided for @schedule.
  ///
  /// In ar, this message translates to:
  /// **'جدول الدفعات'**
  String get schedule;

  /// No description provided for @renewTitle.
  ///
  /// In ar, this message translates to:
  /// **'تبي تجدد عقدك؟'**
  String get renewTitle;

  /// No description provided for @renewBody.
  ///
  /// In ar, this message translates to:
  /// **'أرسل طلب التجديد للمالك قبل انتهاء العقد بوقت كافي.'**
  String get renewBody;

  /// No description provided for @requestRenewal.
  ///
  /// In ar, this message translates to:
  /// **'طلب تجديد'**
  String get requestRenewal;

  /// No description provided for @renewalSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب التجديد'**
  String get renewalSent;

  /// No description provided for @renewalSentBody.
  ///
  /// In ar, this message translates to:
  /// **'المالك بيراجع الطلب ويتواصل معك.'**
  String get renewalSentBody;

  /// No description provided for @preferences.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الليلي'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع النهاري'**
  String get lightMode;

  /// No description provided for @switchToOwner.
  ///
  /// In ar, this message translates to:
  /// **'جرّب واجهة المالك'**
  String get switchToOwner;

  /// No description provided for @switchToTenant.
  ///
  /// In ar, this message translates to:
  /// **'جرّب واجهة المستأجر'**
  String get switchToTenant;

  /// No description provided for @resetDemo.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين الديمو'**
  String get resetDemo;

  /// No description provided for @demoReset.
  ///
  /// In ar, this message translates to:
  /// **'رجعت البيانات التجريبية لحالتها الأولى'**
  String get demoReset;

  /// No description provided for @backToWelcome.
  ///
  /// In ar, this message translates to:
  /// **'شاشة البداية'**
  String get backToWelcome;

  /// No description provided for @tenants.
  ///
  /// In ar, this message translates to:
  /// **'المستأجرين'**
  String get tenants;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @collectedThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'المحصّل هذا الشهر'**
  String get collectedThisMonth;

  /// No description provided for @paymentsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{ما فيه دفعات} =1{دفعة واحدة} =2{دفعتين} few{{count} دفعات} other{{count} دفعة}}'**
  String paymentsCount(int count);

  /// No description provided for @overdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخرات'**
  String get overdue;

  /// No description provided for @openTickets.
  ///
  /// In ar, this message translates to:
  /// **'طلبات صيانة'**
  String get openTickets;

  /// No description provided for @occupancy.
  ///
  /// In ar, this message translates to:
  /// **'الإشغال'**
  String get occupancy;

  /// No description provided for @occupancyBody.
  ///
  /// In ar, this message translates to:
  /// **'{a} وحدة مؤجرة من أصل {b}'**
  String occupancyBody(int a, int b);

  /// No description provided for @liveFacade.
  ///
  /// In ar, this message translates to:
  /// **'الواجهة الحية'**
  String get liveFacade;

  /// No description provided for @viewProperty.
  ///
  /// In ar, this message translates to:
  /// **'عرض العقار'**
  String get viewProperty;

  /// No description provided for @needsAttention.
  ///
  /// In ar, this message translates to:
  /// **'يحتاج متابعة'**
  String get needsAttention;

  /// No description provided for @lateRent.
  ///
  /// In ar, this message translates to:
  /// **'إيجار متأخر: {name}'**
  String lateRent(String name);

  /// No description provided for @daysLate.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{متأخر يوم} =2{متأخر يومين} few{متأخر {count} أيام} other{متأخر {count} يوم}}'**
  String daysLate(int count);

  /// No description provided for @newTicket.
  ///
  /// In ar, this message translates to:
  /// **'طلب {category}'**
  String newTicket(String category);

  /// No description provided for @leaseEnding.
  ///
  /// In ar, this message translates to:
  /// **'عقد ينتهي: {name}'**
  String leaseEnding(String name);

  /// No description provided for @inDays.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{اليوم} =1{بكرة} =2{بعد يومين} few{بعد {count} أيام} other{بعد {count} يوم}}'**
  String inDays(int count);

  /// No description provided for @overdueSince.
  ///
  /// In ar, this message translates to:
  /// **'متأخر من'**
  String get overdueSince;

  /// No description provided for @vacantSince.
  ///
  /// In ar, this message translates to:
  /// **'الوحدة شاغرة وجاهزة للتأجير.'**
  String get vacantSince;

  /// No description provided for @openUnit.
  ///
  /// In ar, this message translates to:
  /// **'ملف الوحدة'**
  String get openUnit;

  /// No description provided for @leaseIt.
  ///
  /// In ar, this message translates to:
  /// **'أجّر الوحدة'**
  String get leaseIt;

  /// No description provided for @propertiesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'{p} عقارات · {u} وحدة'**
  String propertiesSubtitle(int p, int u);

  /// No description provided for @newLease.
  ///
  /// In ar, this message translates to:
  /// **'عقد جديد'**
  String get newLease;

  /// No description provided for @units.
  ///
  /// In ar, this message translates to:
  /// **'الوحدات'**
  String get units;

  /// No description provided for @yearIncome.
  ///
  /// In ar, this message translates to:
  /// **'دخل 12 شهر'**
  String get yearIncome;

  /// No description provided for @builtIn.
  ///
  /// In ar, this message translates to:
  /// **'بناء {year}'**
  String builtIn(String year);

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @rooms.
  ///
  /// In ar, this message translates to:
  /// **'الغرف'**
  String get rooms;

  /// No description provided for @area.
  ///
  /// In ar, this message translates to:
  /// **'المساحة'**
  String get area;

  /// No description provided for @unitVacantTitle.
  ///
  /// In ar, this message translates to:
  /// **'الوحدة شاغرة'**
  String get unitVacantTitle;

  /// No description provided for @unitVacantBody.
  ///
  /// In ar, this message translates to:
  /// **'أضف المستأجر والعقد في أقل من دقيقة، والشباك ينوّر في الواجهة مباشرة.'**
  String get unitVacantBody;

  /// No description provided for @renewal.
  ///
  /// In ar, this message translates to:
  /// **'التجديد'**
  String get renewal;

  /// No description provided for @renewalRequested.
  ///
  /// In ar, this message translates to:
  /// **'المستأجر طلب التجديد'**
  String get renewalRequested;

  /// No description provided for @maintenanceHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل الصيانة'**
  String get maintenanceHistory;

  /// No description provided for @collectionRate.
  ///
  /// In ar, this message translates to:
  /// **'نسبة التحصيل هذا الشهر'**
  String get collectionRate;

  /// No description provided for @collectedOf.
  ///
  /// In ar, this message translates to:
  /// **'{a} من {b}'**
  String collectedOf(String a, String b);

  /// No description provided for @collected.
  ///
  /// In ar, this message translates to:
  /// **'محصّل'**
  String get collected;

  /// No description provided for @dueThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'مستحق هذا الشهر'**
  String get dueThisMonth;

  /// No description provided for @nothingHere.
  ///
  /// In ar, this message translates to:
  /// **'ما فيه شي هنا'**
  String get nothingHere;

  /// No description provided for @sendReminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير'**
  String get sendReminder;

  /// No description provided for @reminderSent.
  ///
  /// In ar, this message translates to:
  /// **'تم التذكير'**
  String get reminderSent;

  /// No description provided for @recordCash.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دفعة'**
  String get recordCash;

  /// No description provided for @paymentRecorded.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدفعة والشباك نوّر'**
  String get paymentRecorded;

  /// No description provided for @viaWhatsApp.
  ///
  /// In ar, this message translates to:
  /// **'عبر واتساب إلى {phone}'**
  String viaWhatsApp(String phone);

  /// No description provided for @reminderLateMsg.
  ///
  /// In ar, this message translates to:
  /// **'السلام عليكم {name}، نذكّرك إن دفعة الإيجار لوحدة {unit} بقيمة {amount} كانت مستحقة بتاريخ {date}. تقدر تدفع من تطبيق مفتاح. شكرًا لك.'**
  String reminderLateMsg(String name, String unit, String amount, String date);

  /// No description provided for @reminderSoonMsg.
  ///
  /// In ar, this message translates to:
  /// **'السلام عليكم {name}، نذكّرك إن دفعة الإيجار لوحدة {unit} بقيمة {amount} مستحقة بتاريخ {date}. تقدر تدفع مبكر من تطبيق مفتاح.'**
  String reminderSoonMsg(String name, String unit, String amount, String date);

  /// No description provided for @send.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get send;

  /// No description provided for @reminderSentTo.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال التذكير إلى {name}'**
  String reminderSentTo(String name);

  /// No description provided for @boardSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'{open} طلب مفتوح · صرف الصيانة {spend}. اسحب الكرت لتغيير حالته.'**
  String boardSubtitle(int open, String spend);

  /// No description provided for @dropHere.
  ///
  /// In ar, this message translates to:
  /// **'اسحب الطلب هنا'**
  String get dropHere;

  /// No description provided for @movedTo.
  ///
  /// In ar, this message translates to:
  /// **'انتقل إلى: {status}'**
  String movedTo(String status);

  /// No description provided for @reportsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'دخلك وإشغالك خلال آخر 12 شهر.'**
  String get reportsSubtitle;

  /// No description provided for @allProperties.
  ///
  /// In ar, this message translates to:
  /// **'كل العقارات'**
  String get allProperties;

  /// No description provided for @income12m.
  ///
  /// In ar, this message translates to:
  /// **'الدخل خلال 12 شهر'**
  String get income12m;

  /// No description provided for @bestMonth.
  ///
  /// In ar, this message translates to:
  /// **'أعلى شهر: {month}'**
  String bestMonth(String month);

  /// No description provided for @byProperty.
  ///
  /// In ar, this message translates to:
  /// **'حسب العقار'**
  String get byProperty;

  /// No description provided for @occupancyByProperty.
  ///
  /// In ar, this message translates to:
  /// **'الإشغال حسب العقار'**
  String get occupancyByProperty;

  /// No description provided for @methodsMix.
  ///
  /// In ar, this message translates to:
  /// **'طرق الدفع'**
  String get methodsMix;

  /// No description provided for @tenantsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'{n} مستأجر بعقود سارية'**
  String tenantsSubtitle(int n);

  /// No description provided for @searchTenants.
  ///
  /// In ar, this message translates to:
  /// **'ابحث بالاسم أو رقم الوحدة'**
  String get searchTenants;

  /// No description provided for @chooseUnit.
  ///
  /// In ar, this message translates to:
  /// **'اختر الوحدة'**
  String get chooseUnit;

  /// No description provided for @tenantDetails.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المستأجر'**
  String get tenantDetails;

  /// No description provided for @leaseTerms.
  ///
  /// In ar, this message translates to:
  /// **'شروط العقد'**
  String get leaseTerms;

  /// No description provided for @vacantUnitsCount.
  ///
  /// In ar, this message translates to:
  /// **'{n} وحدات شاغرة'**
  String vacantUnitsCount(int n);

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @mobile.
  ///
  /// In ar, this message translates to:
  /// **'رقم الجوال'**
  String get mobile;

  /// No description provided for @phoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم جوال سعودي يبدأ بـ 5 ومكوّن من 9 أرقام'**
  String get phoneInvalid;

  /// No description provided for @nationalIdOrIqama.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهوية أو الإقامة'**
  String get nationalIdOrIqama;

  /// No description provided for @fillSample.
  ///
  /// In ar, this message translates to:
  /// **'تعبئة ببيانات تجريبية'**
  String get fillSample;

  /// No description provided for @startDate.
  ///
  /// In ar, this message translates to:
  /// **'بداية العقد'**
  String get startDate;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @firstOfNextMonth.
  ///
  /// In ar, this message translates to:
  /// **'أول الشهر الجاي'**
  String get firstOfNextMonth;

  /// No description provided for @annualRentSar.
  ///
  /// In ar, this message translates to:
  /// **'الإيجار السنوي (ر.س)'**
  String get annualRentSar;

  /// No description provided for @installment.
  ///
  /// In ar, this message translates to:
  /// **'الدفعات'**
  String get installment;

  /// No description provided for @ejarNote.
  ///
  /// In ar, this message translates to:
  /// **'بعد التأكيد يتسجل العقد في إيجار ويوصل المستأجر رابط التوثيق.'**
  String get ejarNote;

  /// No description provided for @createLease.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء العقد'**
  String get createLease;

  /// No description provided for @leaseCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء العقد وتأجير الوحدة'**
  String get leaseCreated;

  /// No description provided for @city.
  ///
  /// In ar, this message translates to:
  /// **'المدينة'**
  String get city;

  /// No description provided for @riyadh.
  ///
  /// In ar, this message translates to:
  /// **'الرياض'**
  String get riyadh;

  /// No description provided for @vatNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الضريبي'**
  String get vatNumber;

  /// No description provided for @builtWith.
  ///
  /// In ar, this message translates to:
  /// **'مبني بـ Flutter · Android و iOS والويب'**
  String get builtWith;

  /// No description provided for @frameTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الإيجارات بشكل يليق بعقارك'**
  String get frameTitle;

  /// No description provided for @frameSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق للمستأجر والمالك في نفس الوقت: دفع الإيجار، الصيانة، العقود والتحصيل، بواجهة حية تبيّن حالة كل وحدة.'**
  String get frameSubtitle;

  /// No description provided for @featureFacade.
  ///
  /// In ar, this message translates to:
  /// **'واجهة حية: كل شباك وحدة ولونه حالة الإيجار'**
  String get featureFacade;

  /// No description provided for @featureKeyCard.
  ///
  /// In ar, this message translates to:
  /// **'كارت مفتاح رقمي للمستأجر بيتقلب ويبيّن العقد'**
  String get featureKeyCard;

  /// No description provided for @featurePayments.
  ///
  /// In ar, this message translates to:
  /// **'دفع بمدى و Apple Pay و STC Pay مع إيصالات فورية'**
  String get featurePayments;

  /// No description provided for @featureMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'طلبات صيانة بخط زمني ولوحة سحب وإفلات للمالك'**
  String get featureMaintenance;

  /// No description provided for @featureBilingual.
  ///
  /// In ar, this message translates to:
  /// **'عربي وإنجليزي، ليلي ونهاري'**
  String get featureBilingual;

  /// No description provided for @frameTryIt.
  ///
  /// In ar, this message translates to:
  /// **'جرّب الآن'**
  String get frameTryIt;

  /// No description provided for @downloadApk.
  ///
  /// In ar, this message translates to:
  /// **'حمّل نسخة أندرويد'**
  String get downloadApk;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
