# GamesInfo

## Description

GamesInfo is a Swift-based iOS application built using UIKit that fetches data from the RAWG database, providing users with information about various games. The architecture follows MVVM+C pattern for better separation of concerns and maintainability. 

### Key Features:
- **Programming Language:** Swift
- **UI Framework:** UIKit
- **API:** Utilizes [RAWG API](https://rawg.io/apidocs) for accessing the Games Info Database
- **Local Storage:** CoreData for persistent storage and UserDefaults for lightweight data storage
- **Dark Mode Support:** The app seamlessly transitions between light and dark modes for a comfortable viewing experience
- **Minimum iOS Version:** 17.2

### Implementation Details:
- **API Endpoints:** Endpoint URLs are separated into different environments (Development, Staging, Production) for easier management and testing.
- **Search Feature:** Allows users to search for games, with network requests handled using URLSession and Combine framework for reactive programming.
- **Firebase Integration:** Configuration for Firebase is implemented to support additional features and future expansion.
- **Unit Tests:** Unit tests are implemented for the Network Layer to ensure robustness and reliability.
- **Navigation:** Navigation is managed using the Coordinator pattern for better control flow and decoupling of view controllers.
- **Code Quality:** Linter is used to maintain code quality and adherence to coding standards.
- **Git Flow Strategy:** Git flow strategy is followed to maintain a clean and organized codebase with proper version control.

## Usage

To use the app, follow these steps:

1. Generate an API Key: Obtain an API Key from the RAWG website and add it to the project's configuration as described in the Usage section of this README.

2. Firebase Configuration: If Firebase features are enabled, generate the `GoogleService-Info.plist` file from the Firebase console and add it to the project folder.

3. Screenshots: Screenshots of the application are provided below.

### Screenshots

![Screenshot 1](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/4e6ab32d-f1a7-4e2e-aa1c-f5fdcfb30e1d)
![Screenshot 2](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/acbefac4-151d-4f8f-b7c7-7d42383dcd54)
![Screenshot 3](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/b0c83a29-fcb9-4cb7-8876-675216812a49)
![Screenshot 4](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/ee587558-eb0d-4822-8651-c03de49f3d08)
![Screenshot 5](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/1c56a443-3d99-469e-9276-4b5749c296c0)
![Screenshot 6](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/ae94eff7-40c2-4aa9-b762-eb5fe34b089d)
![Screenshot 7](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/b04deb47-49b8-434b-ae1e-ce2c114b5926)
![Screenshot 8](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/4289595e-ee4a-4b57-820f-4b98006d3f3a)
![Screenshot 9](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/1405a0cc-2053-4416-bc67-e1a3a74ff96f)
![Screenshot 10](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/11512cd4-0794-45a6-a001-13bd94d39bda)
![Screenshot 11](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/0e7295de-6436-4d40-8b26-dcf8bc92f640)
![Screenshot 12](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/8a77de36-c44c-492e-85da-c4c799182523)
![Screenshot 13](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/a70395d3-8624-412c-9227-09d326e33355)
![Screenshot 14](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/009285cc-1de6-4f6d-a3c5-a7539dbbf140)
![Screenshot 15](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/1f5c9540-deba-4256-a9e4-8e95ef65ac39)

## Design Decisions

- **MVVM+C Architecture:** Chosen for its ability to separate concerns, making the codebase more modular, testable, and maintainable.
- **CoreData and UserDefaults:** CoreData is used for managing local storage of complex data structures, while UserDefaults is utilized for lightweight data storage such as user preferences.
- **Combine Framework:** Utilized for reactive programming and handling asynchronous events in a more streamlined manner.
- **Coordinator Pattern:** Implemented for navigation to decouple view controllers and centralize navigation logic.
- **Firebase Integration:** Included to leverage additional features such as analytics, crash reporting, and cloud messaging for better user engagement and monitoring.
  
By following these design decisions, the application achieves a balance between functionality, maintainability, and performance, providing users with a seamless and enjoyable experience while ensuring ease of development and future scalability.


