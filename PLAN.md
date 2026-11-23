# PLAN – zentrale Aufgabenliste

**Jede Sitzung beginnt hier.** Sitzungen werden regelmäßig mit `/clear` neu gestartet, um Kontingent zu sparen. Deshalb steht
hier alles, was eine frische Sitzung zum Weiterarbeiten braucht: Stand, nächste Aufgaben mit genug Einzelheiten, offene Fragen.
Nach jeder erledigten Aufgabe wird diese Datei aktualisiert (abhaken, nächste Aufgabe ausformulieren) und mitcommittet.

*Stand: 23.11.2026* – Normen v17; Fork eingerichtet; Server-LLM-Einbindung auf `feat/aura-llm` fertig (PR #2), Kurztest wartet auf die Server-Schnittstelle (Anfrage im privaten Tool-Repo, Issue #69; Stand 23.11.: offen, keine Kommentare; Entscheidung der Inhaberin: weiter warten). `2d_diffusion` ist lauffähig (Basislauf `run_0` da), MPS verworfen.

**Frische Sitzung:** auf Branch `feat/aura-llm` starten (`main` hat noch den alten Plan), PR #2 offen.

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
- ✅ 21.11. Normen v14 → v15 (`normen.py aktualisieren`, Quelle claude-tools 06bdfbd); neu `[werkzeuge].vertraut` in
  `projekt.toml` (hier noch keine Einträge, Freigabe der Inhaberin), Befehle über Variablen werden geprüft. `make test` ok,
  `pruefen --diff` 0 Fehler. Liegt auf `feat/aura-llm` (kommt mit PR #2 nach `main`).
- ✅ 22.11. Normen v15 → v16 (Quelle claude-tools 395e86a, Merge von PR #30; ein erster Einspielversuch aus dem
  unfertigen Merge wurde damit ersetzt): Pfade ohne Groß-/Kleinschreibung in allen Sperrlisten, `python3 -m`/Importe
  werden aufgelöst und geprüft, vertraute Werkzeuge nur für Rolle claude, neu `selbsttest --sitzung`, S06-Text ergänzt.
  `make test` ok, `pruefen --diff` 0 Fehler. Auf `feat/aura-llm` (kommt mit PR #2 nach `main`). Herkunft belegt
  (395e86a auf origin/main, sha256 von normen.py/normen.toml = herkunft.toml). Selbsttest nach Neustart: Köder gesperrt,
  `selbsttest --sitzung` bestanden, `selbsttest` 5/5 Wege gesperrt.
- ✅ 23.11. Normen v16 → v17 (Quelle claude-tools 3f4f52e = origin/main, PR #42; sha256 = herkunft.toml): Review-Tor in
  `normen.py merge`, neu `normen.py review`, Teams dürfen `normen.py` nur noch für `pruefen`/`kurz` aufrufen.
  `[review]` aus der Vorlage in `projekt.toml` (versionsdateien leer); per `multi-ki/einrichten.sh` neu
  `docs/review-auftrag.md`/`review-bericht.md`, `docs/multi-ki-ablauf.md` durch die Vorlage ersetzt (Abschnitt „Review“;
  keine Projektbesonderheiten gingen verloren), `.geminiignore` bleibt Projektfassung (Sperrpfade). Label `meilenstein` im
  Fork angelegt. `make test` ok, `pruefen --diff` 0 Fehler, `selbsttest` 5/5 gesperrt (`--sitzung` erst nach Neustart).
  **Für PR #2 gilt beim Merge das neue Tor:** ab 150 Code-Zeilen Halt → `normen.py merge 2 --klein "<Grund>"` oder Label
  `meilenstein` + Review-Bericht `docs/reviews/<datum>-feat-aura-llm.md`.

## Nächste Aufgaben (in dieser Reihenfolge)

### 1. Lokale Umgebung – teilweise erledigt (19.11.)

- ✅ `.venv` mit Python 3.11 (`uv venv --python 3.11 .venv`, `uv pip install --python .venv/bin/python -r requirements.txt`); torch 2.15, MPS verfügbar.
- ✅ Modell entschieden: `qwen3.6:35b-a3b-q4_K_M` auf dem eigenen Server (Ollama, nur CPU – langsam, reicht für Tests).
- ⏳ **Blockiert:** Ollama ist vom Mac nicht erreichbar → Schnittstelle angefragt (privates Tool-Repo, Issue #69: OpenAI-kompatibel, Token, lange Timeouts). Code für Aufgabe 2 ist trotzdem fertig; nur der Kurztest wartet.
- ✅ 20.11. LaTeX: MacTeX 2026 (`mactex-no-gui`, TeX Live 2026) unter `/Library/TeX/texbin` (`pdflatex`, `bibtex`, `chktex`); alle Pakete der `2d_diffusion`-Vorlage vorhanden, Probeübersetzung ok (einziger Fehler: fehlendes `generated_images.png`, entsteht erst im Lauf). In alten Terminals ggf. `eval "$(/usr/libexec/path_helper)"`.

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
- **Offen:** Kurztest gegen echte Schnittstelle, sobald Issue #69 erledigt ist (Variablennamen ggf. angleichen):
  `python -m ai_scientist.generate_ideas --model aura/qwen3.6:35b-a3b-q4_K_M --experiment 2d_diffusion`
  (schneller als `launch_scientist.py`, das sofort auch Experimente und Writeup startet). Ideendatei prüfen, dann PR per
  `python3 normen/normen.py merge <PR>`. Ungetestet bis dahin: Aider über litellm mit `extra_params` (erst im Vollauf).
- ✅ 22.11. Verdrahtung gegen lokales Ollama (Mac, `AURA_LLM_BASE_URL=http://127.0.0.1:11434/v1`, Modell
  `aura/gemma4:e4b`, ohne `OPENAI_API_KEY`) geprüft: `create_client` + `get_response_from_llm` liefern Antwort und JSON;
  `create_aider_model(...).send_completion` (Aider 0.86.2, litellm mit `extra_params`) antwortet. Damit ist nur noch das
  Zusammenspiel mit dem Server und dem qwen-Modell offen. Stand Issue #69: offen, keine Kommentare.
  Entscheidung der Inhaberin 22.11.: auf #69 warten, kein lokaler Ideenlauf mit gemma.
- Übergang per SSH-Tunnel **geht derzeit nicht** (geprüft 22.11.): Der Server lässt keine Portweiterleitung zu.
  Ollama und das Modell sind dort vorhanden. Falls ein Tunnel später möglich wird: lokal **nicht Port 11434** nehmen
  (dort läuft auf dem Mac ein eigenes Ollama), z. B. 11435, Ziel `127.0.0.1:11434`, dann
  `AURA_LLM_BASE_URL=http://127.0.0.1:11435/v1`, Schlüssel beliebig. `! export` hält in der Claude-Shell nicht an;
  Variablen je Aufruf mitgeben.

### 3. Erster Probelauf: Ideen erzeugen mit `2d_diffusion`

Danach Vollauf mit einer Idee. `2d_diffusion` und `grokking` fallen ohne CUDA auf CPU zurück. `nanoGPT*` braucht CUDA fest.

- ✅ 23.11. Vorbereitung `2d_diffusion`: Pakete laut README mit Freigabe der Inhaberin in `.venv` installiert
  (NPEET fest auf Commit `8b0d948` per `uv pip install "git+https://github.com/gregversteeg/NPEET.git@8b0d948…"`,
  scikit-learn 1.9.1; stehen nicht in `requirements.txt`, bei neuer `.venv` wiederholen). Basislauf
  `templates/2d_diffusion/run_0` + `plot.py` erzeugt (CPU, 143 s; KL circle 0,36 / dino 1,05 / line 0,18 / moons 0,08;
  `run_0/` und PNGs sind ignoriert).
- ❌ 23.11. MPS verworfen: Messung mit 1000 Schritten, CPU 33 s gegenüber MPS 34 s gesamt; Training je Datensatz auf
  MPS langsamer (4,3 s statt 3,3 s), nur Inferenz etwas schneller; Großteil der Zeit ist die KL-Schätzung (NPEET, CPU).
  Kleines MLP auf 2D-Punkten lohnt MPS nicht → Vorlage bleibt unverändert. `grokking` ggf. später eigens messen.

## Offene Fragen an die Inhaberin


- Keine offen. (LaTeX erledigt 20.11.; PR #2 wartet auf den Server, Merge danach.)
