import 'package:flutter/material.dart';

import '../data/models.dart';
import '../l10n/gen/app_localizations.dart';

/// Display names and icons for the model enums.
String unitKindLabel(AppLocalizations l, UnitKind k) => switch (k) {
  UnitKind.apartment => l.kindApartment,
  UnitKind.villa => l.kindVilla,
  UnitKind.shop => l.kindShop,
  UnitKind.office => l.kindOffice,
};

String frequencyLabel(AppLocalizations l, PayFrequency f) => switch (f) {
  PayFrequency.annual => l.freqAnnual,
  PayFrequency.semiAnnual => l.freqSemiAnnual,
  PayFrequency.quarterly => l.freqQuarterly,
  PayFrequency.monthly => l.freqMonthly,
};

String methodLabel(AppLocalizations l, PayMethod m) => switch (m) {
  PayMethod.mada => l.methodMada,
  PayMethod.applePay => 'Apple Pay',
  PayMethod.stcPay => 'STC Pay',
  PayMethod.bankTransfer => l.methodBank,
  PayMethod.cash => l.methodCash,
};

String ticketCategoryLabel(AppLocalizations l, TicketCategory c) => switch (c) {
  TicketCategory.ac => l.catAc,
  TicketCategory.plumbing => l.catPlumbing,
  TicketCategory.electrical => l.catElectrical,
  TicketCategory.appliances => l.catAppliances,
  TicketCategory.other => l.catOther,
};

IconData ticketCategoryIcon(TicketCategory c) => switch (c) {
  TicketCategory.ac => Icons.ac_unit_rounded,
  TicketCategory.plumbing => Icons.plumbing_rounded,
  TicketCategory.electrical => Icons.electrical_services_rounded,
  TicketCategory.appliances => Icons.kitchen_rounded,
  TicketCategory.other => Icons.handyman_rounded,
};

String ticketCategoryPhoto(TicketCategory c) => switch (c) {
  TicketCategory.ac => 'maintenance/ac.jpg',
  TicketCategory.plumbing => 'maintenance/plumbing.jpg',
  TicketCategory.electrical => 'maintenance/electrical.jpg',
  TicketCategory.appliances => 'interiors/kitchen1.jpg',
  TicketCategory.other => 'maintenance/general.jpg',
};

String ticketStatusLabel(AppLocalizations l, TicketStatus s) => switch (s) {
  TicketStatus.open => l.tsOpen,
  TicketStatus.assigned => l.tsAssigned,
  TicketStatus.inProgress => l.tsInProgress,
  TicketStatus.done => l.tsDone,
};

String slotLabel(AppLocalizations l, int slot) => switch (slot) {
  0 => l.slotMorning,
  1 => l.slotAfternoon,
  _ => l.slotEvening,
};
