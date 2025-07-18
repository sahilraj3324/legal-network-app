# Legal Network Mobile App

A comprehensive legal management platform built with Flutter for iOS and Android.

## Features

- **Onboarding Experience**: Beautiful 3-screen onboarding with smooth transitions
- **Dashboard**: Overview of cases, documents, and recent activity
- **Case Management**: Track and manage legal cases
- **Document Management**: Upload, organize, and access legal documents
- **Professional Network**: Connect with legal professionals
- **User Profile**: Manage personal and professional information

## iOS Setup

This project has been configured for iOS development with the following specifications:

### iOS Configuration Details

- **App Name**: Legal Network
- **Bundle Identifier**: `com.legalnetwork.leagel`
- **Deployment Target**: iOS 13.0+
- **Supported Devices**: iPhone and iPad

### iOS Permissions

The app includes the following iOS permissions for enhanced functionality:

- **Camera**: For document scanning and evidence capture
- **Microphone**: For voice notes and audio evidence
- **Photo Library**: For attaching images and documents
- **Location**: For location-based legal services
- **Contacts**: For sharing legal documents with clients
- **Calendar**: For scheduling legal appointments

### Building for iOS

To build and run the iOS app:

1. **Requirements**:
   - macOS with Xcode installed
   - iOS Simulator or physical iOS device
   - Apple Developer account (for device testing)

2. **Build Commands**:
   ```bash
   # Clean the project
   flutter clean
   
   # Get dependencies
   flutter pub get
   
   # Run on iOS simulator
   flutter run -d ios
   
   # Build for iOS device
   flutter build ios
   ```

3. **Xcode Configuration**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Configure signing and capabilities
   - Set up provisioning profiles for device deployment

## Development Setup

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- iOS development requires macOS and Xcode

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

### Onboarding Screens

The app features 3 beautifully designed onboarding screens with:

- **Gradient Background**: White to #BDEFFF gradient
- **Instrument Sans Font**: Professional typography via Google Fonts
- **Gradient Text**: Heading text with #51D5FF to #000000 gradient
- **Smooth Transitions**: Seamless page navigation with 300ms animations
- **Responsive Design**: Adapts to different screen sizes
- **Page Indicators**: Visual progress indicators
- **Call-to-Action**: Continue button that transforms to "Get Started" on final screen

To customize the onboarding screens:
1. Update content in `lib/onboarding_screen.dart`
2. Replace placeholder images in `assets/images/`
3. Modify colors, fonts, or layout as needed

### Project Structure

```
lib/
├── main.dart              # Main application entry point
├── pages/                 # Individual page implementations
├── widgets/               # Reusable UI components
├── models/                # Data models
├── services/              # API and business logic
└── utils/                 # Utility functions
```

## Legal Network Features

### Dashboard
- Quick actions for common tasks
- Recent activity overview
- Case status summary
- Document access

### Case Management
- Create and track legal cases
- Case timeline and updates
- Client information management
- Document associations

### Document Management
- Secure document storage
- OCR for document scanning
- Document categorization
- Version control

### Professional Network
- Connect with colleagues
- Share case insights
- Professional messaging
- Referral system

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please contact the development team.
# legal-network-app
