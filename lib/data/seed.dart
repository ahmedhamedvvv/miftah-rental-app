import 'dart:math';

import 'models.dart';

/// Maintenance technicians the owner can assign. Kept as constants so tickets
/// only store an id.
const technicians = <String, Bi>{
  'tech_ac': Bi('ياسر القحطاني · تكييف', 'Yasser Al-Qahtani · AC'),
  'tech_plumb': Bi('سعيد الغامدي · سباكة', 'Saeed Al-Ghamdi · Plumbing'),
  'tech_elec': Bi('ماجد الحربي · كهرباء', 'Majed Al-Harbi · Electrical'),
  'tech_gen': Bi('عمر الدوسري · صيانة عامة', 'Omar Al-Dosari · General'),
};

const _interiors = [
  'interiors/living1.jpg',
  'interiors/living2.jpg',
  'interiors/studio.jpg',
  'interiors/cozy.jpg',
  'interiors/bedroom1.jpg',
  'interiors/bedroom2.jpg',
  'interiors/kitchen1.jpg',
  'interiors/kitchen2.jpg',
];

const _first = [
  Bi('محمد', 'Mohammed'),
  Bi('عبدالرحمن', 'Abdulrahman'),
  Bi('فهد', 'Fahad'),
  Bi('خالد', 'Khalid'),
  Bi('سلطان', 'Sultan'),
  Bi('نورة', 'Noura'),
  Bi('سارة', 'Sarah'),
  Bi('ريم', 'Reem'),
  Bi('تركي', 'Turki'),
  Bi('بندر', 'Bandar'),
  Bi('هيفاء', 'Haifa'),
  Bi('أحمد', 'Ahmed'),
  Bi('ناصر', 'Nasser'),
  Bi('لمى', 'Lama'),
  Bi('فيصل', 'Faisal'),
  Bi('منيرة', 'Munira'),
  Bi('عبدالعزيز', 'Abdulaziz'),
  Bi('دانة', 'Dana'),
  Bi('مشاري', 'Mishari'),
  Bi('جواهر', 'Jawaher'),
  Bi('يوسف', 'Yousef'),
  Bi('راكان', 'Rakan'),
  Bi('العنود', 'Alanoud'),
  Bi('سعود', 'Saud'),
];

const _last = [
  Bi('العتيبي', 'Al-Otaibi'),
  Bi('القحطاني', 'Al-Qahtani'),
  Bi('الدوسري', 'Al-Dosari'),
  Bi('الشمري', 'Al-Shammari'),
  Bi('الزهراني', 'Al-Zahrani'),
  Bi('الغامدي', 'Al-Ghamdi'),
  Bi('المطيري', 'Al-Mutairi'),
  Bi('الحربي', 'Al-Harbi'),
  Bi('السبيعي', 'Al-Subaie'),
  Bi('العنزي', 'Al-Anazi'),
  Bi('الرشيد', 'Al-Rasheed'),
  Bi('السديري', 'Al-Sudairi'),
  Bi('الجهني', 'Al-Juhani'),
  Bi('البقمي', 'Al-Buqami'),
];

