# Changes from upstream

Aperture is a derivative of [World Monitor](https://github.com/koala73/worldmonitor)
(© 2024-2026 Elie Habib, AGPL-3.0). This file summarizes modifications in this
fork, as encouraged by AGPL-3.0 §5(a) (marking modified files / stating changes).

## Branding
- Renamed the product to **Aperture** across the UI wordmark, page title, social
  meta tags, PWA metadata (`src/config/variant-meta.ts`), and `package.json`.
- Upstream domain URLs, the original author's profile links, and the `LICENSE`
  are intentionally **unchanged** (attribution preserved per AGPL).

## Functional
- **Pro/premium features unlocked** for this self-hosted build — `isProUser()`
  and `hasPremiumAccess()` return `true`
  (`src/services/widget-store.ts`, `src/services/panel-gating.ts`).
- **Light theme by default** — application theme (`src/utils/theme-manager.ts`),
  2D MapLibre basemap (`src/config/basemap.ts`), and 3D globe scene
  (`src/components/GlobeMap.ts`).
- **Realistic globe** — default globe texture changed to NASA Blue Marble
  (`src/services/globe-render-settings.ts`).
- **Removed the Discord community** widget/links (the Discord *notification
  channel* integration is retained).
- **Repository links** point to this fork.

## Docs
- Added `LOCAL_SETUP.md` and `docker-compose.override.example.yml`.

---
This work remains licensed under AGPL-3.0. Source: https://github.com/ajaykhanna123ak/worldmonitor
