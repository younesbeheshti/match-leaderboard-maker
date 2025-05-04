# Match Leaderboard Maker

A Flutter application for creating and managing tournament leaderboards with support for both single and double elimination brackets.

## Features

- Create tournament brackets with up to 16 players
- Support for both single and double elimination formats
- Player seeding and shuffling options
- Save and manage player information
- Modern and intuitive user interface

## Getting Started

### Prerequisites

- Flutter SDK (version >=3.3.4)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/match_leaderboard_maker.git
```

2. Navigate to the project directory:
```bash
cd match_leaderboard_maker
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## Dependencies

- `get: ^4.6.6` - State management and navigation
- `flutter_svg: ^2.0.10+1` - SVG image support
- `provider: ^6.1.2` - State management
- `image_gallery_saver: ^2.0.3` - Save images to gallery
- `path_provider: ^2.1.4` - File system operations

## Project Structure

```
lib/
├── components/     # Reusable UI components
├── pages/         # Application screens
├── provider/      # State management
└── main.dart      # Application entry point
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors and users of this project
