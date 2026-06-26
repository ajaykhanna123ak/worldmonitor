# Local Setup

This is a self-host fork of World Monitor. There are **two ways to run it**, and
which one you pick decides whether the data-heavy panels light up.

> **TL;DR for the "… data temporarily unavailable" panels:** that's expected on
> `npm run dev`. Markets, Crypto, Energy, Oil, Macro Stress (FRED), Trade Policy,
> the WM Analyst, and Premium Backtesting need the **backend stack + API keys**,
> which only run under **Docker** (below). The dev server is frontend-only.

---

## Option A — Frontend dev server (fast, partial data)

Good for UI work. Runs the Vite frontend + a subset of data handlers
(earthquakes, conflicts, weather, news, maps). Backend/keyed panels will show
"temporarily unavailable".

```bash
npm install
npm run dev          # → http://localhost:3000
```

No keys required. This is **not** the mode that fills the Markets/Macro/Energy/
Analyst panels.

## Option B — Full local stack (all panels, real data)

Runs the serverless API functions, Redis cache, and AIS relay in containers.
Requires Docker.

```bash
# 1. Add your keys (mostly free signups)
cp docker-compose.override.example.yml docker-compose.override.yml
#    …edit it and paste in FINNHUB / FRED / EIA / GROQ keys, etc.

# 2. Build + start the stack (builds from THIS source, so all customizations apply)
docker compose up -d        # → http://localhost:3000

# 3. Seed the Redis cache the panels read from
./scripts/run-seeders.sh
```

Which key unlocks which panel:

| Panel | Needs |
|-------|-------|
| Markets · Crypto · Premium Backtesting | `FINNHUB_API_KEY` |
| Macro Stress (indicators / stress index) | `FRED_API_KEY` |
| Energy Complex · Oil Inventories | `EIA_API_KEY` |
| WM Analyst (the "Error 404" panel) | `GROQ_API_KEY` **or** `OPENROUTER_API_KEY` (or `LLM_API_URL` → local Ollama) |
| Wildfires | `NASA_FIRMS_API_KEY` |
| Conflict realtime density | `ACLED_EMAIL` + `ACLED_PASSWORD` |
| Earthquakes · weather · news · prediction markets · cables | nothing (work out of the box) |

Full key list, free-vs-paid table, seeder details, and architecture diagram are
in [SELF_HOSTING.md](SELF_HOSTING.md).

---

## Customizations in this fork

This fork differs from upstream `koala73/worldmonitor`:

- **Pro features unlocked** for self-hosting — `isProUser()` / `hasPremiumAccess()`
  return `true` (`src/services/widget-store.ts`, `src/services/panel-gating.ts`).
  Legitimate under AGPL-3.0 for a self-hosted build; data behind keyed feeds
  still needs your own keys (Option B).
- **Light theme by default** — app theme, the 2D MapLibre basemap
  (`src/config/basemap.ts`), and the 3D globe scene (`src/components/GlobeMap.ts`)
  all default to light. Toggle in the header / Settings.
- **Discord community links removed** (notification-channel Discord integration kept).
- **Repo links point to this fork** instead of upstream.

## Note on GitHub Pages

A static host like GitHub Pages **cannot** run the backend in Option B, so the
keyed/Redis-backed panels will not work there — only the frontend + no-key feeds.
For a fully static dashboard, see the companion `worldmonitor-lite` build.

This project is licensed AGPL-3.0 (see [LICENSE](LICENSE)); the original is by
Elie Habib / [koala73](https://github.com/koala73).
