# Shop Assets Requirements

## Overview

This document outlines the assets needed for the shop unlock system. Currently using placeholder icons, but can be replaced with custom artwork for a more polished look.

---

## Board Themes

Each theme needs:
- Preview image (512x512 or vector)
- Full board background
- Tile textures/colors (defined in code)
- Property group colors (defined in code)

| Theme | Status | Notes |
|-------|--------|-------|
| Classic | ✅ Done | Uses code-defined colors |
| Neon Nights | 🎨 Need | Glowing effects, dark bg |
| Beach Paradise | 🎨 Need | Sandy textures, ocean vibes |
| Cosmic Voyage | 🎨 Need | Stars, nebula effects |
| Candy Land | 🎨 Need | Bright pastels, sweet shapes |
| Spooky Season | 🎨 Need | Halloween colors, spooky elements |
| Winter Wonderland | 🎨 Need | Snow, ice, cozy colors |

### Theme Asset Specs
- Board background: 1024x1024 tileable or single image
- Preview thumbnail: 256x256 PNG
- Format: PNG with transparency where needed

---

## Token Sets

Each set needs 4-6 token variations (one per player color).

| Set | Status | Description |
|-----|--------|-------------|
| Classic Pawns | ✅ Done | 3D chess pawn models (existing) |
| Golden Luxury | 🎨 Need | Gold-plated versions of pawns |
| Animal Kingdom | 🎨 Need | Dog, cat, bird, rabbit, etc. |
| Emoji Faces | 🎨 Need | 😀 🎉 🔥 ⭐ etc. |
| Crystal Gems | 🎨 Need | Diamond, ruby, emerald shapes |

### Token Asset Specs
- Size: 128x128 PNG per token
- Need 6 color variations per set
- Transparent background

---

## Dice Skins

Each skin needs:
- 6 face textures (1-6 dots)
- Dice body texture/color

| Skin | Status | Description |
|------|--------|-------------|
| Classic White | ✅ Done | Default white with black dots |
| Inferno | 🎨 Need | Fire/flame texture, orange glow |
| Frozen | 🎨 Need | Ice blue, frost effects |
| Galaxy Swirl | 🎨 Need | Purple/blue cosmic swirl |
| Solid Gold | 🎨 Need | Metallic gold finish |

### Dice Asset Specs
- Face texture: 64x64 per face (or 384x64 sprite sheet)
- Body color can be code-defined

---

## Card Backs

For Chance and Community Chest cards.

| Design | Status | Description |
|--------|--------|-------------|
| Classic | ✅ Done | Simple blue pattern |
| Royal Ornate | 🎨 Need | Victorian flourishes |
| Neon Glow | 🎨 Need | Cyberpunk lines, glow effect |

### Card Asset Specs
- Size: 256x384 PNG
- Need both Chance and Chest variants

---

## Sound Packs

Each pack needs replacement audio for:

| Sound | Classic | Retro | Chill |
|-------|---------|-------|-------|
| Dice roll | ✅ | 🎵 8-bit | 🎵 Soft |
| Token move | ✅ | 🎵 Blip | 🎵 Whoosh |
| Buy property | ✅ | 🎵 Coin | 🎵 Chime |
| Pay rent | ✅ | 🎵 Sad | 🎵 Soft ding |
| Go to jail | ✅ | 🎵 Wah wah | 🎵 Low tone |
| Pass GO | ✅ | 🎵 Fanfare | 🎵 Gentle bell |
| Bankrupt | ✅ | 🎵 Game over | 🎵 Fade out |
| Menu music | ✅ | 🎵 Chiptune | 🎵 Lofi beats |
| Game music | ✅ | 🎵 Chiptune | 🎵 Lofi beats |
| Victory | ✅ | 🎵 8-bit win | 🎵 Gentle triumph |

### Audio Asset Specs
- Format: MP3 or OGG
- SFX: <2 seconds, ~64kbps
- Music: Loop-friendly, ~128kbps

---

## Priority Order

1. **Phase 1 (MVP):** Use existing placeholder icons ✅
2. **Phase 2:** Add 2-3 premium themes with real art
3. **Phase 3:** Token sets and dice skins
4. **Phase 4:** Sound packs (requires more work)

---

## Asset Sources

Options for acquiring assets:
- **Custom artwork** - Commission or create
- **Asset packs** - itch.io, Unity Asset Store (check licenses)
- **AI generation** - Midjourney/DALL-E for concepts
- **Free resources** - OpenGameArt, Kenney.nl

---

## Implementation Notes

- All cosmetics are currently code-defined colors/icons
- Easy to swap in real assets later via `previewAsset` field
- Consider adding asset download system for large packs
- Theme colors are in `lib/models/board_theme.dart`
- Shop UI handles both icons and image assets
