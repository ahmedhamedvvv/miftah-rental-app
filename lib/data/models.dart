import 'package:flutter/widgets.dart';

/// A piece of text kept in both languages, for seeded names and places.
@immutable
class Bi {
  const Bi(this.ar, this.en);

  final String ar;
  final String en;

  String of(bool arabic) => arabic ? ar : en;

  Map<String, dynamic> toJson() => {'ar': ar, 'en': en};

  factory Bi.fromJson(Object? json) {
    if (json is String) return Bi(json, json);
    final m = json as Map<String, dynamic>;
    return Bi(m['ar'] as String, m['en'] as String);
  }
}

enum PropertyKind { tower, building, compound }

enum UnitKind { apartment, villa, shop, office }

enum PayFrequency { annual, semiAnnual, quarterly, monthly }

extension PayFrequencyX on PayFrequency {
  int get perYear => switch (this) {
    PayFrequency.annual => 1,
    PayFrequency.semiAnnual => 2,
    PayFrequency.quarterly => 4,
    PayFrequency.monthly => 12,
  };

  int get monthsApart => 12 ~/ perYear;
}

enum PayMethod { mada, applePay, stcPay, bankTransfer, cash }

enum TicketCategory { ac, plumbing, electrical, appliances, other }

enum TicketStatus { open, assigned, inProgress, done }

/// How a unit reads on the facade. Derived from its contract and installments.
enum UnitStatus { paid, dueSoon, late, vacant }

@immutable
class Property {
  const Property({
    required this.id,
    required this.name,
    required this.district,
    required this.city,
    required this.kind,
    required this.photo,
    required this.floors,
    required this.unitsPerFloor,
    required this.builtYear,
  });

  final String id;
  final Bi name;
  final Bi district;
  final Bi city;
  final PropertyKind kind;
  final String photo;
  final int floors;
  final int unitsPerFloor;
  final int builtYear;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name.toJson(),
    'district': district.toJson(),
    'city': city.toJson(),
    'kind': kind.name,
    'photo': photo,
    'floors': floors,
    'unitsPerFloor': unitsPerFloor,
    'builtYear': builtYear,
  };

  factory Property.fromJson(Map<String, dynamic> j) => Property(
    id: j['id'] as String,
    name: Bi.fromJson(j['name']),
    district: Bi.fromJson(j['district']),
    city: Bi.fromJson(j['city']),
    kind: PropertyKind.values.byName(j['kind'] as String),
    photo: j['photo'] as String,
    floors: j['floors'] as int,
    unitsPerFloor: j['unitsPerFloor'] as int,
    builtYear: j['builtYear'] as int,
  );
}

@immutable
class Unit {
  const Unit({
    required this.id,
    required this.propertyId,
    required this.number,
    required this.floor,
    required this.kind,
    required this.bedrooms,
    required this.area,
    required this.annualRent,
    required this.photos,
  });

  final String id;
  final String propertyId;
  final String number;
  final int floor;
  final UnitKind kind;
  final int bedrooms;
  final int area;
  final int annualRent;
  final List<String> photos;

  bool get isCommercial => kind == UnitKind.shop || kind == UnitKind.office;

  Map<String, dynamic> toJson() => {
    'id': id,
    'propertyId': propertyId,
    'number': number,
    'floor': floor,
    'kind': kind.name,
    'bedrooms': bedrooms,
    'area': area,
    'annualRent': annualRent,
    'photos': photos,
  };

  factory Unit.fromJson(Map<String, dynamic> j) => Unit(
    id: j['id'] as String,
    propertyId: j['propertyId'] as String,
    number: j['number'] as String,
    floor: j['floor'] as int,
    kind: UnitKind.values.byName(j['kind'] as String),
    bedrooms: j['bedrooms'] as int,
    area: j['area'] as int,
    annualRent: j['annualRent'] as int,
    photos: (j['photos'] as List).cast<String>(),
  );
}

@immutable
class Tenant {
  const Tenant({
    required this.id,
    required this.name,
    required this.phone,
    required this.nationalId,
  });

  final String id;
  final Bi name;
  final String phone;
  final String nationalId;

  String get maskedId =>
      '${nationalId.substring(0, 2)}******${nationalId.substring(8)}';

