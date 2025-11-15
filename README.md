# DHANNALYZE

## Introduction

Dhannalyze is a secure and intuitive mobile application that helps users view all their loan-related information in one place — without visiting multiple bank apps or branches.
It provides a single dashboard for insights like loan status, account details, and credit score trends.Built with a focus on simplicity, transparency, and user convenience, Dhannalyze enables general users to instantly check their financial insights using a smooth OTP-based login experience.

________________________________________________________________________________________________________

## Project Overview

![Dhannalye ](https://github.com/user-attachments/assets/61be2889-3476-40a3-bc0d-397d1d4bd9a4)

Project APK: https://drive.google.com/drive/folders/1Zgxu_JvaQvUcU8OvARtBWG9Gm7t6jVbe?usp=sharing

Project Promo: https://youtu.be/Fr9YEyIMD6k

Project UI: https://drive.google.com/drive/folders/1Vkkeku5vXUNKQXxv2HsfaLzgahrTe6rR?usp=sharing
______________________________________________________________

## Features

-OTP-based authentication enables users to log in quickly and securely without needing to access separate bank portals.

-A centralized loan insights dashboard provides a clear overview of all active loans, EMIs, dues, and financial summaries.

-A unified financial view helps users track their loan information in one convenient place.

-Optional fingerprint-based 2FA adds an extra layer of security for faster and safer access.

-An intuitive Flutter UI, combined with flutter_secure_storage, ensures a smooth experience while safely storing user-sensitive credentials.

-The platform also makes it easier for banking institutions to understand customer financial patterns, improving assessment and decision-making.

_________________________________________________________________________________________________________

## Requirements

Before installation, ensure your system meets the following prerequisites:

- Node.js (v16 or newer)
- npm or yarn
- MongoDB & MongoDB Compass (for persistent storage and database managment)
- Git (for repository management)
- Docker (for containerized deployment)
- Android Studio or VS Code with emulator

## Installation

**Follow these steps to get DHANNALYZE up and running:**

1. **Clone the repository:**
    ```bash
    git clone https://github.com/devgamol/DHANNALYZE-PROJECT.git
    cd DHANNALYZE-PROJECT

     ```

3. **Install dependencies:**
    ```bash
    npm install
		
    ```

4. **Set up environment variables:**
    - Create a .env file inside the backend folder:
     ```bash
		PORT=3000
    MONGO_URI=your_mongodb_connection_string
    JWT_SECRET=your_jwt_key
    OTP_EMAIL=your_email
    OTP_EMAIL_PASSWORD=your_email_password
		BREVO_API_KEY=your_brevo_api_key

     ```

5. **Initialize the database:**
    - Run migration scripts or use provided setup commands to prepare your database.

6. **Start the development server:**
    ```bash
    npm run dev
    
    ```

7. **Access the application:**
    - Visit `http://localhost:3000` (or configured port) in your browser.

**Follow these steps for Backend Setup (Using Docker Image)**

1. **Build Docker Image**
```bash
docker build -t dhannalyze-backend .

```

2. **Run Docker Container**
```bash
docker run -d -p 3000:3000 \
-e PORT=3000 \
-e MONGO_URI=your_mongodb_atlas_connection_string \
-e BREVO_API_KEY=your_brevo_api_key \
--name dhannalyze-container \
dhannalyze-backend

```

**Flutter App Setup**

1. **Configure Base URL**
 - In your .env or config file:
```bash
BASE_URL=http://<your-ip>:3000

```

2. **Install Dependencies**
```bash
flutter pub get

```

3. **Run App**
```bash
flutter run

```
_________________________________________________________________________________________________________

## Contributing

We welcome contributions! To get started:

- Fork the repository on GitHub.
- Create a new branch for your feature or bugfix.
- Commit your changes with clear messages.
- Submit a pull request describing your changes.

_____________________________________________________________________________________________________________________________________________________________________________________________________________
## ⚠️Login Access Info
If you want to log in to the current production APK of Dhannalyze,
Contact Developer: amolsahu31010@gmail.com
​(for receiving OTP and access instructions)
​


