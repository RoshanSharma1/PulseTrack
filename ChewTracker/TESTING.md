# ChewTracker Testing Instructions

This document provides instructions for testing the ChewTracker application on both Apple Watch and iPhone.

## Prerequisites

- Apple Watch Series 4 or newer (for optimal sensor performance)
- iPhone paired with the Apple Watch
- Xcode 15 or newer
- iOS 17+ and watchOS 10+

## Setup

1. Clone the repository
2. Open `ChewTracker.xcodeproj` in Xcode
3. Select your development team in the project settings
4. Build and run the Watch app on your Apple Watch
5. Build and run the iOS app on your iPhone

## Testing the Watch App

### Basic Functionality Testing

1. **Launch the App**
   - Verify the app launches correctly
   - Check that the start screen appears with "Start Meal" button

2. **Start a Meal Session**
   - Tap "Start Meal"
   - Verify the meal session screen appears
   - Check that the timer starts counting

3. **Chewing Detection**
   - During a meal, chew normally
   - Verify that the chew counter increases
   - Note: In this prototype, the chewing detection is simulated. In a real implementation, it would use the accelerometer and gyroscope data.

4. **Haptic Feedback**
   - Chew rapidly to exceed the threshold
   - Verify that haptic feedback is provided

5. **End a Meal Session**
   - Tap "End Meal"
   - Verify that the session ends and returns to the start screen
   - Check that the meal is saved to history

6. **View History**
   - Tap "View History"
   - Verify that the history screen shows the recorded meal
   - Tap on a meal to view details
   - Verify that the meal details are displayed correctly

7. **Settings**
   - Tap "Settings"
   - Verify that settings can be adjusted
   - Change the chewing threshold and verify it affects the haptic feedback

### Simulating Chewing for Testing

Since the actual ML model for chewing detection is not implemented in this prototype, you can simulate chewing by:

1. During a meal session, gently move your wrist in a rhythmic pattern
2. The app will interpret certain motion patterns as chewing
3. For more realistic testing, actually eat a meal while wearing the watch

## Testing the iOS App

1. **Dashboard**
   - Verify that the dashboard shows summary statistics
   - Check that the weekly trends chart is displayed
   - Verify that recent meals are listed

2. **History**
   - Navigate to the History tab
   - Verify that all recorded meals are displayed
   - Test the time frame filter (Day, Week, Month, All)
   - Tap on a meal to view details
   - Verify that the meal details screen shows all statistics

3. **Settings**
   - Navigate to the Settings tab
   - Adjust various settings and verify they are saved
   - Test the Health integration toggle
   - Verify that the data management options are functional

## Known Limitations in Prototype

1. **Chewing Detection**: The current implementation uses a simplified detection algorithm rather than a trained ML model.
2. **Data Persistence**: Data is stored in UserDefaults rather than Core Data or CloudKit.
3. **Health Integration**: HealthKit integration is simulated and not fully implemented.
4. **Synchronization**: Watch and iPhone data synchronization is not fully implemented.

## Reporting Issues

When reporting issues, please include:
- Device model (Watch and iPhone)
- OS versions
- Steps to reproduce the issue
- Expected vs. actual behavior
- Screenshots or videos if applicable