  String initials(bool arabic) {
    final parts = name.of(arabic).split(' ').where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p.characters.first).join(arabic ? ' ' : '');
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name.toJson(),
    'phone': phone,
    'nationalId': nationalId,
  };

  factory Tenant.fromJson(Map<String, dynamic> j) => Tenant(
    id: j['id'] as String,
    name: Bi.fromJson(j['name']),
    phone: j['phone'] as String,
    nationalId: j['nationalId'] as String,
  );
}

@immutable
class Contract {
  const Contract({
    required this.id,
    required this.unitId,
    required this.tenantId,
    required this.ejarNumber,
    required this.start,
    required this.end,
    required this.frequency,
    required this.annualRent,
    this.renewalRequested = false,
  });

  final String id;
  final String unitId;
  final String tenantId;
  final String ejarNumber;
  final DateTime start;
  final DateTime end;
  final PayFrequency frequency;
  final int annualRent;
  final bool renewalRequested;

  int get installmentAmount => annualRent ~/ frequency.perYear;

  bool isActiveOn(DateTime day) => !day.isBefore(start) && day.isBefore(end);

  Contract copyWith({bool? renewalRequested}) => Contract(
    id: id,
    unitId: unitId,
    tenantId: tenantId,
    ejarNumber: ejarNumber,
    start: start,
    end: end,
    frequency: frequency,
    annualRent: annualRent,
    renewalRequested: renewalRequested ?? this.renewalRequested,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'unitId': unitId,
    'tenantId': tenantId,
    'ejarNumber': ejarNumber,
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
    'frequency': frequency.name,
    'annualRent': annualRent,
    'renewalRequested': renewalRequested,
  };

  factory Contract.fromJson(Map<String, dynamic> j) => Contract(
    id: j['id'] as String,
    unitId: j['unitId'] as String,
    tenantId: j['tenantId'] as String,
    ejarNumber: j['ejarNumber'] as String,
    start: DateTime.parse(j['start'] as String),
    end: DateTime.parse(j['end'] as String),
    frequency: PayFrequency.values.byName(j['frequency'] as String),
    annualRent: j['annualRent'] as int,
    renewalRequested: j['renewalRequested'] as bool? ?? false,
  );
}

@immutable
class Installment {
  const Installment({
    required this.id,
    required this.contractId,
    required this.index,
    required this.due,
    required this.amount,
    this.paidAt,
    this.method,
    this.reference,
  });

  final String id;
  final String contractId;
  final int index;
  final DateTime due;
  final int amount;
  final DateTime? paidAt;
  final PayMethod? method;
  final String? reference;

  bool get isPaid => paidAt != null;

  Installment pay(DateTime at, PayMethod method, String reference) =>
      Installment(
        id: id,
        contractId: contractId,
        index: index,
        due: due,
        amount: amount,
        paidAt: at,
        method: method,
        reference: reference,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'contractId': contractId,
    'index': index,
    'due': due.toIso8601String(),
    'amount': amount,
    'paidAt': paidAt?.toIso8601String(),
    'method': method?.name,
    'reference': reference,
  };

  factory Installment.fromJson(Map<String, dynamic> j) => Installment(
    id: j['id'] as String,
    contractId: j['contractId'] as String,
    index: j['index'] as int,
    due: DateTime.parse(j['due'] as String),
    amount: j['amount'] as int,
    paidAt: j['paidAt'] == null ? null : DateTime.parse(j['paidAt'] as String),
    method: j['method'] == null
        ? null
        : PayMethod.values.byName(j['method'] as String),
    reference: j['reference'] as String?,
  );
}

@immutable
class TicketEvent {
  const TicketEvent(this.status, this.at);

  final TicketStatus status;
  final DateTime at;

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'at': at.toIso8601String(),
  };

  factory TicketEvent.fromJson(Map<String, dynamic> j) => TicketEvent(
    TicketStatus.values.byName(j['status'] as String),
    DateTime.parse(j['at'] as String),
  );
}

@immutable
class Ticket {
  const Ticket({
    required this.id,
    required this.number,
    required this.unitId,
    required this.category,
    required this.description,
    required this.preferredSlot,
    required this.events,
    this.urgent = false,
    this.technician,
    this.cost,
    this.rating,
  });

  final String id;
  final int number;
  final String unitId;
  final TicketCategory category;
  final Bi description;
  final int preferredSlot;
  final List<TicketEvent> events;
  final bool urgent;
  final String? technician;
  final int? cost;
  final int? rating;

  TicketStatus get status => events.last.status;
  DateTime get createdAt => events.first.at;
  DateTime get updatedAt => events.last.at;

