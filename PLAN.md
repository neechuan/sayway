# AAC App MVP — "SayWay" 🗣️
> *Augmentative & Alternative Communication for everyone*

A cross-platform AAC mobile app that bridges the gap between expensive clinical tools (Proloquo2Go) and gamified entry-level apps (Otsimo), delivering professional-grade communication at an accessible price point.

---

## 1. Competitive Analysis

### Proloquo2Go — Strengths
| Strength | Why It Matters |
|---|---|
| **Crescendo™ Core Vocabulary** | Consistent motor-planning so users build muscle memory for word locations |
| **23 Grid Sizes** (9–144 buttons) | Scales from beginner to advanced communicators |
| **100+ TTS Voices** incl. children's voices | Natural-sounding, age-appropriate speech output |
| **Bilingual mid-sentence switching** | Critical for multilingual families |
| **Switch / VoiceOver Access** | Serves users with significant motor/visual impairments |
| **SLP Clinical Trust** | Evidence-based design, widely prescribed |

> **Key Weakness:** iOS-only, ~$250 one-time cost, steep learning curve, no AI/predictive assistance.

---

### Otsimo — Strengths
| Strength | Why It Matters |
|---|---|
| **Gamified, child-friendly UX** | Lower barrier to entry for kids and families |
| **1,700+ pre-built vocabulary** | Ready out-of-the-box without SLP setup |
| **Text-to-Speech keyboard** | Dual-mode: symbol-based AND text-based input |
| **Verb conjugation support** | Supports grammatical accuracy in output |
| **Offline-first** | Works in schools, clinics, anywhere |
| **Cross-platform (iOS + Android)** | Much wider device reach than Proloquo2Go |
| **Affordable entry point** | Freemium model reduces family cost barrier |

> **Key Weakness:** Uncertain maintenance, weak SLP adoption, lacks advanced clinical features (switch scanning, LAMP motor planning), no collaborative tools.

---

## 2. Market Gap & Opportunity

The "sweet spot" is currently **empty** in the market:

```
[Low-tech PECS boards] ← gap → [Otsimo entry-level] ← GAP → [Proloquo2Go $250 iOS-only]
                                                          ↑
                                               YOUR MVP LIVES HERE
```

**Three clear opportunities:**
1. 🌍 **Cross-platform (iOS + Android)** with full feature parity — no "lite" Android version
2. 🤝 **Collaborative vocab sync** between parents, teachers, and SLPs in real time
3. 🤖 **AI-powered context-aware suggestions** — recommend words based on location, time, or conversation history

---

## 3. MVP Scope (What to Build First)

### ✅ MVP Features (Phase 1 — ~3 months)

| Feature | Description | Priority |
|---|---|---|
| **Symbol Grid Communication Board** | Tap symbols/icons to build sentences | P0 |
| **Text-to-Speech (TTS) output** | Natural-sounding voices, multiple languages | P0 |
| **Pre-built Vocabulary Pack** | 200–500 core words (Fringe + Core word categories) | P0 |
| **Offline-first** | All core vocab works without internet | P0 |
| **Custom Cards** | Add personal photos and labels | P0 |
| **Caregiver Mode** | Password-locked edit mode to add/remove/rearrange cards | P0 |
| **User Profile** | Multiple user profiles per device (child vs. adult) | P1 |
| **Category Navigation** | Folders by theme (food, feelings, home, school) | P1 |
| **Sentence Builder Bar** | Tap-to-queue words before speaking | P1 |
| **Adjustable Grid Size** | 2×2 to 6×6 button grids | P1 |

### 🔜 Phase 2 Features (Post-MVP)
- AI vocabulary suggestions (geolocation-aware, context-aware)
- SLP/parent collaborative board editing (real-time sync via cloud)
- Switch scanning / external device support
- Word prediction
- Progress analytics for caregivers
- Multilingual TTS (BM, Mandarin, Tamil for SEA market)

---

## 4. Recommended Tech Stack

### 🏗️ Mobile App — **Flutter (Dart)**

**Why Flutter over React Native for this app:**

| Criterion | Flutter Advantage |
|---|---|
| **Pixel-perfect custom UI** | Symbol grids, animated feedback, custom boards need Flutter's canvas renderer |
| **Accessibility semantics** | Full control over `Semantics` tree → screen reader precision |
| **Single codebase** | iOS + Android from one Dart codebase |
| **Offline-first** | Excellent SQLite/Hive integration, no JS bridge overhead |
| **Performance** | Impeller renderer ensures smooth 60fps grid animations |

**Key Flutter Packages:**

```yaml
# TTS
flutter_tts: ^4.x          # Text-to-speech engine (iOS + Android native)

# Local Storage (offline-first)
hive_flutter: ^1.x         # Fast NoSQL for symbol/card data
sqflite: ^2.x              # Relational data for profiles, history

# Image & Custom Cards
image_picker: ^1.x         # Pick photos from camera/gallery
cached_network_image: ^3.x # Cached symbol images

# State Management
riverpod: ^2.x             # Scalable, testable state (preferred over Bloc for MVP speed)

# Accessibility
semantics (built-in)       # Flutter native a11y semantics tree

# Audio Feedback
just_audio: ^0.9.x         # Sound effects on tap

# Navigation
go_router: ^13.x           # Declarative routing
```

---

### ☁️ Backend — **Supabase** (BaaS)

