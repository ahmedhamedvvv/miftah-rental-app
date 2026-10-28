# مِفتاح · Miftah

**إدارة إيجارات للمستأجر والمالك في تطبيق واحد.** المستأجر يشوف عقده كبطاقة مفتاح، يدفع الإيجار، ويطلب صيانة ويتابعها. والمالك يشوف عقاراته كواجهة مبنى حية: كل شباك وحدة ولونه حسب حالة الإيجار.

A rental management app for Saudi tenants and landlords, Arabic first with full English support.

- **Live demo:** https://ahmedhamedvvv.github.io/miftah-rental-app/
- **Android APK:** https://github.com/ahmedhamedvvv/miftah-rental-app/releases/tag/demo

## What's inside

**Tenant**
- Lease as a flipping key card with a countdown ring to the next installment
- Pay rent (mada, Apple Pay, STC Pay, bank transfer) with a receipt that matches Ejar data; 15% VAT only on commercial units
- Maintenance requests in three steps, with a live status timeline, technician details and rating
- Payment schedule, history and notifications

**Owner**
- Live facade: every window is a unit, coloured paid / due soon / late / vacant
- Collections with one-tap WhatsApp reminders and cash recording
- Drag-and-drop maintenance board
- 12-month income reports per property, payment method mix
- Tenants directory and a new-lease wizard for vacant units

Dark mode by default with a full light theme, RTL/LTR, and all data saved on the device.

## Built with

Flutter 3.47 · Riverpod 3 · go_router · flutter_animate · fl_chart · intl (ARB) · shared_preferences

```
lib/
  app/        router, app shell, web device frame
  core/       theme, formatting, shared widgets (facade, key card, photo)
  data/       models and the seeded demo portfolio
  domain/     ledger: dues, statuses, occupancy, income
  features/   tenant, owner, shared screens
  state/      providers and the persisted store
tool/         string generator and photo fetcher
```

Run it: `flutter pub get && flutter run`. Tests: `flutter test`.

## Photos

All photos are real and come from [Pexels](https://www.pexels.com) under the Pexels License. CI downloads them with `tool/fetch_photos.py`.

| File | Subject | Source |
|---|---|---|
| `buildings/night.jpg` | Apartment building at night | [pexels.com/photo/14195688](https://www.pexels.com/photo/14195688/) |
| `buildings/malqa.jpg` | Modern building in Saudi Arabia | [pexels.com/photo/15839821](https://www.pexels.com/photo/15839821/) |
| `buildings/narjis.jpg` | Urban apartment building with balconies | [pexels.com/photo/32326246](https://www.pexels.com/photo/32326246/) |
| `buildings/yasmin.jpg` | Villa with a swimming pool in the evening | [pexels.com/photo/26859048](https://www.pexels.com/photo/26859048/) |
| `buildings/tower2.jpg` | Modern apartment building on sky background | [pexels.com/photo/11701050](https://www.pexels.com/photo/11701050/) |
| `buildings/facade.jpg` | Modern apartment building facade in daylight | [pexels.com/photo/30271883](https://www.pexels.com/photo/30271883/) |
| `interiors/living1.jpg` | Modern apartment living room | [pexels.com/photo/6588599](https://www.pexels.com/photo/6588599/) |
| `interiors/living2.jpg` | Modern apartment with furniture | [pexels.com/photo/6527029](https://www.pexels.com/photo/6527029/) |
| `interiors/studio.jpg` | Minimalist studio apartment | [pexels.com/photo/7060814](https://www.pexels.com/photo/7060814/) |
| `interiors/cozy.jpg` | Cozy living room | [pexels.com/photo/6312353](https://www.pexels.com/photo/6312353/) |
| `interiors/bedroom1.jpg` | Bedroom in modern apartment | [pexels.com/photo/6636262](https://www.pexels.com/photo/6636262/) |
| `interiors/bedroom2.jpg` | Bedroom with glass wall | [pexels.com/photo/6492385](https://www.pexels.com/photo/6492385/) |
| `interiors/kitchen1.jpg` | Modern white kitchen | [pexels.com/photo/10099335](https://www.pexels.com/photo/10099335/) |
| `interiors/kitchen2.jpg` | Kitchen with modern furniture | [pexels.com/photo/6301168](https://www.pexels.com/photo/6301168/) |
| `maintenance/ac.jpg` | Technician fixing an air conditioner | [pexels.com/photo/5463582](https://www.pexels.com/photo/5463582/) |
| `maintenance/plumbing.jpg` | Plumber installing pipe fittings | [pexels.com/photo/6419128](https://www.pexels.com/photo/6419128/) |
| `maintenance/electrical.jpg` | Technician at an electrical panel | [pexels.com/photo/33694019](https://www.pexels.com/photo/33694019/) |
| `maintenance/general.jpg` | Man using a spanner | [pexels.com/photo/16509869](https://www.pexels.com/photo/16509869/) |
