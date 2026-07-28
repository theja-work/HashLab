# 🔐 HashLab

> An interactive SwiftUI + Flask playground for exploring authentication, password hashing, authorization, and configurable security strategies through hands-on implementations.

HashLab is a full-stack learning project built from scratch to explore the fundamentals of authentication, password hashing, authorization, and secure client-server communication. Instead of relying on authentication frameworks, the core security features are implemented manually to understand how they work under the hood.

---

## ✨ Features

### 🔑 Authentication
- User Signup
- User Login
- JWT Authentication
- Legacy Username & Password Authentication
- Runtime Authentication Mode Switching
- Bearer Token Authorization
- Secure JWT Storage using iOS Keychain

### 👤 User Management
- Delete Own Account
- Admin-only Delete All Non-Admin Users
- Role-based Authorization
- Maximum Admin Account Limit

### 🔒 Password Security
- Custom hashing library written in C
- Runtime Hashing Mode Switching
- Plain Hashing
- Username-based Deterministic Salting
- Demonstrates how changing hashing strategies affects authentication

### ⚙️ Developer Experience
- Runtime Security Configuration
- Developer Settings Screen
- Loading Indicators
- Success & Error Toasts
- Modular Service Architecture

### 🌐 Backend
- Python Flask REST API
- SQLite Database
- Authentication Middleware
- Configurable Runtime Security Modes

### 📱 iOS Application
- SwiftUI
- MVVM Architecture
- Async/Await Networking
- Dependency Injection
- Keychain Integration

---

## 🛠 Tech Stack

### iOS
- SwiftUI
- Combine
- Async/Await
- MVVM
- Keychain Services

### Backend
- Python
- Flask
- SQLite
- PyJWT

### Native
- C (Custom Hashing Library)

---

## 🎓 Learning Objectives

HashLab focuses on understanding the building blocks of application security through practical implementation.

It currently demonstrates:

- Password Hashing
- Password Salting
- JWT Authentication
- Bearer Token Authorization
- Legacy Authentication
- Authentication vs Authorization
- Role-based Access Control
- Secure Token Storage
- Runtime Security Configuration
- Client-Server Communication
- REST API Design
- SQLite Integration
- Flask Middleware

---

## 🚀 Runtime Security Configuration

One of HashLab's core features is the ability to switch security strategies **while the application is running**, making it easier to observe how different authentication and hashing approaches behave.

### Authentication Modes

- ✅ JWT Authentication
- ✅ Legacy Username & Password Authentication

### Password Hashing Modes

- ✅ Plain Hashing
- ✅ Username-Salted Hashing

Changing these settings immediately affects newly executed authentication flows, allowing the project to demonstrate how different security configurations influence application behavior.

---

## 📂 Project Structure

```
HashLab
│
├── iOS
│   ├── Views
│   ├── ViewModels
│   ├── Models
│   ├── Services
│   ├── Networking
│   └── Utilities
│
├── Backend
│   ├── app.py
│   ├── auth.py
│   ├── auth_service.py
│   ├── user_service.py
│   ├── settings_service.py
│   ├── credential_service.py
│   ├── database.py
│   ├── hashing.py
│   ├── config.py
│   ├── auth_mode.py
│   └── hashing_mode.py
│
└── Native
    └── libhash.dylib
```

---

## 📸 Screenshots

| Login | Home | Developer Settings |
|-------|------|--------------------|
| *(Add Screenshot)* | *(Add Screenshot)* | *(Add Screenshot)* |

| Delete Account | Delete Users | Runtime Security Modes |
|----------------|--------------|------------------------|
| *(Add Screenshot)* | *(Add Screenshot)* | *(Add Screenshot)* |

---

## 🗺️ Roadmap

### ✅ Completed

- User Signup
- User Login
- SQLite Integration
- JWT Authentication
- Legacy Authentication
- Runtime Authentication Switching
- Plain & Salted Hashing
- Runtime Hashing Switching
- Role-based Authorization
- Delete Account
- Delete All Non-Admin Users
- Secure JWT Storage using Keychain
- Developer Settings Screen

### 🚧 Planned

- Refresh Tokens
- Password Migration
- Password Reset Flow
- Hash Algorithm Versioning
- Automatic Password Rehashing
- Security Audit Logs
- Rate Limiting
- Performance Analysis using Instruments
- Unit Tests
- Integration Tests

---

## 💡 Why HashLab?

Many tutorials demonstrate authentication by integrating third-party libraries or cloud providers. HashLab takes a different approach by implementing the core concepts directly, making it easier to understand how authentication, authorization, password hashing, and runtime security configuration work together in a complete application.

The goal isn't to build a production-ready authentication framework, but to create a practical learning environment where security concepts can be explored, modified, and observed through real code.

---

## 📜 License

This project is intended for educational and learning purposes.

---

**Built with SwiftUI, Python, SQLite, and C to explore authentication from the ground up. 🚀**
