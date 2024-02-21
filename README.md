# GamesInfo

## Description

Programing Language: swift.  
UI Framework: UIKit  
API: [RAWG API](https://rawg.io/apidocs) for utilizing Games Info Database  
Architecture: MVVM+C  
Local Storage: CoreData, UserDefaults  

App Supports Dark Mode

Minimum iOS Version 17.2  

API EndPoints separeated to different environments as Dev, Stage, Prod  

Search Feature with call requests
URLSessions + Combine  
Firebase configuration

## Usage

App Usage required to generate API Key in Configuration add Property List file with key rawgApiKey and value with your API Secret Key from the api web site
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>rawgApiKey</key>
	<string>your apiKey</string>
</dict>
</plist>
```

Usage Firebase it needs to generate in firebase console `GoogleService-Info.plist` file and paste into the project folder
 
### ScreenShots

![Screenshot 2024-02-21 at 19 53 15](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/4e6ab32d-f1a7-4e2e-aa1c-f5fdcfb30e1d)
![Screenshot 2024-02-21 at 19 53 07](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/acbefac4-151d-4f8f-b7c7-7d42383dcd54)
![Screenshot 2024-02-21 at 19 52 59](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/b0c83a29-fcb9-4cb7-8876-675216812a49)
![Screenshot 2024-02-21 at 19 52 52](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/ee587558-eb0d-4822-8651-c03de49f3d08)
![Screenshot 2024-02-21 at 19 52 41](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/1c56a443-3d99-469e-9276-4b5749c296c0)
![Screenshot 2024-02-21 at 19 52 35](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/ae94eff7-40c2-4aa9-b762-eb5fe34b089d)
![Screenshot 2024-02-21 at 19 52 15](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/b04deb47-49b8-434b-ae1e-ce2c114b5926)
![Screenshot 2024-02-21 at 19 52 08](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/4289595e-ee4a-4b57-820f-4b98006d3f3a)
![Screenshot 2024-02-21 at 19 51 22](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/1405a0cc-2053-4416-bc67-e1a3a74ff96f)
![Screenshot 2024-02-21 at 19 50 55](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/11512cd4-0794-45a6-a001-13bd94d39bda)
![Screenshot 2024-02-21 at 19 49 46](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/0e7295de-6436-4d40-8b26-dcf8bc92f640)
![Screenshot 2024-02-21 at 19 48 56](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/8a77de36-c44c-492e-85da-c4c799182523)
![Screenshot 2024-02-21 at 19 48 50](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/a70395d3-8624-412c-9227-09d326e33355)
![Screenshot 2024-02-21 at 19 48 36](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/009285cc-1de6-4f6d-a3c5-a7539dbbf140)
![Screenshot 2024-02-21 at 19 46 48](https://github.com/OleksiiMykhalchuk/GamesInfo/assets/96618926/1f5c9540-deba-4256-a9e4-8e95ef65ac39)





