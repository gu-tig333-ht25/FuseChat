# FuseChat 💬  
*A Group Chat App with AI-Powered Reply Suggestions*

FuseChat is a Flutter-based mobile application that brings a creative twist to group messaging.  
Users can chat in real time while receiving AI-generated message suggestions based on a configurable personality — such as **factual**, **mischievous**, or **supportive**.  
Written as a group project for the course "Mobile app development with Flutter" at GU.

The app explores how large language models (LLMs) can enhance and enrich human-to-human conversations.

---

## Features

- **Group chat support** with real-time updates via Firebase Firestore database 
- **AI-powered message suggestions** using the flutter_gemini package  
- **Customizable AI personalities** (e.g., factual, mischievous, supportive)  
- **Firebase Authentication** for secure login and signup  
- **Modern dark theme** configured by a theme file 
- **Persistent settings** storing the Gemini API-key in shared preferences

---

## Usage

1. Register a user and log in
2. To enable AI-suggestions, create your own Gemini API-key at https://aistudio.google.com/app/api-keys 
3. From the conversation screen, navigate to profile --> AI settings and enter the API-key and desired personality.
3. Join a group chat on the conversation screen
4. Have fun!  

---

## Firebase

The app depends on a Firebase account. If the original account is not available in the future,
or if you want to make your own version of the app, you need to set up Firebase.
Create a Firebase account, enable authentication, and enable Cloud Firestore. 

---

## Screenshots

<img src='/assets/screenshots/Login.png?raw=true' width='50%' alt="Login" />

![Login screen](/assets/screenshots/Login.png?raw=true "Login")

![Conversations screen](/assets/screenshots/Convos.png?raw=true "Conversations")

![Chat screen](/assets/screenshots/Chat.png?raw=true "Chat")

![AI Configuration screen](/assets/screenshots/AIconf.png?raw=true "AI Configuration")
