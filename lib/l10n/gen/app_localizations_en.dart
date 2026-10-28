// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Miftah';

  @override
  String get welcomeEyebrow => 'RENTAL PROPERTY MANAGEMENT';

  @override
  String get welcomeTitle => 'Your whole building on one screen';

  @override
  String get welcomeSubtitle =>
      'Tenants pay rent and request maintenance from their phone. Owners follow collections and units as they happen.';

  @override
  String get roleTenant => 'I\'m a tenant';

  @override
  String get roleTenantDesc => 'Pay rent, view your lease, request repairs';

  @override
  String get roleOwner => 'I\'m an owner or agency';

  @override
  String get roleOwnerDesc => 'Live facade, collections, maintenance, reports';

  @override
  String get demoNote => 'Demo with realistic sample data from Riyadh';

  @override
  String get navHome => 'Home';

  @override
  String get navPayments => 'Payments';

  @override
  String get navMaintenance => 'Maintenance';

  @override
  String get navLease => 'Lease';

  @override
  String get navFacade => 'Facade';

  @override
  String get navProperties => 'Properties';

  @override
  String get navCollections => 'Collections';

  @override
  String get navReports => 'Reports';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusDueSoon => 'Due soon';

  @override
  String get statusLate => 'Late';

  @override
  String get statusVacant => 'Vacant';

  @override
  String get statusUnpaid => 'Due';

  @override
  String get kindApartment => 'Apartment';

  @override
  String get kindVilla => 'Villa';

  @override
  String get kindShop => 'Shop';

  @override
  String get kindOffice => 'Office';

  @override
  String get freqAnnual => 'Annual';

  @override
  String get freqSemiAnnual => 'Semi-annual';

  @override
  String get freqQuarterly => 'Quarterly';

  @override
  String get freqMonthly => 'Monthly';

  @override
  String get methodMada => 'mada card';

  @override
  String get methodBank => 'Bank transfer';

  @override
  String get methodCash => 'Cash';

  @override
  String get catAc => 'Air conditioning';

  @override
  String get catPlumbing => 'Plumbing';

  @override
  String get catElectrical => 'Electrical';

  @override
  String get catAppliances => 'Appliances';

  @override
  String get catOther => 'General repair';

  @override
  String get tsOpen => 'Received';

  @override
  String get tsAssigned => 'Technician assigned';

  @override
  String get tsInProgress => 'In progress';

  @override
  String get tsDone => 'Completed';

  @override
  String get slotMorning => 'Morning';

  @override
  String get slotAfternoon => 'Afternoon';

  @override
  String get slotEvening => 'Evening';

  @override
  String goodMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String goodEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get tapCardHint => 'Tap the card to see your lease';

  @override
  String get payRent => 'Pay rent';

  @override
  String get payNowLate => 'Pay now, this payment is late';

  @override
  String get noOpenRequests => 'No open requests';

  @override
  String get allGood => 'Tap to request a repair';

  @override
  String paidOfTotal(int paid, int total) {
    return '$paid of $total';
  }

  @override
  String get installmentsThisLease => 'payments made';

  @override
  String get myHome => 'My home';

  @override
  String bedrooms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bedrooms',
      one: '1 bedroom',
    );
    return '$_temp0';
  }

  @override
  String areaSqm(int n) {
    return '$n m²';
  }

  @override
  String floorN(int n) {
    return 'Floor $n';
  }

  @override
  String get quickActions => 'Quick actions';

  @override
  String get newRequest => 'New maintenance request';

  @override
  String get myLease => 'My lease';

  @override
  String get contactOwner => 'Contact the owner';

  @override
  String get contactOwnerBody =>
      'The property office replies during working hours.';

  @override
  String get officeName => 'Office';

  @override
  String get officeNameValue => 'Al Ofoq Properties';

  @override
  String get officeLicense => 'FAL license 1200012345';

  @override
  String get phone => 'Phone';

  @override
  String get workingHours => 'Working hours';

  @override
  String get workingHoursValue => 'Sun to Thu, 9 am – 6 pm';

  @override
  String get done => 'Done';

  @override
  String get allPaid => 'All payments made';

  @override
  String get nextInstallment => 'Next payment';

  @override
  String get lateShort => 'late';

  @override
  String get daysShort => 'days';

  @override
  String leaseEnds(String date) {
    return 'Lease ends $date';
  }

  @override
  String wasDue(String date) {
    return 'Was due $date';
  }

  @override
  String dueOn(String date) {
    return 'Due $date';
  }

  @override
  String get leaseDetails => 'Lease details';

  @override
  String get unit => 'Unit';

  @override
  String get leasePeriod => 'Lease period';

  @override
  String get annualRent => 'Annual rent';

  @override
  String get paymentPlan => 'Payment plan';

  @override
  String get paySubtitle => 'Pay securely and get your receipt instantly.';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String installmentN(int n) {
    return 'Payment $n';
  }

  @override
  String get rent => 'Rent';

  @override
  String get vat => 'VAT';

  @override
  String get vatExempt => 'Exempt (residential)';

  @override
  String get vat15 => '15%';

  @override
  String get payWith => 'Pay with';

  @override
  String get applePayNote => 'Confirm with Face ID or Touch ID on your device.';

  @override
  String stcPayNote(String phone) {
    return 'A payment request will be sent to the STC Pay wallet on $phone.';
  }

  @override
  String get bankName => 'Bank';

  @override
  String get bankNameValue => 'Al Rajhi Bank';

  @override
  String get beneficiary => 'Beneficiary';

  @override
  String get bankNote =>
      'Add your unit number to the transfer note. In the demo the transfer is recorded right away.';

  @override
  String get secureNote => 'Demo only: no real money is charged.';

  @override
  String get paymentDone => 'Payment successful';

  @override
  String get paymentDoneBody =>
      'Your payment reached the owner and your history is updated.';

  @override
  String get receipt => 'Receipt';

  @override
  String get receiptBody => 'Electronic receipt issued by the property office.';

  @override
  String get receiptNo => 'Receipt no.';

  @override
  String get paidOn => 'Paid on';

  @override
  String get method => 'Method';

  @override
  String get tenant => 'Tenant';

  @override
  String get ejarContract => 'Ejar contract';

  @override
  String get installmentLabel => 'Installment';

  @override
  String installmentOf(int n, int total) {
    return 'Payment $n of $total';
  }

  @override
  String get totalPaid => 'Total';

  @override
  String get backHome => 'Back to home';

  @override
  String get copyReceipt => 'Copy receipt';

  @override
  String get copied => 'Copied';

  @override
  String get paymentsSubtitle => 'All your payments and receipts in one place.';

  @override
  String get paidThisLease => 'Paid this lease';

  @override
  String get remaining => 'Remaining';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get paidHistory => 'Paid';

  @override
  String get nothingDue => 'Nothing due right now';

  @override
  String get maintenanceSubtitle =>
      'Request a technician and follow every step.';

  @override
  String get newRequestHint => 'AC, plumbing, electrical and more';

  @override
  String get activeRequests => 'Open requests';

  @override
  String get pastRequests => 'Past requests';

  @override
  String get noPastRequests => 'No past requests';

  @override
  String get urgent => 'Urgent';

  @override
  String get stepWhat => 'What\'s the problem?';

  @override
  String get stepDescribe => 'Describe the problem';

  @override
  String get stepWhen => 'When should the technician come?';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get sendRequest => 'Send request';

  @override
  String requestSent(int n) {
    return 'Request #$n sent';
  }

  @override
  String get describeHint =>
      'e.g. The AC has been noisy and not cooling since yesterday';

  @override
  String get urgentTitle => 'This is urgent';

  @override
  String get urgentBody => 'Water leak, power cut or a safety risk';

  @override
  String visitDay(String date) {
    return 'Visit on $date';
  }

  @override
  String get category => 'Type';

  @override
  String get priority => 'Priority';

  @override
  String get normal => 'Normal';

  @override
  String get details => 'Details';

  @override
  String get presetAc1 => 'AC not cooling';

  @override
  String get presetAc2 => 'AC is very noisy';

  @override
  String get presetAc3 => 'AC is leaking water';

  @override
  String get presetPl1 => 'Leak under the sink';

  @override
  String get presetPl2 => 'Water heater not heating';

  @override
  String get presetPl3 => 'Blocked drain';

  @override
  String get presetEl1 => 'Breaker keeps tripping';

  @override
  String get presetEl2 => 'Sockets not working';

  @override
  String get presetEl3 => 'Lights not working';

  @override
  String get presetAp1 => 'Oven not working';

  @override
  String get presetAp2 => 'Garage door gets stuck';

  @override
  String get presetOt1 => 'Door lock jams';

  @override
  String get presetOt2 => 'Cracks in the wall';

  @override
  String get technician => 'Technician';

  @override
  String get change => 'Change';

  @override
  String get preferredTime => 'Preferred time';

  @override
  String get cost => 'Cost';

  @override
  String get costSar => 'Cost (SAR)';

  @override
  String get thanksRating => 'Thanks for rating';

  @override
  String get assignTechnician => 'Assign technician';

  @override
  String get assigned => 'Technician assigned and tenant notified';

  @override
  String get startWork => 'Start work';

  @override
  String get markDone => 'Mark as done';

  @override
  String get confirm => 'Confirm';

  @override
  String get ticketClosed => 'Request closed';

  @override
  String get tenantRating => 'Tenant rating';

  @override
  String get rateService => 'Rate the service';

  @override
  String get yourRating => 'Your rating';

  @override
  String get leaseSubtitle => 'Your lease is registered on Ejar.';

  @override
  String get ejarRegistered => 'Registered on Ejar';

  @override
  String daysLeftInLease(int n) {
    return '$n days left';
  }

  @override
  String get nationalId => 'National ID';

  @override
  String get property => 'Property';

  @override
  String get leaseType => 'Lease type';

  @override
  String get residential => 'Residential';

  @override
  String get commercial => 'Commercial';

  @override
  String get commercialVat => 'Commercial (+15% VAT)';

  @override
  String get securityDeposit => 'Security deposit';

  @override
  String get schedule => 'Payment schedule';

  @override
  String get renewTitle => 'Want to renew?';

  @override
  String get renewBody =>
      'Send a renewal request to the owner well before the lease ends.';

  @override
  String get requestRenewal => 'Request renewal';

  @override
  String get renewalSent => 'Renewal request sent';

  @override
  String get renewalSentBody => 'The owner will review it and get in touch.';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get switchToOwner => 'Try the owner side';

  @override
  String get switchToTenant => 'Try the tenant side';

  @override
  String get resetDemo => 'Reset demo';

  @override
  String get demoReset => 'Demo data restored';

  @override
  String get backToWelcome => 'Back to start';

  @override
  String get tenants => 'Tenants';

  @override
  String get settings => 'Settings';

  @override
  String get collectedThisMonth => 'Collected this month';

  @override
  String paymentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments',
      one: '1 payment',
    );
    return '$_temp0';
  }

  @override
  String get overdue => 'Overdue';

  @override
  String get openTickets => 'Open requests';

  @override
  String get occupancy => 'Occupancy';

  @override
  String occupancyBody(int a, int b) {
    return '$a of $b units leased';
  }

  @override
  String get liveFacade => 'Live facade';

  @override
  String get viewProperty => 'View property';

  @override
  String get needsAttention => 'Needs attention';

  @override
  String lateRent(String name) {
    return 'Late rent: $name';
  }

  @override
  String daysLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days late',
      one: '1 day late',
    );
    return '$_temp0';
  }

  @override
  String newTicket(String category) {
    return '$category request';
  }

  @override
  String leaseEnding(String name) {
    return 'Lease ending: $name';
  }

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String get overdueSince => 'Overdue since';

  @override
  String get vacantSince => 'This unit is vacant and ready to lease.';

  @override
  String get openUnit => 'Unit file';

  @override
  String get leaseIt => 'Lease it';

  @override
  String propertiesSubtitle(int p, int u) {
    return '$p properties · $u units';
  }

  @override
  String get newLease => 'New lease';

  @override
  String get units => 'Units';

  @override
  String get yearIncome => '12-month income';

  @override
  String builtIn(String year) {
    return 'Built $year';
  }

  @override
  String get all => 'All';

  @override
  String get rooms => 'Rooms';

  @override
  String get area => 'Area';

  @override
  String get unitVacantTitle => 'This unit is vacant';

  @override
  String get unitVacantBody =>
      'Add a tenant and lease in under a minute, and its window lights up on the facade.';

  @override
  String get renewal => 'Renewal';

  @override
  String get renewalRequested => 'Tenant asked to renew';

  @override
  String get maintenanceHistory => 'Maintenance history';

  @override
  String get collectionRate => 'Collection rate this month';

  @override
  String collectedOf(String a, String b) {
    return '$a of $b';
  }

  @override
  String get collected => 'Collected';

  @override
  String get dueThisMonth => 'Due this month';

  @override
  String get nothingHere => 'Nothing here';

  @override
  String get sendReminder => 'Remind';

  @override
  String get reminderSent => 'Reminded';

  @override
  String get recordCash => 'Record payment';

  @override
  String get paymentRecorded => 'Payment recorded, the window is lit';

  @override
  String viaWhatsApp(String phone) {
    return 'Via WhatsApp to $phone';
  }

  @override
  String reminderLateMsg(String name, String unit, String amount, String date) {
    return 'Hello $name, a reminder that the rent for unit $unit of $amount was due on $date. You can pay in the Miftah app. Thank you.';
  }

  @override
  String reminderSoonMsg(String name, String unit, String amount, String date) {
    return 'Hello $name, a reminder that the rent for unit $unit of $amount is due on $date. You can pay early in the Miftah app.';
  }

  @override
  String get send => 'Send';

  @override
  String reminderSentTo(String name) {
    return 'Reminder sent to $name';
  }

  @override
  String boardSubtitle(int open, String spend) {
    return '$open open · maintenance spend $spend. Drag a card to move it.';
  }

  @override
  String get dropHere => 'Drop a request here';

  @override
  String movedTo(String status) {
    return 'Moved to: $status';
  }

  @override
  String get reportsSubtitle =>
      'Your income and occupancy over the last 12 months.';

  @override
  String get allProperties => 'All properties';

  @override
  String get income12m => 'Income, last 12 months';

  @override
  String bestMonth(String month) {
    return 'Best month: $month';
  }

  @override
  String get byProperty => 'By property';

  @override
  String get occupancyByProperty => 'Occupancy by property';

  @override
  String get methodsMix => 'Payment methods';

  @override
  String tenantsSubtitle(int n) {
    return '$n tenants with active leases';
  }

  @override
  String get searchTenants => 'Search by name or unit';

  @override
  String get chooseUnit => 'Choose a unit';

  @override
  String get tenantDetails => 'Tenant details';

  @override
  String get leaseTerms => 'Lease terms';

  @override
  String vacantUnitsCount(int n) {
    return '$n vacant units';
  }

  @override
  String get fullName => 'Full name';

  @override
  String get mobile => 'Mobile number';

  @override
  String get phoneInvalid => 'A Saudi mobile starting with 5, 9 digits';

  @override
  String get nationalIdOrIqama => 'National ID or Iqama';

  @override
  String get fillSample => 'Fill with sample data';

  @override
  String get startDate => 'Start date';

  @override
  String get today => 'Today';

  @override
  String get firstOfNextMonth => '1st of next month';

  @override
  String get annualRentSar => 'Annual rent (SAR)';

  @override
  String get installment => 'Installments';

  @override
  String get ejarNote =>
      'After confirming, the lease is filed on Ejar and the tenant gets a link to sign.';

  @override
  String get createLease => 'Create lease';

  @override
  String get leaseCreated => 'Lease created and unit leased';

  @override
  String get city => 'City';

  @override
  String get riyadh => 'Riyadh';

  @override
  String get vatNumber => 'VAT number';

  @override
  String get builtWith => 'Built with Flutter · Android, iOS and web';

  @override
  String get frameTitle =>
      'Rental management that looks as good as your building';

  @override
  String get frameSubtitle =>
      'One app for tenants and owners: rent payments, maintenance, leases and collections, with a live facade that shows every unit at a glance.';

  @override
  String get featureFacade =>
      'Live facade: every window is a unit, lit by its rent status';

  @override
  String get featureKeyCard =>
      'Tenant\'s digital key card that flips to show the lease';

  @override
  String get featurePayments =>
      'Pay with mada, Apple Pay or STC Pay with instant receipts';

  @override
  String get featureMaintenance =>
      'Maintenance requests with a timeline and a drag-and-drop board';

  @override
  String get featureBilingual => 'Arabic and English, dark and light';

  @override
  String get frameTryIt => 'Try it now';

  @override
  String get downloadApk => 'Download for Android';
}
