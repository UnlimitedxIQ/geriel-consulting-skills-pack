---
name: openai-tools
description: >
  Use when any task requires calling the OpenAI API — image generation (DALL-E 3),
  text completion (GPT-4o), text-to-speech (TTS), transcription (Whisper), or
  embeddings. Contains ready-to-run curl/Python patterns for each endpoint.
  API key is read from OPENAI_API_KEY env var. Use proactively when the user asks
  to generate images, use GPT, or needs any OpenAI service.
---

# OpenAI Tools

## Credentials

API key must be set as an environment variable:
```bash
export OPENAI_API_KEY="$OPENAI_API_KEY"
```

All code examples below read the key from `os.environ["OPENAI_API_KEY"]`.

---

## DALL-E 3 — Image Generation

### Single image (saves to file)
```bash
python3 - <<'EOF'
import urllib.request, urllib.error, json, base64, os

key = os.environ["OPENAI_API_KEY"]
prompt = "YOUR PROMPT HERE"
output_path = "output.png"

payload = json.dumps({
    "model": "dall-e-3",
    "prompt": prompt,
    "n": 1,
    "size": "1024x1024",   # options: 1024x1024, 1792x1024, 1024x1792
    "quality": "hd",        # "standard" or "hd"
    "response_format": "b64_json"
}).encode()

req = urllib.request.Request(
    "https://api.openai.com/v1/images/generations",
    data=payload,
    headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"}
)
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read())

img_bytes = base64.b64decode(data["data"][0]["b64_json"])
with open(output_path, "wb") as f:
    f.write(img_bytes)
print(f"Saved: {output_path}")
EOF
```

### Key parameters
| Parameter | Options | Notes |
|-----------|---------|-------|
| model | `dall-e-3` | Always use dall-e-3 for quality |
| size | `1024x1024`, `1792x1024`, `1024x1792` | Square, landscape, portrait |
| quality | `standard`, `hd` | hd = more detail, costs 2x tokens |
| style | `vivid`, `natural` | vivid = dramatic, natural = realistic |
| response_format | `url`, `b64_json` | Use b64_json to save locally |

---

## GPT-4o — Text Completion

```bash
python3 - <<'EOF'
import urllib.request, json, os

key = os.environ["OPENAI_API_KEY"]

payload = json.dumps({
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "YOUR PROMPT"}],
    "temperature": 0.7
}).encode()

req = urllib.request.Request(
    "https://api.openai.com/v1/chat/completions",
    data=payload,
    headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"}
)
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read())
print(data["choices"][0]["message"]["content"])
EOF
```

---

## Text-to-Speech (TTS)

```bash
python3 - <<'EOF'
import urllib.request, json, os

key = os.environ["OPENAI_API_KEY"]

payload = json.dumps({
    "model": "tts-1-hd",
    "input": "YOUR TEXT HERE",
    "voice": "alloy"   # alloy, echo, fable, onyx, nova, shimmer
}).encode()

req = urllib.request.Request(
    "https://api.openai.com/v1/audio/speech",
    data=payload,
    headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"}
)
with urllib.request.urlopen(req) as resp:
    with open("output.mp3", "wb") as f:
        f.write(resp.read())
print("Saved: output.mp3")
EOF
```

---

## Whisper — Audio Transcription

```bash
python3 - <<'EOF'
import urllib.request, urllib.parse, json, os

key = os.environ["OPENAI_API_KEY"]
audio_file = "your_audio.mp3"

boundary = "----FormBoundary"
with open(audio_file, "rb") as f:
    audio_data = f.read()

body = (
    f"--{boundary}\r\nContent-Disposition: form-data; name=\"model\"\r\n\r\nwhisper-1\r\n"
    f"--{boundary}\r\nContent-Disposition: form-data; name=\"file\"; filename=\"audio.mp3\"\r\nContent-Type: audio/mpeg\r\n\r\n"
).encode() + audio_data + f"\r\n--{boundary}--\r\n".encode()

req = urllib.request.Request(
    "https://api.openai.com/v1/audio/transcriptions",
    data=body,
    headers={"Authorization": f"Bearer {key}", "Content-Type": f"multipart/form-data; boundary={boundary}"}
)
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read())
print(data["text"])
EOF
```

---

## Notes

- **Rate limits**: DALL-E 3 = 5 images/min on tier 1. GPT-4o = 500 RPM.
- **Costs**: DALL-E 3 HD 1024x1024 = ~$0.080/image. Standard = ~$0.040.
- **Best image prompts**: Be specific about style ("photorealistic", "flat design", "mockup"), lighting, composition, and what text should appear.
- **Prompt length**: DALL-E 3 accepts up to 4000 chars — use the full space for detail.
