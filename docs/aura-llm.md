# Eigener LLM-Server (Präfix `aura/`)

AI-Scientist kann gegen einen selbst gehosteten, OpenAI-kompatiblen LLM-Server
(`POST /v1/chat/completions`) laufen. Modelle dieses Servers tragen das Präfix
`aura/`, z. B. `aura/qwen3.6:35b-a3b-q4_K_M`.

## Konfiguration

Basis-URL und Token kommen ausschließlich aus Umgebungsvariablen – das Token
niemals in Dateien, sondern nur als Umgebungsvariable oder im Schlüsselbund:

- `AURA_LLM_BASE_URL` – Basis-URL inklusive `/v1`, z. B. `https://<server>/v1`
- `AURA_LLM_API_KEY` – Bearer-Token für den Server

## Beispiele

```bash
python -m ai_scientist.generate_ideas --model aura/qwen3.6:35b-a3b-q4_K_M --experiment 2d_diffusion
python launch_scientist.py --model aura/qwen3.6:35b-a3b-q4_K_M --experiment 2d_diffusion --num-ideas 1
```

Der `launch_scientist.py`-Lauf erzeugt LaTeX und braucht daher eine
LaTeX-Installation.

## Verbindungsprüfung

```bash
curl -H "Authorization: Bearer $AURA_LLM_API_KEY" "$AURA_LLM_BASE_URL/models"
```

## Verhalten

- Timeout: 1800 s pro Anfrage (CPU-Inferenz kann viele Minuten dauern).
- Review: Bei `aura/`-Modellen nutzt das Review dasselbe Modell und denselben
  Client wie der Lauf statt GPT-4o.
- Aider (Experimente/Writeup) bekommt Basis-URL, Schlüssel und Timeout direkt
  als `extra_params` des Aider-Modells; `OPENAI_API_KEY`/`OPENAI_API_BASE` im
  Prozess bleiben unberührt.

## Weiteres Modell hinzufügen

Einen Eintrag `aura/<name>` in `AVAILABLE_LLMS` in `ai_scientist/llm.py`
ergänzen – der Rest (Client, Aider, Review) erkennt das Präfix automatisch.
