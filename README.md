# PulseTrack - Apple Watch Motion Tracking Apps

This repository contains Apple Watch applications for tracking various motion-based activities.

## Projects

### ChewTracker

ChewTracker is an Apple Watch application that tracks a user's chewing behavior during meals using motion, sound, and accelerometer data. The app aims to help users improve mindful eating habits, avoid overeating, and identify patterns related to digestion and nutrition.

[View ChewTracker Project](./ChewTracker/README.md)

#### Key Features:
- Real-time chewing detection using Apple Watch sensors
- Haptic feedback for mindful eating pace
- Meal session tracking with detailed statistics
- iOS companion app for data visualization and trends
- HealthKit integration

#### Technical Stack:
- SwiftUI for UI
- Core Motion for sensor data
- Core ML for chewing pattern classification
- HealthKit for health data integration
- CloudKit/Core Data for storage

## Development

Each project is organized as a separate Xcode project with both watchOS and iOS targets.

### Requirements
- Xcode 15+
- watchOS 10+
- iOS 17+
- Apple Watch Series 4 or newer (for optimal sensor performance)

### Getting Started
1. Clone this repository
2. Open the desired project folder in Xcode
3. Build and run on your devices or simulators

## Testing

Instructions for testing each application are provided in their respective project folders.