/// Builds the demo portfolio relative to [today], so dates always look
/// current. The same [today] always gives the same data.
Portfolio buildSeed(DateTime today) {
  final day = DateTime(today.year, today.month, today.day);
  final rnd = Random(20261028);

  final properties = <Property>[
    const Property(
      id: 'p_malqa',
      name: Bi('برج الملقا', 'Al Malqa Tower'),
      district: Bi('حي الملقا', 'Al Malqa'),
      city: Bi('الرياض', 'Riyadh'),
      kind: PropertyKind.tower,
      photo: 'buildings/tower2.jpg',
      floors: 10,
      unitsPerFloor: 4,
      builtYear: 2022,
    ),
    const Property(
      id: 'p_narjis',
      name: Bi('عمارة النرجس', 'Al Narjis Residence'),
      district: Bi('حي النرجس', 'Al Narjis'),
      city: Bi('الرياض', 'Riyadh'),
      kind: PropertyKind.building,
      photo: 'buildings/narjis.jpg',
      floors: 6,
      unitsPerFloor: 4,
      builtYear: 2019,
    ),
    const Property(
      id: 'p_yasmin',
      name: Bi('فلل الياسمين', 'Al Yasmin Villas'),
      district: Bi('حي الياسمين', 'Al Yasmin'),
      city: Bi('الرياض', 'Riyadh'),
      kind: PropertyKind.compound,
      photo: 'buildings/yasmin.jpg',
      floors: 2,
      unitsPerFloor: 4,
      builtYear: 2020,
    ),
  ];

  // Units.
  final units = <Unit>[];
  List<String> photos(int seed) => [
    for (var k = 0; k < 3; k++) _interiors[(seed + k * 3) % _interiors.length],
  ];
  for (final p in properties) {
    for (var f = 1; f <= p.floors; f++) {
      for (var n = 1; n <= p.unitsPerFloor; n++) {
        final i = units.length;
        late UnitKind kind;
        late int beds, area, rent;
        if (p.kind == PropertyKind.compound) {
          kind = UnitKind.villa;
          beds = 4 + rnd.nextInt(2);
          area = 320 + rnd.nextInt(8) * 20;
          rent = 115000 + rnd.nextInt(6) * 9000;
        } else if (p.kind == PropertyKind.tower && f == 1) {
          kind = n.isEven ? UnitKind.office : UnitKind.shop;
          beds = 0;
          area = 90 + rnd.nextInt(5) * 15;
          rent = 70000 + rnd.nextInt(5) * 5000;
        } else {
          kind = UnitKind.apartment;
          beds = n == 1 || n == 4 ? 3 : 2;
          area = beds == 3
              ? 150 + rnd.nextInt(4) * 10
              : 110 + rnd.nextInt(4) * 8;
          final base = p.kind == PropertyKind.tower ? 38000 : 30000;
          rent = base + (beds - 2) * 9000 + f * 500 + rnd.nextInt(4) * 1000;
        }
        final number = p.kind == PropertyKind.compound
            ? 'V${(f - 1) * p.unitsPerFloor + n}'
            : '$f${n.toString().padLeft(2, '0')}';
        units.add(
          Unit(
            id: '${p.id}_$number',
            propertyId: p.id,
            number: number,
            floor: f,
            kind: kind,
            bedrooms: beds,
            area: area,
            annualRent: rent - rent % 500,
            photos: photos(i),
          ),
        );
      }
    }
  }

  // Which units are empty. Fixed so the facade always tells the same story.
  const vacant = {
    'p_malqa_302',
    'p_malqa_604',
    'p_malqa_1001',
    'p_malqa_103',
    'p_narjis_203',
    'p_narjis_502',
    'p_yasmin_V6',
  };
  // Units whose tenant has an overdue installment.
  const lateUnits = {
    'p_malqa_501',
    'p_malqa_902',
    'p_malqa_104',
    'p_narjis_104',
    'p_narjis_401',
    'p_yasmin_V3',
  };
  const meUnit = 'p_malqa_803';

  final tenants = <Tenant>[];
  final contracts = <Contract>[];
  final installments = <Installment>[];
  var ejar = 10283;

  String phone() {
    final b = StringBuffer('+9665');
    for (var k = 0; k < 8; k++) {
      b.write(rnd.nextInt(10));
    }
    return b.toString();
  }

  String nationalId() {
    final b = StringBuffer(rnd.nextInt(3) == 0 ? '2' : '1');
    for (var k = 0; k < 9; k++) {
      b.write(rnd.nextInt(10));
    }
    return b.toString();
  }

  DateTime addMonths(DateTime d, int m) => DateTime(d.year, d.month + m, d.day);

  void addContract({
    required Unit unit,
    required Tenant tenant,
    required DateTime start,
    required PayFrequency freq,
    required int rent,
    required bool leaveLate,
  }) {
    final id = 'c_${contracts.length + 1}';
    final end = addMonths(start, 12);
    contracts.add(
      Contract(
        id: id,
        unitId: unit.id,
        tenantId: tenant.id,
        ejarNumber: '2025${(ejar++).toString().padLeft(7, '0')}',
        start: start,
        end: end,
        frequency: freq,
        annualRent: rent,
      ),
    );
    final dues = [
      for (var k = 0; k < freq.perYear; k++)
        addMonths(start, k * freq.monthsApart),
    ];
    // The most recent past due date stays unpaid for a late tenant.
    final lateIndex = leaveLate
        ? dues.lastIndexWhere((d) => d.isBefore(day))
        : -1;
    for (var k = 0; k < dues.length; k++) {
      final due = dues[k];
      final paid = due.isBefore(day) && k != lateIndex;
      final paidAt = due.subtract(Duration(days: rnd.nextInt(4)));
      final method = PayMethod.values[rnd.nextInt(PayMethod.values.length)];
      installments.add(
        Installment(
          id: '${id}_$k',
          contractId: id,
          index: k,
          due: due,
          amount: rent ~/ freq.perYear,
          paidAt: paid ? (paidAt.isAfter(day) ? day : paidAt) : null,
          method: paid ? method : null,
          reference: paid ? 'MF${100000 + rnd.nextInt(899999)}' : null,
        ),
      );
    }
  }

  PayFrequency pickFrequency(Unit u) {
    final r = rnd.nextInt(100);
    if (u.kind == UnitKind.villa) {
      return r < 55 ? PayFrequency.annual : PayFrequency.semiAnnual;
    }
    if (r < 40) return PayFrequency.semiAnnual;
    if (r < 65) return PayFrequency.quarterly;
    if (r < 85) return PayFrequency.annual;
    return PayFrequency.monthly;
  }

  for (final u in units) {
    if (vacant.contains(u.id)) continue;
    final Tenant t;
    if (u.id == meUnit) {
      t = const Tenant(
        id: 't_me',
        name: Bi('عبدالله الشهري', 'Abdullah Al-Shehri'),
        phone: '+966551234567',
        nationalId: '1087345521',
      );
    } else {
      final f = _first[rnd.nextInt(_first.length)];
      final l = _last[rnd.nextInt(_last.length)];
      t = Tenant(
        id: 't_${tenants.length + 1}',
        name: Bi('${f.ar} ${l.ar}', '${f.en} ${l.en}'),
        phone: phone(),
        nationalId: nationalId(),
      );
    }
    tenants.add(t);

    final freq = u.id == meUnit ? PayFrequency.semiAnnual : pickFrequency(u);
    final DateTime start;
    if (u.id == meUnit) {
      // Next installment lands 34 days from today.
      start = addMonths(day.add(const Duration(days: 34)), -6);
    } else if (lateUnits.contains(u.id)) {
      start = DateTime(day.year, day.month - (2 + rnd.nextInt(8)), 1);
    } else {
      start = DateTime(
        day.year,
        day.month - rnd.nextInt(11),
        1 + rnd.nextInt(3) * 7,
      );
    }

    // The year before, so reports have a full year of history.
    addContract(
      unit: u,
      tenant: t,
      start: addMonths(start, -12),
      freq: freq,
      rent: u.annualRent - 1500,
      leaveLate: false,
    );
    addContract(
      unit: u,
      tenant: t,
      start: start,
      freq: freq,
      rent: u.annualRent,
      leaveLate: lateUnits.contains(u.id),
    );
  }

  // Previous contracts are history only; drop their unpaid tail if any.
  installments.removeWhere(
    (i) =>
        i.paidAt == null &&
        i.due.isBefore(day) &&
        !_isCurrent(contracts, i, day),
  );

  DateTime ago(int days, [int hour = 10]) =>
      day.subtract(Duration(days: days)).add(Duration(hours: hour));

  final tickets = <Ticket>[
    Ticket(
      id: 'k_1',
      number: 1042,
      unitId: meUnit,
      category: TicketCategory.ac,
      description: const Bi(
        'مكيف غرفة النوم الرئيسية ما يبرد ويطلع صوت عالي.',
        'The master bedroom AC is not cooling and makes a loud noise.',
      ),
      preferredSlot: 1,
      events: [
        TicketEvent(TicketStatus.open, ago(2, 9)),
        TicketEvent(TicketStatus.assigned, ago(2, 13)),
        TicketEvent(TicketStatus.inProgress, ago(0, 8)),
      ],
      technician: 'tech_ac',
    ),
    Ticket(
      id: 'k_2',
      number: 1038,
      unitId: meUnit,
      category: TicketCategory.plumbing,
      description: const Bi(
        'تسريب بسيط تحت مغسلة المطبخ.',
        'Small leak under the kitchen sink.',
      ),
      preferredSlot: 0,
      events: [
        TicketEvent(TicketStatus.open, ago(26, 11)),
        TicketEvent(TicketStatus.assigned, ago(26, 15)),
        TicketEvent(TicketStatus.inProgress, ago(25, 10)),
        TicketEvent(TicketStatus.done, ago(25, 12)),
      ],
      technician: 'tech_plumb',
      cost: 180,
      rating: 5,
    ),
    Ticket(
      id: 'k_3',
      number: 1044,
      unitId: 'p_narjis_303',
      category: TicketCategory.electrical,
      description: const Bi(
        'الكهرباء تفصل في الصالة كل ما نشغل الفرن.',
        'Power trips in the living room whenever the oven is on.',
      ),
      preferredSlot: 2,
      urgent: true,
      events: [TicketEvent(TicketStatus.open, ago(0, 7))],
    ),
    Ticket(
      id: 'k_4',
      number: 1043,
      unitId: 'p_malqa_402',
      category: TicketCategory.plumbing,
      description: const Bi(
        'سخان الحمام ما يسخن.',
        'The bathroom water heater is not heating.',
      ),
      preferredSlot: 0,
      events: [TicketEvent(TicketStatus.open, ago(1, 18))],
    ),
    Ticket(
      id: 'k_5',
      number: 1040,
      unitId: 'p_yasmin_V2',
      category: TicketCategory.appliances,
      description: const Bi(
        'باب الكراج الكهربائي يعلق في النص.',
        'The electric garage door gets stuck halfway.',
      ),
      preferredSlot: 1,
      events: [
        TicketEvent(TicketStatus.open, ago(4, 10)),
        TicketEvent(TicketStatus.assigned, ago(3, 9)),
      ],
      technician: 'tech_gen',
    ),
    Ticket(
      id: 'k_6',
      number: 1039,
      unitId: 'p_malqa_701',
      category: TicketCategory.ac,
      description: const Bi(
        'تنظيف وصيانة دورية للمكيفات قبل الصيف.',
        'Routine AC cleaning before summer.',
      ),
      preferredSlot: 0,
      events: [
        TicketEvent(TicketStatus.open, ago(12, 10)),
        TicketEvent(TicketStatus.assigned, ago(12, 12)),
        TicketEvent(TicketStatus.inProgress, ago(10, 9)),
        TicketEvent(TicketStatus.done, ago(10, 14)),
      ],
      technician: 'tech_ac',
      cost: 350,
      rating: 4,
    ),
    Ticket(
      id: 'k_7',
      number: 1041,
      unitId: 'p_narjis_602',
      category: TicketCategory.other,
      description: const Bi(
        'قفل باب الشقة الرئيسي صار يعلق.',
        'The main door lock keeps jamming.',
      ),
      preferredSlot: 2,
      events: [
        TicketEvent(TicketStatus.open, ago(3, 16)),
        TicketEvent(TicketStatus.assigned, ago(3, 18)),
        TicketEvent(TicketStatus.inProgress, ago(1, 11)),
      ],
      technician: 'tech_gen',
    ),
  ];

  final notices = <Notice>[
    Notice(
      id: 'n_1',
      kind: NoticeKind.maintenance,
      title: const Bi('الفني في الطريق', 'Technician on the way'),
      body: const Bi(
        'ياسر القحطاني بدأ العمل على طلب التكييف #1042.',
        'Yasser Al-Qahtani started work on AC request #1042.',
      ),
      at: ago(0, 8),
    ),
    Notice(
      id: 'n_2',
      kind: NoticeKind.reminder,
      title: const Bi(
        'دفعتك الجاية بعد 34 يوم',
        'Your next rent is due in 34 days',
      ),
      body: const Bi(
        'ادفع مبكر من التطبيق وتجنب أي تأخير.',
        'Pay early from the app and avoid any delay.',
      ),
      at: ago(1, 9),
    ),
    Notice(
      id: 'n_3',
      kind: NoticeKind.maintenance,
      title: const Bi('تم تعيين فني', 'Technician assigned'),
      body: const Bi(
        'تم تعيين ياسر القحطاني لطلب التكييف #1042.',
        'Yasser Al-Qahtani was assigned to AC request #1042.',
      ),
      at: ago(2, 13),
      read: true,
    ),
    Notice(
      id: 'n_4',
      kind: NoticeKind.maintenance,
      title: const Bi('تم إنجاز طلبك', 'Request completed'),
      body: const Bi(
        'تم إصلاح تسريب المطبخ #1038. شكراً لتقييمك.',
        'Kitchen leak #1038 is fixed. Thanks for rating.',
      ),
      at: ago(25, 12),
      read: true,
    ),
    Notice(
      id: 'n_5',
      kind: NoticeKind.contract,
      title: const Bi(
        'عقدك موثّق في إيجار',
        'Your lease is registered on Ejar',
      ),
      body: const Bi(
        'تقدر تشوف تفاصيل العقد وجدول الدفعات من تبويب العقد.',
        'See the lease and the payment schedule in the Lease tab.',
      ),
      at: ago(150, 10),
      read: true,
    ),
  ];

  return Portfolio(
    properties: properties,
    units: units,
    tenants: tenants,
    contracts: contracts,
    installments: installments,
    tickets: tickets,
    notices: notices,
    meTenantId: 't_me',
  );
}

bool _isCurrent(List<Contract> contracts, Installment i, DateTime day) {
  final c = contracts.firstWhere((c) => c.id == i.contractId);
  return c.isActiveOn(day);
}
