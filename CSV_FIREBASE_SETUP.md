# CSV to Firebase Search Setup Guide

This guide explains how to set up and use the CSV-based city and court search functionality with Firebase backend.

## 🎯 Overview

The application now includes:
- **Searchable city dropdown** - Search from Firebase-backed city data
- **Searchable court dropdown** - Search from Firebase-backed court data with city filtering
- **CSV upload tools** - Upload CSV data to Firebase from command line
- **Real-time search** - Search results update as user types

## 📁 Project Structure

```
lib/
├── model/
│   ├── city_model.dart          # City data model
│   └── court_model.dart         # Court data model
├── utils/
│   ├── csv_data_service.dart    # CSV parsing (backup/local use)
│   └── firebase_csv_service.dart # Firebase search operations
├── app/
│   ├── widgets/
│   │   ├── searchable_city_dropdown.dart  # City search widget
│   │   └── searchable_court_dropdown.dart # Court search widget
│   └── information_steps/
│       └── personal_info_screen.dart      # Updated form screen
├── controller/
│   └── information_controller.dart        # Enhanced with search logic
tools/
├── upload_csv_to_firebase.dart   # Upload script
├── upload_csv.sh                 # Shell script wrapper
└── README.md                     # Upload tools documentation
assets/
└── csv/
    ├── Courts.csv               # Court data
    └── States+city.csv          # City data
```

## 🚀 Quick Start

### Step 1: Upload CSV Data to Firebase

Choose one of these methods:

**Option A: Using Shell Script (Mac/Linux/WSL)**
```bash
./tools/upload_csv.sh
```

**Option B: Using Dart Command (Windows/All)**
```bash
dart run tools/upload_csv_to_firebase.dart
```

### Step 2: Run Your App

```bash
flutter run
```

The search functionality will now work with Firebase data!

## 🔧 Technical Details

### Data Models

**City Model (`city_model.dart`)**
```dart
class City {
  final String state;
  final String city;
  
  // Includes CSV parsing and JSON serialization
}
```

**Court Model (`court_model.dart`)**
```dart
class Court {
  final String courtName;
  final String state;
  final String city;
  
  // Includes CSV parsing and JSON serialization
}
```

### Search Widgets

**SearchableCityDropdown**
- Real-time search as user types
- Dropdown overlay with results
- Automatic text field management
- Form validation integration

**SearchableCourtDropdown**
- Same features as city dropdown
- Additional filtering by selected city
- Smart city-court relationship handling

### Firebase Collections

The upload script creates two Firestore collections:

1. **`cities`** - City and state data
   ```json
   {
     "state": "Maharashtra",
     "city": "Mumbai"
   }
   ```

2. **`courts`** - Court, city, and state data
   ```json
   {
     "courtName": "High Court of Mumbai",
     "state": "Maharashtra", 
     "city": "Mumbai"
   }
   ```

## 🎨 UI Integration

### Form Usage Example

```dart
// City Selection
SearchableCityDropdown(
  selectedCity: controller.selectedCity.value,
  onCitySelected: controller.onCitySelected,
  decoration: InputDecoration(
    hintText: 'Search for your city...',
    // ... styling
  ),
)

// Court Selection (with city filtering)
SearchableCourtDropdown(
  selectedCourt: controller.selectedCourt.value,
  onCourtSelected: controller.onCourtSelected,
  filterByCity: controller.selectedCity.value?.city,
  decoration: InputDecoration(
    hintText: 'Search for a court...',
    // ... styling
  ),
)
```

### Controller Integration

```dart
class InformationController extends GetxController {
  Rx<City?> selectedCity = Rx<City?>(null);
  Rx<Court?> selectedCourt = Rx<Court?>(null);
  
  void onCitySelected(City? city) {
    selectedCity.value = city;
    // Clear court selection when city changes
    selectedCourt.value = null;
  }
  
  void onCourtSelected(Court? court) {
    selectedCourt.value = court;
    // Auto-select city if court is selected
    if (selectedCity.value == null && court != null) {
      selectedCity.value = City(state: court.state, city: court.city);
    }
  }
}
```

## 📊 CSV Data Format

### Cities CSV (States+city.csv)
```csv
State,City
Maharashtra,Mumbai
Maharashtra,Pune
Delhi,New Delhi
Karnataka,Bangalore
```

### Courts CSV (Courts.csv)
```csv
Court Name,State,City
High Court of Mumbai,Maharashtra,Mumbai
District Court Pune,Maharashtra,Pune
Delhi High Court,Delhi,New Delhi
Karnataka High Court,Karnataka,Bangalore
```

## 🔒 Firebase Security Rules

Make sure your Firestore security rules allow reading the collections:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow reading cities and courts
    match /cities/{document} {
      allow read: if true;
    }
    
    match /courts/{document} {
      allow read: if true;
    }
  }
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Search returns no results**
   - Check if CSV data was uploaded successfully
   - Verify Firebase collections exist in console
   - Check internet connection

2. **Upload script fails**
   - Ensure Firebase is properly configured
   - Check `firebase_options.dart` exists
   - Verify CSV files are in correct location

3. **Dropdown not showing**
   - Check console for error messages
   - Verify widget is wrapped in `Obx()` for reactivity
   - Ensure controller methods are called correctly

### Verification Steps

1. **Check Firebase Console**
   - Go to Firestore Database
   - Verify `cities` and `courts` collections exist
   - Check sample documents

2. **Test Search**
   - Type in search field
   - Verify dropdown appears
   - Check results are relevant

## 🔄 Updating Data

To update CSV data:

1. Update your CSV files in `assets/csv/`
2. Run the upload script again:
   ```bash
   dart run tools/upload_csv_to_firebase.dart
   ```
3. The script will clear existing data and upload new data

## 📈 Performance Considerations

- **Caching**: Firebase results are cached locally during app session
- **Batch Operations**: Upload script uses batch writes for efficiency
- **Search Limits**: Results are limited to 10 items per dropdown
- **Debouncing**: Search has built-in debouncing for better UX

## 🎯 Features

✅ **Real-time search** - Results update as user types  
✅ **City-Court filtering** - Courts filtered by selected city  
✅ **Form validation** - Integrated with Flutter form validation  
✅ **Error handling** - Graceful handling of network/data errors  
✅ **Loading states** - Visual feedback during search  
✅ **Responsive UI** - Works on all screen sizes  
✅ **Offline support** - Local CSV fallback (if needed)  
✅ **Batch upload** - Efficient data upload to Firebase  

## 🤝 Support

If you encounter any issues:
1. Check the console output for error messages
2. Verify your Firebase configuration
3. Ensure CSV files are properly formatted
4. Check your internet connection
5. Review the `tools/README.md` for upload-specific issues

---

**Happy Coding! 🎉** 