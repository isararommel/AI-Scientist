# PLAN – zentrale Aufgabenliste

**Jede Sitzung beginnt hier.** Sitzungen werden regelmäßig mit `/clear` neu gestartet, um Kontingent zu sparen. Deshalb steht
hier alles, was eine frische Sitzung zum Weiterarbeiten braucht: Stand, nächste Aufgaben mit genug Einzelheiten, offene Fragen.
Nach jeder erledigten Aufgabe wird diese Datei aktualisiert (abhaken, nächste Aufgabe ausformulieren) und mitcommittet.

*Stand: 19.11.2026* – Fork eingerichtet, Server-LLM-Einbindung auf `feat/aura-llm` fertig (wartet auf aura-tools#69 für den Kurztest).

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

### 2. Server-LLM in AI-Scientist einbinden – Code fertig (19.11.), Merge wartet auf Kurztest

Branch `feat/aura-llm` (PR offen, **nicht mergen vor dem Kurztest**). Umgesetzt von mistral-team, von Claude geprüft:
- `ai_scientist/llm.py`: `AURA_PREFIX`, `AURA_TIMEOUT = 1800`, Eintrag `aura/qwen3.6:35b-a3b-q4_K_M` in `AVAILABLE_LLMS`;
  aura-Zweig jeweils **zuerst** in `create_client` / `get_response_from_llm` (Server hat auch `gpt-oss`, das sonst in die
  Substring-Zweige fiele); `client_model` behält das Präfix, abgeschnitten wird erst im API-Aufruf; Batch läuft über die Schleife.
  Neu `create_aider_model(model)` für alle drei Aider-Stellen; aura → `openai/<name>` mit `api_base`/`api_key`/`timeout`
  als `extra_params` (kein Überschreiben von `OPENAI_API_*`).
- `launch_scientist.py`: Review war fest `gpt-4o` + `openai.OpenAI()` → bei `aura/` jetzt `client`/`client_model` des Laufs
  (sonst wäre der aura-Token an OpenAI gegangen). `perform_writeup.py`: Aider-Block durch `create_aider_model`.
- Doku: `docs/aura-llm.md`. Variablen: `AURA_LLM_BASE_URL` (inkl. `/v1`), `AURA_LLM_API_KEY`.
- Geprüft: `make test` ok, `pruefen --diff` 0 Fehler, Offline-Verdrahtung (Dummy-URL → `APIConnectionError`, nicht
  `ValueError`/`KeyError`; Aider-Name/extra_params ok; `OPENAI_API_KEY` unverändert).
- **Offen:** Kurztest gegen echte Schnittstelle, sobald aura-tools#69 erledigt ist (Variablennamen ggf. an #69 angleichen):
  `python -m ai_scientist.generate_ideas --model aura/qwen3.6:35b-a3b-q4_K_M --experiment 2d_diffusion`
  (nicht `launch_scientist.py` – das bricht ohne LaTeX vor der Ideenerzeugung ab). Ideendatei prüfen, dann PR per
  `python3 normen/normen.py merge <PR>`. Ungetestet bis dahin: Aider über litellm mit `extra_params` (erst im Vollauf).
- Übergangsweise möglich: SSH-Tunnel auf Ollama (`AURA_LLM_BASE_URL=http://localhost:11434/v1`, Schlüssel beliebig).

### 3. Erster Probelauf: Ideen erzeugen mit `2d_diffusion`

Danach Vollauf mit einer Idee. `2d_diffusion` und `grokking` fallen ohne CUDA auf CPU zurück; optional auf MPS umstellen (eigene Aufgabe). `nanoGPT*` braucht CUDA fest.

## Offene Fragen an die Inhaberin

- LaTeX (BasicTeX oder MacTeX) installieren, sobald der erste Vollauf ansteht?
