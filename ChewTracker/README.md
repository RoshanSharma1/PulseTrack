# ChewTracker - Apple Watch Chewing Behavior Tracking App

## Project Overview
ChewTracker is an Apple Watch application that tracks a user's chewing behavior during meals using motion, sound, and accelerometer data. The app aims to help users:
- Improve mindful eating habits
- Avoid overeating
- Identify patterns related to digestion and nutrition

The app leverages watchOS sensor APIs, machine learning models, and optional iPhone integration for data visualization.

## Goals & Objectives

### Primary Goals
- Detect and record chewing events in real-time
- Provide haptic feedback when chewing speed exceeds a threshold
- Display chewing statistics for each meal

### Secondary Goals
- Store daily, weekly, and monthly chewing summaries
- Integrate with Apple HealthKit for calorie and meal tracking
- Allow users to log food items manually

## Core Features

### Real-time Chewing Detection
- Use Apple Watch accelerometer and gyroscope to detect jaw movement
- Apply Core ML chewing recognition model

### Haptic Feedback Alerts
- Notify when chewing too fast or skipping chewing (based on threshold)

### Session Tracking
- Start/stop meal session from the watch
- Store:
  - Chews per minute (CPM)
  - Total chews per meal
  - Average chewing duration

### Insights & Trends
- Weekly and monthly trends on iPhone app
- Goal tracking (e.g., 30 chews per bite)

## Technical Requirements

### Hardware
- Apple Watch Series 4+ (for accurate motion sensing)
- Optional iPhone (for extended analytics)

### Software & SDKs
- watchOS 10+
- iOS 17+ (for paired app)
- Xcode 15
- SwiftUI for UI
- Core Motion for sensor data
- Core ML for chewing pattern classification
- HealthKit for health data integration
- CloudKit or local Core Data for storage

## Data Flow
```
Apple Watch Sensors → Motion Data Processing → ML Chewing Detection Model
→ Session Tracker → Local Storage (Core Data) → Optional Sync to iPhone App
```

## Architecture
### Watch App
- View Layer: SwiftUI for meal session controls and live chewing stats
- Motion Manager: Captures accelerometer & gyroscope data
- ML Manager: Runs Core ML chewing detection model
- Session Manager: Tracks stats and stores locally
- Haptic Manager: Sends feedback alerts

