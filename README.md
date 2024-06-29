# TaskPlus

## Introduction

**App Name:** TaskPlus  
**Description:** TaskPlus is a versatile task management and collaboration app designed to streamline productivity. Users can create missions, each comprising multiple tasks, and assign them to team members within dedicated workspaces. Two distinct roles, user and superuser, offer varying permissions: users can attach and download files, while superusers facilitate member invites via email or QR code scanning. Mission sequencing ensures tasks follow a specified order. Detailed task histories track completed, missed, and pending tasks, with notifications for new members, approaching deadlines, missed tasks, and task assignments. TaskPlus supports both dark and light modes for optimal user experience.

**Technologies Used:**
- Frontend: Flutter
- Backend: Django REST
- Notifications: Firebase Cloud Messaging API (V1)

## Getting Started

### Prerequisites
- Flutter SDK
- Python
- Django
- Firebase Cloud Messaging

### Installation

#### Backend (Django REST):

1. Clone the repository.
    ```bash
    git clone <repository_url>
    ```
2. Install dependencies.
    ```bash
    pip install -r requirements.txt
    ```
3. Set up Firebase project and configure `SERVICE_ACCOUNT_INFO`.
4. Run migrations.
    ```bash
    python manage.py migrate
    ```
5. Start the development server.
    ```bash
    python manage.py runserver
    ```
6. Start the job for sending notifications.
    ```bash
    python manage.py send_notifications
    ```

#### Frontend (Flutter):

1. Clone the repository.
    ```bash
    git clone <repository_url>
    ```
2. Install dependencies.
    ```bash
    flutter pub get
    ```
3. Set up Flutter with Firebase project.
4. Run the app.
    ```bash
    flutter run
    ```

## State Management

TaskPlus uses the BLoC pattern for state management.