**Why Supabase:**
- PostgreSQL database (row-level security for multi-user families)
- Real-time subscriptions (collaborative board sync in Phase 2)
- Auth (email, Google, Apple Sign-in)
- Storage (custom card images)
- Free tier viable for MVP validation
- Self-hostable (important for healthcare data compliance later)

**Schema sketch:**
```
users → profiles → boards → cards
             ↓
         shared_boards (for SLP collaboration — Phase 2)
```

---

### 🔊 TTS Strategy

| Tier | Solution | Use Case |
|---|---|---|
| **On-device (offline)** | `flutter_tts` (iOS AVSpeechSynthesizer / Android TTS) | Free, zero latency, works offline |
| **Enhanced cloud voices** | Google Cloud TTS / ElevenLabs API | Premium natural voices (subscription feature) |
| **Child voices** | Google WaveNet child voices | Differentiated premium tier |

---

### 🎨 Symbol/Icon Library

- **ARASAAC** — Free, open-source AAC symbols (36,000+ pictograms, CC license)
- **Mulberry Symbols** — Open-source alternative
- Custom AI-generated symbols via **Stable Diffusion / DALL-E** for missing vocabulary

---

### 📊 Analytics & Monitoring

| Tool | Purpose |
|---|---|
| **PostHog** (self-hosted) | Usage analytics, feature flags for A/B testing |
| **Sentry** | Crash reporting |
| **Firebase Crashlytics** | Mobile crash alternative |

---

## 5. Architecture Overview

```
┌──────────────────────────────────────────────┐
│              Flutter App (Mobile)            │
│  ┌──────────┐  ┌─────────────┐  ┌─────────┐ │
│  │ Symbol   │  │  Sentence   │  │ Profile │ │
│  │  Grid    │  │   Builder   │  │ Manager │ │
│  └────┬─────┘  └──────┬──────┘  └────┬────┘ │
│       │               │              │       │
│  ┌────▼───────────────▼──────────────▼────┐  │
│  │         Riverpod State Layer           │  │
│  └────────────────────┬───────────────────┘  │
│                        │                     │
│  ┌─────────────────────▼──────────────────┐  │
│  │    Local Storage (Hive / SQLite)        │  │
│  │    + TTS Engine + Image Cache           │  │
│  └────────────────────┬───────────────────┘  │
└───────────────────────┼──────────────────────┘
                        │ (optional cloud sync)
               ┌────────▼────────┐
               │   Supabase      │
               │  (Auth + DB +   │
               │   Storage +     │
               │  Realtime sync) │
               └─────────────────┘
```

---

## 6. Monetization Model

| Tier | Price | Features |
|---|---|---|
| **Free** | $0 | 50 core words, 1 profile, basic grid, offline |
| **Family** | ~$9.99/mo or $59.99/yr | Unlimited vocab, custom cards, multiple profiles, cloud backup |
| **Professional** | ~$19.99/mo | All Family + collaborative editing, analytics, priority SLP support |

> 💡 **Key differentiator vs Proloquo2Go:** No $250 upfront wall. Families can try before committing.
> 💡 **Key differentiator vs Otsimo:** Professional SLP tools included, not just gamified entry-level.

---

## 7. Development Timeline

```
Month 1 — Foundation
  ├── Flutter project setup + design system
  ├── Symbol grid UI (configurable N×N)
  ├── Hive local DB schema (cards, boards, profiles)
  └── Basic TTS integration (flutter_tts)

Month 2 — Core Features
  ├── Sentence builder bar
  ├── Category folder navigation
  ├── Caregiver edit mode (add/remove/rearrange cards)
  ├── Custom photo card upload
  └── ARASAAC symbol library integration

Month 3 — Polish & Launch
  ├── Multiple user profiles
  ├── Grid size settings (2×2 to 6×6)
  ├── Offline guarantee (full local-first testing)
  ├── Accessibility audit (VoiceOver/TalkBack)
  ├── App Store + Play Store submission
  └── Supabase auth + cloud backup (opt-in)
```

---

## 8. Key Differentiators vs. Competitors

| Dimension | Proloquo2Go | Otsimo | **Your App** |
|---|---|---|---|
| **Platform** | iOS only | iOS + Android | ✅ iOS + Android |
| **Pricing** | $250 one-time | Subscription (uncertain) | ✅ Freemium → affordable subscription |
| **SLP features** | ✅ Advanced | ❌ Limited | ✅ MVP-level, grows to full |
| **Offline** | ✅ | ✅ | ✅ |
| **AI Suggestions** | ❌ | ❌ | 🔜 Phase 2 |
| **Collaborative editing** | ❌ | ❌ | 🔜 Phase 2 |
| **Multilingual (SEA)** | Limited | Limited | 🔜 Phase 2 |
| **Open symbol library** | Proprietary | Semi-open | ✅ ARASAAC (open) |

---

## Open Questions

> [!IMPORTANT]
> **Target User Geography:** Are you targeting Malaysia/SEA specifically? This would prioritize BM/Mandarin/Tamil TTS in Phase 2 and impact app store strategy.

> [!IMPORTANT]
> **Team Composition:** Do you have Flutter/Dart experience, or would React Native be faster given your team's current skills?

> [!IMPORTANT]
> **Clinical Partnership:** Do you plan to work with SLPs or hospitals for validation? This heavily impacts the feature set and credibility needed at launch.

> [!IMPORTANT]
> **Regulatory / PDPA Compliance:** Health-related apps handling children's data require careful consideration of data privacy laws (PDPA in Malaysia, COPPA in the US, GDPR in Europe). Do you plan to store user data in the cloud from day one?
