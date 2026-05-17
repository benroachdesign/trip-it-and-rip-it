# Trip it & Rip it!

Private iOS app for the annual men's golf trip. Native SwiftUI, Supabase backend, App Store distribution.

**Target ship:** June 20, 2026 (App Store submission). **Trip:** July 23-27, 2026, Bandon Dunes.

## Repo layout

```
ios/                    Xcode project (created in Phase 0)
supabase/migrations/    Supabase migrations — auto-deployed on push to main
web/                    Privacy policy (hosted on GitHub Pages)
```

## Database workflow

This project uses Supabase's GitHub integration. **Any SQL file added to `supabase/migrations/` is automatically applied to the production database when merged to `main`.** Migrations are immutable once applied — to change schema, add a new migration, don't edit an old one.

Naming convention: `YYYYMMDDHHMMSS_description.sql`. Files are applied in lexical order.

## Phase 0 checklist

External setup (you do):

- [x] **Supabase project** created (`darpwkdjywalibuvqwzv`), GitHub repo connected with auto-deploy enabled.
- [x] **First push to `main`** — three initial migrations applied successfully. RLS confirmed enforcing the allowlist.
- [ ] **Storage buckets:** in Supabase dashboard, create public buckets `course-photos` and `avatars`.
- [ ] **Xcode project:** create a new iOS App in `ios/`. Interface: SwiftUI. Bundle ID: `com.benroach.tripitripit`. Deployment target: iOS 17.0.
- [x] **Apple Sign In capability** added in Xcode (Signing & Capabilities).
- [ ] **Supabase Apple provider:** dashboard → Auth → Providers → Apple → enable, set Client IDs to `com.benroach.tripitripit`.
- [ ] **Allowed emails:** populate `allowed_emails` table with the Apple-ID emails of all 10 members (rolling).

> Auth approach: **Sign in with Apple only.** Google was cut on 2026-05-17 — every user is on iPhone, so Google is redundant and Sign in with Apple is the strongest signal to App Review.
- [x] **Privacy policy hosting:** live at https://benroachdesign.github.io/trip-it-and-rip-it-privacy/ (repo: `benroachdesign/trip-it-and-rip-it-privacy`).

Already produced:

- [x] `supabase/migrations/20260517000001_initial_schema.sql`
- [x] `supabase/migrations/20260517000002_rls_policies.sql`
- [x] `supabase/migrations/20260517000003_seed_initial_data.sql`
- [x] `web/privacy.html`

## After Phase 0

Phase 1 work (archive, profiles, trophy case) begins once auth works end-to-end and the schema is seeded.
