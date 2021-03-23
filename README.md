# Expense Tracker
**Created by Gregory Conrad**

## Description
A simple personal finance expense tracker built with Flutter that uses Firebase as the back end.
Specifically, Firebase Authentication and Firestore are used.

## Purpose
I created this project for my own personal use, but due to its simple nature,
it serves as good reference/example code for using Flutter with Firebase.
Thus, if you are new to Flutter/Firebase and are looking for a well-structured example, dive in!
You can easily take the concepts used in this application and apply it to a much more complex application.

## State Management
State management is handled exclusively via Firebase (it is very powerful!) in this project.

This application is nothing fancy and did not require any complex state management;
it simply shows your expenses and adds them up.
However, if I needed additional complexity, I would have also used (as needed):
- [GetIt](https://pub.dev/packages/get_it): Great if you have ever used DI in the past
  - Note: The data_repository and auth_repository dart files in this project were meant to be abstracted with GetIt, but I did not for simplicity
- [RxDart](https://pub.dev/packages/rxdart): Lots of useful extensions, but `BehaviorSubject`s are why I love Rx so much
- [Provider](https://pub.dev/packages/provider): For when you need multiple children (all within a certain scope) reacting to the same state data
  - Note: For application-level state, I prefer GetIt
- [Bloc](https://pub.dev/packages/flutter_bloc): For very predictable and easy to test state management that excels in complex scenarios that are well-modeled with a state machine
  - Note: I typically find Bloc to be overkill (lots of boilerplate), but it has its place in specific situations
- [Flutter Hooks](https://pub.dev/packages/flutter_hooks): Although I have not personally tried this library, the concept (borrowed from React) is great

## Continuous Deployment
This project also automates deployment to Firebase Hosting on pushes to master through GitHub Actions.
If you are looking for CD with Flutter, see [deploy.yml](.github/workflows/deploy.yml) for a starting point.