  Ticket copyWith({
    List<TicketEvent>? events,
    String? technician,
    int? cost,
    int? rating,
  }) => Ticket(
    id: id,
    number: number,
    unitId: unitId,
    category: category,
    description: description,
    preferredSlot: preferredSlot,
    events: events ?? this.events,
    urgent: urgent,
    technician: technician ?? this.technician,
    cost: cost ?? this.cost,
    rating: rating ?? this.rating,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'unitId': unitId,
    'category': category.name,
    'description': description.toJson(),
    'preferredSlot': preferredSlot,
    'events': [for (final e in events) e.toJson()],
    'urgent': urgent,
    'technician': technician,
    'cost': cost,
    'rating': rating,
  };

  factory Ticket.fromJson(Map<String, dynamic> j) => Ticket(
    id: j['id'] as String,
    number: j['number'] as int,
    unitId: j['unitId'] as String,
    category: TicketCategory.values.byName(j['category'] as String),
    description: Bi.fromJson(j['description']),
    preferredSlot: j['preferredSlot'] as int,
    events: [
      for (final e in j['events'] as List)
        TicketEvent.fromJson(e as Map<String, dynamic>),
    ],
    urgent: j['urgent'] as bool? ?? false,
    technician: j['technician'] as String?,
    cost: j['cost'] as int?,
    rating: j['rating'] as int?,
  );
}

enum NoticeKind { payment, maintenance, contract, reminder }

@immutable
class Notice {
  const Notice({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.at,
    this.read = false,
  });

  final String id;
  final NoticeKind kind;
  final Bi title;
  final Bi body;
  final DateTime at;
  final bool read;

  Notice markRead() =>
      Notice(id: id, kind: kind, title: title, body: body, at: at, read: true);

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title.toJson(),
    'body': body.toJson(),
    'at': at.toIso8601String(),
    'read': read,
  };

  factory Notice.fromJson(Map<String, dynamic> j) => Notice(
    id: j['id'] as String,
    kind: NoticeKind.values.byName(j['kind'] as String),
    title: Bi.fromJson(j['title']),
    body: Bi.fromJson(j['body']),
    at: DateTime.parse(j['at'] as String),
    read: j['read'] as bool? ?? false,
  );
}

/// Everything the demo knows, saved as one JSON document.
@immutable
class Portfolio {
  const Portfolio({
    required this.properties,
    required this.units,
    required this.tenants,
    required this.contracts,
    required this.installments,
    required this.tickets,
    required this.notices,
    required this.meTenantId,
  });

  final List<Property> properties;
  final List<Unit> units;
  final List<Tenant> tenants;
  final List<Contract> contracts;
  final List<Installment> installments;
  final List<Ticket> tickets;
  final List<Notice> notices;

  /// The tenant the demo signs in as on the tenant side.
  final String meTenantId;

  Portfolio copyWith({
    List<Unit>? units,
    List<Tenant>? tenants,
    List<Contract>? contracts,
    List<Installment>? installments,
    List<Ticket>? tickets,
    List<Notice>? notices,
  }) => Portfolio(
    properties: properties,
    units: units ?? this.units,
    tenants: tenants ?? this.tenants,
    contracts: contracts ?? this.contracts,
    installments: installments ?? this.installments,
    tickets: tickets ?? this.tickets,
    notices: notices ?? this.notices,
    meTenantId: meTenantId,
  );

  Map<String, dynamic> toJson() => {
    'properties': [for (final x in properties) x.toJson()],
    'units': [for (final x in units) x.toJson()],
    'tenants': [for (final x in tenants) x.toJson()],
    'contracts': [for (final x in contracts) x.toJson()],
    'installments': [for (final x in installments) x.toJson()],
    'tickets': [for (final x in tickets) x.toJson()],
    'notices': [for (final x in notices) x.toJson()],
    'meTenantId': meTenantId,
  };

  factory Portfolio.fromJson(Map<String, dynamic> j) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) f) => [
      for (final x in j[key] as List) f(x as Map<String, dynamic>),
    ];
    return Portfolio(
      properties: list('properties', Property.fromJson),
      units: list('units', Unit.fromJson),
      tenants: list('tenants', Tenant.fromJson),
      contracts: list('contracts', Contract.fromJson),
      installments: list('installments', Installment.fromJson),
      tickets: list('tickets', Ticket.fromJson),
      notices: list('notices', Notice.fromJson),
      meTenantId: j['meTenantId'] as String,
    );
  }
}
