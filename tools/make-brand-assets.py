#!/usr/bin/env python3
"""Regenerate the favicon set, masthead monogram and Open Graph card.

Run from the repository root after changing the palette in _sass/_tokens.scss or
the tagline in _config.yml; the colours below are the light-theme tokens.
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ACCENT = (38, 100, 127)
PAPER = (253, 252, 250)
INK = (33, 38, 43)
MUTED = (95, 105, 113)

SERIF_BOLD = "/usr/share/fonts/truetype/liberation/LiberationSerif-Bold.ttf"
SERIF = "/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf"

OUT = Path("assets/images")
TAGLINE = (
    "Physicist and developer — notes and projects at the",
    "intersection of physics, machine learning and software.",
)


def monogram(size: int) -> Image.Image:
    # Drawn at 4x and downsampled: PIL has no antialiased shape drawing.
    s = size * 4
    img = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([0, 0, s - 1, s - 1], radius=int(s * 0.22), fill=ACCENT)
    font = ImageFont.truetype(SERIF_BOLD, int(s * 0.56))
    box = d.textbbox((0, 0), "LL", font=font)
    d.text(
        ((s - box[2] - box[0]) / 2, (s - box[3] - box[1]) / 2 - s * 0.02),
        "LL",
        font=font,
        fill=PAPER,
    )
    return img.resize((size, size), Image.LANCZOS)


def og_card() -> Image.Image:
    card = Image.new("RGB", (1200, 630), PAPER)
    d = ImageDraw.Draw(card)
    d.rectangle([0, 0, 1200, 10], fill=ACCENT)
    mark = monogram(96)
    card.paste(mark, (80, 90), mark)
    d.text((80, 250), "Lorenzo Liuzzo", font=ImageFont.truetype(SERIF_BOLD, 78), fill=INK)
    for i, line in enumerate(TAGLINE):
        d.text((80, 360 + i * 52), line, font=ImageFont.truetype(SERIF, 40), fill=MUTED)
    d.text((80, 520), "lorenzoliuzzo.github.io", font=ImageFont.truetype(SERIF, 34), fill=ACCENT)
    return card


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for n in (16, 32, 180, 512):
        monogram(n).save(OUT / f"monogram-{n}.png")
    monogram(64).save(OUT / "favicon.ico", sizes=[(16, 16), (32, 32), (48, 48)])
    og_card().save(OUT / "og-card.png")


if __name__ == "__main__":
    main()
