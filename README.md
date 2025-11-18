# Sports-Hub Application iOS Front-End

## Project Description

This is a project skeleton for testing Generative AI on different software engineering tasks. 

The application's legend is based on the sports-hub application description from the following repo: [Sports-Hub](https://github.com/dark-side/sports-hub).

## Available Back-End applications
- [Ruby on Rails](https://github.com/dark-side/sports_hub_ruby_skeleton),
- [PHP](https://github.com/dark-side/sports_hub_php_skeleton),
- [Node.js](https://github.com/dark-side/sports_hub_nodejs_skeleton),
- [Java](https://github.com/dark-side/sports_hub_java_skeleton),
- [.Net](https://github.com/dark-side/sports_hub_net_skeleton),
- [C++](https://github.com/dark-side/sports_hub_cpp_skeleton),
- [Go](https://github.com/dark-side/sports_hub_go_skeleton),
- [Python](https://github.com/dark-side/sports_hub_python_skeleton)

## Environment

- **Xcode**: 16.4 or later
- **iOS Deployment Target**: iOS 16.0 or later
- **Swift**: 6.0 or later
- **macOS**: macOS 15.0 (Sequoia) or later

## Project Structure

The project follows Clean Architecture principles with the following layers:

- **Domain Layer**: Contains business logic, entities, use cases, and repository protocols
- **Data Layer**: Implements data sources (remote/mock) and repositories
- **Presentation Layer**: Contains SwiftUI views, view models, and UI utilities

### Key Features

- User authentication
- Articles list and detail views
- Clean Architecture with dependency injection
- Mock and remote data sources for testing
- Comprehensive unit tests

## Getting Started

### Prerequisites

1. **Install Xcode**: Download and install Xcode from the Mac App Store or [Apple Developer](https://developer.apple.com/xcode/)

### Clone the Repository

```sh
git clone git@github.com:dark-side/ios_mob_genai_plgrnd.git
cd ios_mob_genai_plgrnd
```

### Open the Project

1. Open `SportsHub/SportsHub.xcodeproj` in Xcode
2. Wait for Swift Package Manager to resolve dependencies
3. Select your target device or simulator
4. Press `Cmd + R` to build and run the application

## Running Tests

### Unit Tests

To run unit tests:

1. In Xcode, press `Cmd + U` to run all tests
2. Or navigate to `Product > Test` from the menu bar
3. View test results in the Test Navigator (`Cmd + 6`)

The project includes comprehensive tests for:
- Data sources (ArticlesRemoteDataSourceTests, AuthRemoteDataSourceTests)
- Repositories (DefaultArticlesRepositoryTests, DefaultAuthRepositoryTests)
- Use cases (GetArticlesUseCaseTests, SignInUseCaseTests, etc.)
- View models (ArticlesViewModelTests, SignInViewModelTests, etc.)
- Utilities (AuthenticationManagerTests)
- DTO mappings (ArticleDTOMappingTests, UserDTOMappingTests)

## Architecture

The application follows **Clean Architecture** principles:

```
┌─────────────────┐
│  Presentation   │ ← SwiftUI Views, ViewModels
├─────────────────┤
│     Domain      │ ← Entities, Use Cases, Repository Protocols
├─────────────────┤
│      Data       │ ← Repository Implementations, Data Sources, DTOs
└─────────────────┘
```

### Dependencies

The project uses:
- **SwiftUI** for declarative UI
- **Swift's async/await** for asynchronous operations
- Protocol-oriented design for testability

## Development

### Building for Production


### Code Style

- Follow Swift API Design Guidelines
- Ensure all code is properly documented
- Write unit tests for new features

## Connecting to Backend

To connect the iOS app to a backend:

1. Clone one of the available backend repositories
2. Follow the backend's README to set up and run it via Docker Compose
3. Update the API base URL in the iOS app's remote data sources
4. Ensure your iOS device/simulator can reach the backend endpoint
