<div align='center'>

<h1>Task Management Application</h1>
<p>A modern task management application built with Flutter for the frontend and includes a backend server. This application helps users organize and track their tasks efficiently.</p>



</div>

# :notebook_with_decorative_cover: Table of Contents

- [About the Project](#star2-about-the-project)
- [Contributing](#wave-contributing)


## :star2: About the Project
### :space_invader: Tech Stack
<details> <summary>Frontend</summary> <ul>
  <li><img src="https://img.shields.io/badge/Flutter-3.6%2B-blue"></li>
  <li><img src="https://img.shields.io/badge/State%20Management-Flutter%20Bloc-blue"></li>
  <li><img src="https://img.shields.io/badge/Local%20Storage-SQLite-blue"></li>
  <li><img src="https://img.shields.io/badge/Local%20Storage-Shared%20Preferences-blue"></li>
  <li><img src="https://img.shields.io/badge/HTTP%20Client-API%20communication-blue"></li>
  <li><img src="https://img.shields.io/badge/UUID-unique%20identifiers-blue"></li>
  <li><img src="https://img.shields.io/badge/Connectivity%20Plus-network%20status-blue"></li>
</ul> </details>
<details> <summary>Backend</summary> <ul>
  <li><img src="https://img.shields.io/badge/Node.js-TypeScript-green"></li>
  <li><img src="https://img.shields.io/badge/Docker-containerization-green"></li>
  <li><img src="https://img.shields.io/badge/Environment%20Configuration-support-green"></li>
  <li><img src="https://img.shields.io/badge/Database-PostgreSQL-white"></li>
</ul> </details>


### :dart: Features

### User Authentication

- Sign up with email and password
- Login with existing credentials
- Secure token-based authentication
- Persistent login state

### Task Management

- Create new tasks
- Set task due dates
- Customize task colors
- Add task descriptions
- View task details
- Local data persistence
- Real-time synchronization with backend
  
## :toolbox: Getting Started

### :bangbang: Prerequisites

- Flutter SDK
- Dart SDK
- Node.js
- Docker (for backend)
  
### :key: Environment Variables
To run this project, you will need to add the following environment variables to your .env file

`DATABASE_URL`
`DB_HOST`
`DB_PORT`
`PORT`
`POSTGRES_USER`
`POSTGRES_PASSWORD`
`POSTGRES_DB`
`JWT_KEY`


### :gear: Installation

Clone the repository
```bash
git clone https://github.com/EmreDmrell/task-manager.git 
```
Frontend Setup:
```bash
cd frontend 
flutter pub get
```
Backend Setup:
```bash
cd backend
npm install
```


### :running: Run Locally

Run the application
```bash
# Start backend server
cd backend
docker-compose up
```
Run frontend application
```bash
# Run frontend application
cd frontend
flutter run
```

### :file_cabinet: Project Structure

```plaintext
task_app/
├── frontend/         # Flutter application
│   ├── lib/
│   │   ├── core/    # Core utilities and constants
│   │   ├── features/# Feature-based architecture
│   │   └── models/  # Data models
│   └── ...
└── backend/         # Node.js server
    ├── src/
    ├── Dockerfile
    └── docker-compose.yaml
```

## :wave: Contributing

1. Fork the repository
2. Create your feature branch:
    ```bash
    git checkout -b feature/AmazingFeature
    ```
3. Commit your changes:
    ```bash
    git commit -m 'Add some AmazingFeature'
    ```
4. Push to the branch:
    ```bash
    git push origin feature/AmazingFeature
    ```
5. Open a Pull Request
   
Contributions are always welcome!
