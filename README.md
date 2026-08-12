# TaskFlow — Flutter To-Do App

A clean, simple, and responsive To-Do application built with **Flutter and Dart** as part of a Flutter Developer Intern technical assignment.

TaskFlow allows users to create, manage, complete, filter, and delete daily tasks through a simple and intuitive interface.

---

##  Features

 Add new tasks
 View all tasks in a clean list
 Mark tasks as completed or uncompleted
 Delete tasks
 Undo recently deleted tasks
 Swipe left to delete a task
 Filter tasks by:

 All
 Active
 Completed
 Clear completed tasks
 View task statistics:

Total
Pending
Completed
 Friendly empty state when there are no tasks
 Responsive Material 3 UI
 Local in-memory task management
 No backend or API dependency

---

##  Tech Stack

 **Flutter** — Application framework
 **Dart** — Programming language
 **Material 3** — UI and theming
 **StatefulWidget & setState()** — Local state management
 **ListView.builder** — Dynamic task list

### Packages Used

No third-party packages are required for this application.

The app uses Flutter's built-in widgets and Dart functionality.

---

##  Project Structure

lib/
├── main.dart
├── task.dart
├── todo_screen.dart
└── widgets/
    ├── task_card.dart
    └── empty_task_view.dart
### Folder Responsibilities

**models/**
Contains the data model used by the application.

**screens/**
Contains the main screen and screen-level state management.

**widgets/**
Contains reusable UI components such as task cards and the empty state.

The project structure is intentionally lightweight and focuses on keeping the code readable and maintainable without unnecessary complexity.

---

##  Getting Started

### Prerequisites

Make sure you have the following installed:

 Flutter SDK
 Dart SDK included with Flutter
 Android Studio or VS Code
 Android emulator or physical Android device

Check your Flutter installation:

```bash
flutter doctor
```

---

##  Installation

Clone the repository:

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Navigate to the project directory:

```bash
cd todo_app
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

##  Build APK

To generate a release APK for testing:

```bash
flutter build apk --release
```

The generated APK will be available at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

##  Application Flow

App Launch
    ↓
TaskFlow Home Screen
    ↓
Add / Manage Tasks
    ↓
├── Add Task
├── Complete / Uncomplete
├── Filter (All / Active / Completed)
└── Delete / Undo
---

## 💡 State Management

The application uses Flutter's built-in `StatefulWidget` and `setState()` for local state management.

Since the assignment does not require a backend or persistent storage, tasks are maintained in memory using a local Dart `List`.

This keeps the implementation simple and appropriate for the scope of the assignment.

> **Note:** Tasks will reset when the application is restarted because no persistent database or backend is used.

---

#  Technical Questions

## 1. What is the difference between StatelessWidget and StatefulWidget?

A `StatelessWidget` does not maintain mutable state, so its UI is based on the values provided to it. A `StatefulWidget` can maintain changing state through its associated `State` object and rebuild its UI when that state changes.

---

## 2. What is setState() used for in Flutter?

`setState()` is used to notify Flutter that the state of a `StatefulWidget` has changed. Flutter then rebuilds the affected part of the widget tree so the updated data is reflected in the UI.

---

## 3. What is the difference between ListView and Column?

`Column` arranges its children vertically but does not provide scrolling by itself. `ListView` is designed for displaying scrollable lists and is more suitable when working with a dynamic or large number of items.

---

## 4. How would you handle an API call in Flutter?

I would separate API communication into a service or repository layer and use an HTTP client such as the `http` package. I would handle loading, success, and error states and then update the UI based on the API response.

---

## 5. What is the purpose of pubspec.yaml?

`pubspec.yaml` contains important Flutter project configuration such as the project name, version, Dart/Flutter SDK constraints, dependencies, assets, and other project metadata.

---

## 6. Which Flutter project or feature have you worked on that you are most proud of, and what was your contribution?

I am most proud of working on the **Hungzo Delivery App**. I contributed to Flutter application development, including UI implementation, application features, API integration, debugging, testing, and preparing the application for deployment.

---

##  Testing Checklist

Before submitting the application, the following flows should be tested:

 Add a new task
 Add multiple tasks
 Complete a task
 Uncomplete a task
 Delete a task
 Undo a deleted task
 Swipe left to delete
 Filter tasks using All, Active, and Completed
 Clear completed tasks
 Verify the empty state
 Submit a task using the keyboard
 Run the application on an Android emulator or physical device

---

##  Flutter Version

Add the exact Flutter version used for this submission.

Check the installed version using:

```bash
flutter --version
```

Example:

```text
Flutter 3.x.x
Dart 3.x.x
```

---

## Dependencies

This project does not require any third-party packages.

All functionality is implemented using Flutter's built-in widgets and Dart's standard features.

---

##  Project Notes

 Task data is stored locally in memory.
 Tasks reset when the application is restarted.
 No backend or API is required.
 No authentication or database is required.
 The application focuses on clean UI, readable code, and the core requirements of the assignment.
 Additional usability features such as filtering, undo delete, swipe delete, and task statistics were added while keeping the implementation simple.

---

##  Author

**Ujjawal Yadav**
Flutter Developer
Built with Flutter & Dart.
