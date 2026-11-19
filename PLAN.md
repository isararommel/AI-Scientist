# PLAN – zentrale Aufgabenliste

**Jede Sitzung beginnt hier.** Sitzungen werden regelmäßig mit `/clear` neu gestartet, um Kontingent zu sparen. Deshalb steht
hier alles, was eine frische Sitzung zum Weiterarbeiten braucht: Stand, nächste Aufgaben mit genug Einzelheiten, offene Fragen.
Nach jeder erledigten Aufgabe wird diese Datei aktualisiert (abhaken, nächste Aufgabe ausformulieren) und mitcommittet.

*Stand: 19.11.2026* – Fork eingerichtet (Normen, Hooks, Multi-KI-Ablauf). Noch kein echter Lauf von AI-Scientist.

## Verweise

| Datei | Wofür |
|---|---|
| [CLAUDE.md](CLAUDE.md) | Hinweise für Claude, Testbefehl, Datenschutz |
| [docs/multi-ki-ablauf.md](docs/multi-ki-ablauf.md) | Ablauf mit mistral-team / gemini-analyst |
| [normen/kurz.md](normen/kurz.md) | Agenten-Normen (Kurzfassung) |

## Arbeitsweise (kurz)

- Eigener Branch je Aufgabe, PR, Merge über `python3 normen/normen.py merge <PR>`; Testbefehl siehe `CLAUDE.md`.
- Pakete so schneiden, dass danach `/clear` möglich ist (S08): Befunde sofort hier festhalten, am Paketende committen und
  „/clear möglich“ melden. Ausnahme: stark zusammenhängende Pakete (Grund nennen).
- Projektbesonderheiten: öffentlicher Fork (`origin`), Original als `upstream`; gesperrt: `.env`, `secrets/`, `*.key`;
  keine Forschungs- oder Personendaten; `make test` = Rauchtest (compileall); echte Läufe kosten API-Guthaben → nur auf Wunsch.

## Erledigt (letzte Schritte)

- ✅ 19.11. Agenten-Normen und Multi-KI-Ablauf eingerichtet – Branch `chore/projekt-einrichten`

## Nächste Aufgaben (in dieser Reihenfolge)

### 1. Lokale Umgebung – teilweise erledigt (19.11.)

- ✅ `.venv` mit Python 3.11 (`uv venv --python 3.11 .venv`, `uv pip install --python .venv/bin/python -r requirements.txt`); torch 2.15, MPS verfügbar.
- ✅ Modell entschieden: `qwen3.6:35b-a3b-q4_K_M` auf hel1-aura (Ollama, nur CPU – langsam, reicht für Tests).
- ⏳ **Blockiert:** Ollama ist vom Mac nicht erreichbar → Schnittstelle angefragt in aura-tools#69 (OpenAI-kompatibel, Token, lange Timeouts). Erst danach weiter mit Aufgabe 2.
- ⏳ LaTeX fehlt (`pdflatex` nicht installiert) – erst für das Paper-Schreiben nötig, Installation (BasicTeX/MacTeX) nur nach Rückfrage.

### 2. Server-LLM in AI-Scientist einbinden

Ziel: `--model aura/qwen3.6:35b-a3b-q4_K_M` (Präfix `aura/`) funktioniert für Ideen, Review und Aider.
Branch: `feat/aura-llm`. Stand: wartet auf aura-tools#69 (Basis-URL und Variablennamen von dort übernehmen, z. B. `AURA_LLM_BASE_URL`, `AURA_LLM_API_KEY`).
Schritte (Spezifikation an `mistral-team`, Claude prüft):
1. `ai_scientist/llm.py`: Modelle mit Präfix `aura/` in `AVAILABLE_LLMS` zulassen bzw. bei `--model` akzeptieren; `create_client` → `openai.OpenAI(base_url=…, api_key=…)`, Modellname ohne Präfix; `get_response_from_llm` / `get_batch_responses_from_llm` wie den OpenAI-Zweig behandeln (n>1 ggf. per Schleife, Ollama kann kein `n`); großzügiges Timeout.
2. `launch_scientist.py` (beide `Model(...)`-Stellen): für `aura/…` → Aider-Modell `openai/<name>` mit `OPENAI_API_BASE`/`OPENAI_API_KEY` aus den aura-Variablen (nur im Prozess setzen).
3. `README`-Abschnitt (deutsch, kurz) in einer neuen Datei `docs/aura-llm.md`.
Fallstricke: keine echten Hostnamen oder Tokens im öffentlichen Repo – nur Variablennamen; `make test` bleibt ohne Server lauffähig.
Abnahme: `make test`, `normen.py pruefen --diff`, manueller Kurztest `python launch_scientist.py --model aura/qwen3.6:35b-a3b-q4_K_M --experiment 2d_diffusion --num-ideas 1 --skip-novelty-check` bis zur Ideendatei.

### 3. Erster Probelauf: Ideen erzeugen mit `2d_diffusion`

Danach Vollauf mit einer Idee. `2d_diffusion` und `grokking` fallen ohne CUDA auf CPU zurück; optional auf MPS umstellen (eigene Aufgabe). `nanoGPT*` braucht CUDA fest.

## Offene Fragen an die Inhaberin

- LaTeX (BasicTeX oder MacTeX) installieren, sobald der erste Vollauf ansteht?
