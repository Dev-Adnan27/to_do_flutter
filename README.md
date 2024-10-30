# Flutter To-Do Application

A modern, cross-platform to-do list application built with Flutter and Firebase. This application allows users to create, manage, and organize their daily tasks with a clean and intuitive interface.

## Features

- ✨ Create new tasks
- 🗑️ Delete completed tasks
- 🔄 Real-time updates using Firebase
- 📱 Cross-platform support (iOS, Android, Web, Desktop)
- 🎨 Clean and intuitive Material Design interface

## Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter](https://flutter.dev/docs/get-started/install) (SDK version ^3.5.3)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- [Git](https://git-scm.com/)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Dev-Adnan27/to_do_flutter.git
cd to_do_flutter
```
2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add your Firebase configuration files:
     - For Android: `google-services.json` in `android/app/`
     - For iOS: `GoogleService-Info.plist` in `ios/Runner/`
     - For Web: Update the Firebase configuration in `web/index.html`

4. Run the application:
```bash
flutter run
```

## Project Structure

```
to_do/
├── lib/               # Main application code
├── android/           # Android-specific files
├── ios/              # iOS-specific files
├── web/              # Web-specific files
├── windows/          # Windows-specific files
├── linux/            # Linux-specific files
├── macos/            # macOS-specific files
└── test/             # Test files
```

## Dependencies

The project uses the following main dependencies:

- `firebase_core: ^3.6.0` - Firebase Core functionality
- `cloud_firestore: ^5.4.4` - Cloud Firestore for data storage
- `cupertino_icons: ^1.0.8` - iOS-style icons
- `flutter_lints: ^4.0.0` - Recommended lints for Flutter apps

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter Team for the amazing framework
- Firebase for the backend infrastructure
- The Flutter community for their continuous support

## Support

If you find any bugs or have feature requests, please create an issue in the GitHub repository.

## Contact

Your Name - Adnan 

Email - devadnan27@gmail.com

Project Link: [https://github.com/Dev-Adnan27/to_do_flutter](https://github.com/Dev-Adnan27/to_do_flutter)