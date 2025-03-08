🎬 MovieMate
A Flutter-based Movie Review & Discovery App with Firebase integration. MovieMate allows users to explore movies, read reviews, and manage their watchlist, all with a sleek UI.


📌 Features
✅ Movie Discovery – Browse trending & popular movies using the TMDb API.
✅ Movie Details – View cast, trailers, and detailed movie descriptions.
✅ User Reviews – Read & submit reviews for movies.
✅ Watchlist & Favorites – Save movies for later viewing.
✅ Firebase Authentication – Sign in with Google & Email/Password.
✅ Dark Mode Support – Seamless light/dark theme transition.
✅ Smooth Animations – Interactive UI elements with animations.

🛠️ Tech Stack
Framework: Flutter (Dart)
State Management: Riverpod / GetX
Backend: Firebase (Authentication & Firestore)
API: The Movie Database (TMDb) API
Database: SQLite (Offline Mode)
Other Tools: Firebase Cloud Messaging (Push Notifications), Lottie Animations

📸 Screenshots

![1](https://github.com/user-attachments/assets/74063b35-22fd-4381-b1d1-36ade042650d)
![2](https://github.com/user-attachments/assets/815b52c0-b8ab-493f-bf10-a6cf3b85f711)

![3](https://github.com/user-attachments/assets/b799d22a-3231-4226-aabc-fb3dc42d1691)
![4](https://github.com/user-attachments/assets/c395e4a2-e931-4997-aefd-65807c5fef43)
![5](https://github.com/user-attachments/assets/d80546b1-e65c-4ea9-b7be-b558ac690bfb)
![6](https://github.com/user-attachments/assets/bc5de773-6f98-4a40-804b-785b7787cbd9)
![8](https://github.com/user-attachments/assets/8e6797be-a931-4276-958d-bb59eb4953e0)



🚀 Installation Guide
1️⃣ Prerequisites
Before running the project, ensure you have:
✅ Flutter installed (Get Flutter)
✅ A Firebase project set up (Firebase Console)
✅ TMDb API Key (Get API Key)

2️⃣ Clone the Repository
sh
Copy
Edit
git clone https://github.com/Osama-Yaseen/MovieMate.git
cd MovieMate
3️⃣ Add Firebase Configuration
Android: Place your google-services.json in android/app/.
iOS: Place GoogleService-Info.plist in ios/Runner/.
4️⃣ Run the App
sh
Copy
Edit
flutter pub get
flutter run
🛠 Environment Variables
Store sensitive credentials in a .env file to avoid exposing them in public repositories:

ini
Copy
Edit
TMDB_API_KEY=your_tmdb_api_key
FIREBASE_API_KEY=your_firebase_api_key
Then, load them in your code:

dart
Copy
Edit
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
}
📦 Project Structure
css
Copy
Edit
movie_mate/
│── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── movie_details_screen.dart
│   │   ├── watchlist_screen.dart
│   ├── widgets/
│   │   ├── movie_card.dart
│   │   ├── rating_stars.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   ├── models/
│   │   ├── movie_model.dart
│   │   ├── user_model.dart
This structure follows best practices for separating UI, services, and models.

🛠 API Integration
This app fetches real-time movie data using The Movie Database (TMDb) API. Example request:

dart
Copy
Edit
final response = await http.get(
  Uri.parse("https://api.themoviedb.org/3/movie/popular?api_key=$apiKey"),
);
🔗 TMDb API Docs: https://developers.themoviedb.org/3

🔐 Security Measures
API Keys Hidden – Using .env files instead of hardcoding keys.
Firebase Security Rules – Read/Write rules restricted to authenticated users.
GitHub .gitignore – Sensitive files (google-services.json, .env) are ignored.
📜 License
This project is MIT licensed, meaning you’re free to use and modify it.

🤝 Contributing
Want to improve MovieMate? Follow these steps:

Fork the repo
Create a branch: git checkout -b feature-xyz
Commit changes: git commit -m "Added XYZ feature"
Push: git push origin feature-xyz
Submit a pull request
📞 Contact
💡 Developed by: Osama Yasin
📧 Email: osama.shehdeh.yaseen@gmail.com
🔗 LinkedIn: linkedin.com/in/osamayasin
🔗 GitHub: github.com/Osama-Yaseen
