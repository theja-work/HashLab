# 🔐 Hashing Demo

A complete authentication demo application built using **SwiftUI**, **MVVM**, and a **Python Flask** backend to demonstrate secure login and signup workflows.

This project was created as a hands-on learning exercise to understand the complete authentication flow between an iOS application and a backend server, while following clean architecture principles and asynchronous networking.

---

# 📱 Demo

The application currently supports:

- ✅ User Registration (Signup)
- ✅ User Login
- ✅ Password Hashing before storage
- ✅ Local Flask Backend
- ✅ JSON based REST APIs
- ✅ SwiftUI MVVM Architecture
- ✅ Async/Await Networking
- ✅ Error Handling
- ✅ Input Validation

---

# 🏗️ Architecture

```
                SwiftUI View
                     │
                     ▼
              LoginViewModel
                     │
                     ▼
               AuthService
                     │
                     ▼
              URLSession API
                     │
                     ▼
          Python Flask Backend
                     │
                     ▼
              JSON Response
                     │
                     ▼
              SwiftUI Updates
```

The project follows the MVVM architecture to separate business logic from presentation logic.

| Layer | Responsibility |
|--------|---------------|
| View | Displays UI and handles user interaction |
| ViewModel | Business logic and state management |
| Service | API communication |
| Backend | Authentication and user management |

---

# 🚀 Tech Stack

### iOS

- Swift 6
- SwiftUI
- MVVM
- URLSession
- Async/Await

### Backend

- Python
- Flask
- REST APIs
- JSON
- Password Hashing

---

# 📂 Project Structure

```
Hashing-Demo
│
├── SwiftUISample/
│   ├── Models
│   ├── Views
│   ├── ViewModels
│   ├── Services
│   └── Resources
│
├── SwiftUI_backend_support/
│   ├── app.py
│   ├── requirements.txt
│   └── users.json
│
└── README.md
```

---

# 🔄 Authentication Flow

## Signup

```
User
   │
   ▼
SwiftUI Form
   │
   ▼
Signup ViewModel
   │
   ▼
Signup Service
   │
   ▼
POST /signup
   │
   ▼
Flask Backend
   │
   ▼
Password Hashing
   │
   ▼
User Stored
```

---

## Login

```
User
   │
   ▼
SwiftUI Form
   │
   ▼
Login ViewModel
   │
   ▼
Auth Service
   │
   ▼
POST /login
   │
   ▼
Flask Backend
   │
   ▼
Password Verification
   │
   ▼
Authentication Success
```

---

# 📡 REST APIs

## Signup

```
POST /signup
```

### Request

```json
{
    "username":"john",
    "password":"123456"
}
```

### Response

```json
{
    "success":true
}
```

---

## Login

```
POST /login
```

### Request

```json
{
    "username":"john",
    "password":"123456"
}
```

### Response

```json
{
    "success":true,
    "token":"local-token-123"
}
```

---

# ▶️ Running the Backend

## Step 1

Navigate to the backend folder

```bash
cd SwiftUI_backend_support
```

## Step 2

Create a virtual environment

```bash
python3 -m venv venv
```

## Step 3

Activate the virtual environment

macOS/Linux

```bash
source venv/bin/activate
```

Windows

```bash
venv\Scripts\activate
```

## Step 4

Install dependencies

```bash
pip install -r requirements.txt
```

## Step 5

Start Flask server

```bash
python app.py
```

Server starts on

```
http://127.0.0.1:5000
```

---

# 📱 Running the iOS Application

1. Open the project in Xcode.
2. Select an iOS Simulator.
3. Build and Run.
4. Register a new user.
5. Login using the same credentials.

---

# 🧠 Learning Objectives

This project demonstrates

- SwiftUI application architecture
- MVVM design pattern
- Async/Await networking
- REST API communication
- JSON encoding & decoding
- Backend integration
- Password hashing
- Authentication flow
- Error handling
- Clean code organization

---

# 🔮 Future Enhancements

- JWT Authentication
- Refresh Tokens
- Secure Keychain Storage
- Biometric Authentication
- Session Management
- HTTPS Support
- SSL Pinning
- Unit Testing
- UI Testing
- Dockerized Backend
- Database Integration
- Token Expiration
- Password Reset
- Email Verification

---

# 📷 Screenshots

Coming Soon

| Login | Signup | Success |
|-------|---------|----------|
| Add Screenshot | Add Screenshot | Add Screenshot |

---

# 🤝 Contributions

This project is primarily intended for learning and demonstration purposes.

Suggestions and improvements are always welcome.

---

# 📄 License

This project is licensed under the MIT License.

---

# 👨‍💻 Author

**Thejas K**

Senior iOS Developer

Built with ❤️ using SwiftUI and Flask.
