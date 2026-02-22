# M&M Property Tycoon 🏠🎲

A fun, family-friendly board game for tablets inspired by classic property trading games.

## Features

- **2-4 Players** - Play with family and friends on a single device
- **AI Opponents** - Practice against computer players
- **6 Countries, 18 Cities** - Play on real-world city boards:
  - 🇺🇸 USA — Atlantic City, New York, Los Angeles
  - 🇬🇧 UK — London, Edinburgh, Manchester
  - 🇫🇷 France — Paris, Lyon, Marseille
  - 🇯🇵 Japan — Tokyo, Osaka, Kyoto
  - 🇨🇳 China — Beijing, Shanghai, Hong Kong
  - 🇲🇽 Mexico — Mexico City, Guadalajara, Cancún
- **Power-Up Cards** - Special abilities to shake up the game
- **Mini Games** - Quick challenges to earn extra cash
- **17 Languages** - Full localization support
- **Custom Avatars** - Take photos or choose from presets

## Screenshots

Coming soon...

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or later
- Dart SDK (included with Flutter)

### Installation

```bash
# Clone the repository
git clone https://github.com/hao6yu/mm-monopoly.git

# Navigate to project directory
cd mm-monopoly

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Building for Release

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
```

## Game Rules

1. **Roll the dice** to move around the board
2. **Buy properties** you land on
3. **Collect rent** when others land on your properties
4. **Build houses** to increase rent
5. **Trade** with other players (optional)
6. **Win** by being the last player with money!

## Settings

- **Starting Cash** - $500 to $3000
- **Player Trading** - Enable/disable trades
- **Bank Features** - Sell properties back to bank
- **Property Auctions** - Auction unclaimed properties

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **audioplayers** - Background music and sound effects
- **shared_preferences** - Local data persistence

## Project Structure

```
lib/
├── config/          # Theme, board configurations
├── models/          # Game state, players, properties
├── screens/         # UI screens
├── services/        # Audio, unlocks, persistence
└── widgets/         # Reusable UI components
```

## Contributing

This is a personal project, but suggestions are welcome!

## License

Private - All rights reserved

## Support

If you enjoy the game, consider buying me a coffee! ☕

[Buy Me a Coffee](https://buymeacoffee.com/hao_yu)
