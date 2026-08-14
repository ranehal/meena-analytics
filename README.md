# Pulse Market — Meena Bazar price-history site

Independent grocery price-history and deal-discovery archive for Meena Bazar. Live at <https://ranehal.github.io/meena-analytics/>.

**Not affiliated with, sponsored by, or endorsed by Meena Bazar.**

## What this is

A static site (no build step) served from GitHub Pages:

- `index.html`, `styles.css`, `app.js` — the single-page app
- `catalog.json` — current normalized catalog (~10k products)
- `sections.json`, `meta.json` — home sections and health stats
- `history_*.json` — 256 on-demand price-history shards (product `id % 256`), each holding compact `{from, to, price}` segments
- `.github/workflows/update-data.yml` — daily 06:30 Asia/Dhaka catalog refresh

The frontend lazy-loads only the shard it needs per product and expands segments into daily price points for the chart.

## Scrape & update data

```bash
python -m venv .venv && source .venv/bin/activate   # or runall.bat on Windows
pip install -r requirements.txt
python scrape.py
```

The scraper writes `catalog.json`, `sections.json`, `meta.json`, and `history_*.json` to the repo root (set `MEENA_OUTPUT_DIR` to change).

## GitHub Actions

Add `MEENA_BEARER_TOKEN` under **Repository settings → Secrets and variables → Actions**. The included workflow runs daily, commits only changed `*.json`, and pushes to `main`, which auto-publishes to GitHub Pages.

## Security

Do **not** commit the HAR (`*.har`) — it contains a reusable bearer credential and personal account data. Rotate any exposed token. Use only an account and API access you are authorized to automate, with a conservative request rate and the service's applicable terms.