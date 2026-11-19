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

### 1. Lokale Umgebung für einen ersten Probelauf

Ziel: AI-Scientist läuft lokal mit einem kleinen Template (z. B. `nanoGPT_lite` oder ein CPU-taugliches Template) bis zur Ideengenerierung.
Branch: `chore/lokale-umgebung`. Stand: noch nicht begonnen.
Schritte: 1. `.venv` mit Python 3.11 anlegen (README nennt 3.11; lokal ist 3.13), `pip install -r requirements.txt`.
2. Prüfen, welches Template ohne CUDA läuft (macOS, keine NVIDIA-GPU); Befund hier notieren.
3. LaTeX-Bedarf klären (README: `texlive-full`; auf macOS MacTeX/BasicTeX) – nur nach Rückfrage installieren.
4. Mit der Inhaberin Modell und Budget festlegen, dann `python launch_scientist.py … --num-ideas 1` mit `--skip-novelty-check` testen.
Fallstricke: API-Schlüssel nur als Umgebungsvariable; Läufe kosten Guthaben; `results/` und `templates/*/run_0/` sind ignoriert.
Abnahme: `make test`, `python3 normen/normen.py pruefen --diff`, Probelauf-Ausgabe von der Inhaberin bestätigt.

## Offene Fragen an die Inhaberin

- Welches LLM (und welches Budget) soll für Probeläufe genutzt werden?
- Welches Template bzw. welche Fragestellung interessiert dich zum Ausprobieren?
