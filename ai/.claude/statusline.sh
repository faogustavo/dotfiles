#!/usr/bin/env bash
# Segmented statusline for Claude Code. Reads session JSON on stdin.
# Standard Unicode emoji icons are on (USE_ICONS below) — no Nerd Font
# needed. Each icon is followed by a single trailing space so it reads
# as "icon + separator" whether the terminal draws the glyph 1 or 2
# cells wide. Flip USE_ICONS to 0 to revert to icon-free labels
# instantly if glyphs still misrender.
# One jq call (fast — the command runs on every UI tick).
input=$(cat)

# tab-separated: model  ctx%  ctx_size  5h%  5h_reset  7d%  7d_reset  (empty fields ok)
IFS=$'\t' read -r model pct csize s_pct s_rst w_pct w_rst < <(
  jq -r '[ (.model.display_name // "?"),
           (.context_window.used_percentage // 0 | floor),
           (.context_window.context_window_size // 0),
           (.rate_limits.five_hour.used_percentage // "" | if .=="" then "" else floor end),
           (.rate_limits.five_hour.resets_at // ""),
           (.rate_limits.seven_day.used_percentage // "" | if .=="" then "" else floor end),
           (.rate_limits.seven_day.resets_at // "") ] | @tsv' <<<"$input")

# pad to 3 chars so width doesn't jump between 9/99/100 (space-pad, not zero-pad)
pad() { printf '%3d' "$1"; }
# 1M-context models get hard to use past 50% -> red earlier; smaller models 50/80.
if (( csize >= 1000000 )); then YEL=25; RED=50; else YEL=50; RED=80; fi
pct_bg() { (( $1 >= RED )) && echo 88 || { (( $1 >= YEL )) && echo 94 || echo 22; }; }

# Set to 0 to instantly revert to icon-free labels if glyphs misrender.
USE_ICONS=1
# icon <glyph> — glyph + one trailing space. The space is a workaround
# buffer, not a true width fix: a shell script can't force the terminal
# to draw an ambiguous-width glyph as 2 columns — that's controlled by
# the terminal's own font/width settings. No-op when USE_ICONS=0.
icon() { (( USE_ICONS )) && printf '%s ' "$1"; }

# seg <fg> <bg> <text> — flat colored block, no separator glyph
seg() { printf '\e[38;5;%sm\e[48;5;%sm %s ' "$1" "$2" "$3"; }

seg 231 240 "$(icon "🧠")$model"
seg 231 "$(pct_bg "$pct")" "$(icon "📊")Context $(pad "$pct")%"

[[ -n $s_pct ]] && { t="$(icon "🕐")Session $(pad "$s_pct")%"; [[ -n $s_rst ]] && t+=" ($(date -r "$s_rst" '+%H:%M' 2>/dev/null))"; seg 231 24 "$t"; }
[[ -n $w_pct ]] && { t="$(icon "📅")Weekly $(pad "$w_pct")%"; [[ -n $w_rst ]] && t+=" ($(date -r "$w_rst" '+%a %H:%M' 2>/dev/null))"; seg 231 60 "$t"; }

# Credits (extra usage) from the OAuth usage API, cached 5 min. A stale cache
# refreshes in the background, so the statusline never blocks on curl.
usage_cache="${TMPDIR:-/tmp}/claude-statusline-usage.json"
refresh_usage() {
  local tok resp
  tok=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
  [[ -z $tok ]] && tok=$(jq -r '.claudeAiOauth.accessToken // empty' ~/.claude/.credentials.json 2>/dev/null)
  [[ -z $tok ]] && return
  resp=$(curl -s --max-time 10 -H "Accept: application/json" -H "Authorization: Bearer $tok" \
    -H "anthropic-beta: oauth-2025-04-20" https://api.anthropic.com/api/oauth/usage)
  jq -e '.extra_usage and .error == null' <<<"$resp" >/dev/null && printf '%s' "$resp" > "$usage_cache.tmp" && mv "$usage_cache.tmp" "$usage_cache"
}
if (( $(date +%s) - $(stat -f %m "$usage_cache" 2>/dev/null || echo 0) >= 300 )); then
  touch "$usage_cache"  # claim the refresh so concurrent ticks don't stampede
  refresh_usage >/dev/null 2>&1 & disown 2>/dev/null
fi

# tab-separated: used_cents  limit_cents  pct_x10  (no line when extra usage is off)
IFS=$'\t' read -r x_used x_limit x_pct < <(
  jq -r '.extra_usage | select(.is_enabled == true)
         | [ (.used_credits | round), (.monthly_limit | round),
             (if .monthly_limit > 0 then .used_credits / .monthly_limit * 1000 | round else 0 end) ] | @tsv' \
    "$usage_cache" 2>/dev/null)
# money <cents> — "12,34"
money() { printf '%d,%02d' $(( $1 / 100 )) $(( $1 % 100 )); }
[[ -n $x_used ]] && seg 231 30 "$(icon "💲")US\$ $(money "$x_used")/$(money "$x_limit") ($(( x_pct / 10 )),$(( x_pct % 10 ))%)"

printf '\e[0m'
exit 0
