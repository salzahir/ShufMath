# ShufMath 🎓📱

**ShufMath** is a SwiftUI-based educational tool designed to make practicing multiplication and division fun and interactive. With customizable difficulty settings, a timer, and real-time score tracking, this app helps users improve their math skills in an engaging and competitive way. The app has been refactored to follow the **MVVM (Model-View-ViewModel)** architecture for better code organization, maintainability, and scalability.

## Features 🌟

### Gameplay Features:
- Randomly generated multiplication and division questions.
- User input validation with feedback (correct/incorrect answers).
- Real-time score tracking during gameplay.
- Timer to track performance within a set time limit.
- Supports decimal inputs for more advanced practice.

### Customization & Settings:
- Select number range and question quantity.
- Custom Difficulty with adjustable max multiplier/divider.
- High score tracking to motivate continuous improvement.

### Clean UI Design:
- Built using SwiftUI for a user-friendly and visually appealing interface.
- Responsive layout that adapts seamlessly to various iOS devices and screen sizes.

## App Icon 🎨
The app icon, **appIcon**, represents the app's dynamic and interactive nature. It features a **shuffle symbol**, which reflects the flexibility of choosing between multiplication, division, or a mix of both modes. The colorful design ties into the app's fun and engaging vibe, perfectly capturing the spirit of learning while offering customization options.

![App Icon](images/appIcon.png)

## How to Use 📝
1. Launch the app.
2. Select a difficulty (Easy, Medium, Hard) or choose Custom for personalized settings.
3. Start practicing multiplication or division by answering the questions presented.
4. Track your score, watch the timer, and aim to beat your high score!

## Future Enhancements 🚀
- Add more challenging question types, including fractions or word problems.
- Implement a streaks feature to reward consecutive correct answers.
- Introduce power-ups to assist with difficult questions or increase points.
- **Explore backend potential with APIs to track user progress and enable data synchronization across devices.**

## Technologies Used 🔧
- Swift 5
- SwiftUI
- Xcode 14+
- **MVVM Architecture** for improved scalability and maintainability

## Game Views
Here’s an example of the game setup and in-game view:

### Welcome Screen
![Welcome Setup](images/welcome.jpg)

### Game Setup
![Game Setup](images/setup.jpg)

### In-Game View
![In-Game View](images/in-game.jpg)

### Game Over View
![Game Over View](images/game-over.jpg)

## What I Learned
- **State Management:** Gained proficiency in managing app state with `@StateObject`, `@ObservedObject`, and `@Binding` in SwiftUI, enabling efficient data flow and reactivity.
- **UI/UX Design:** Applied basic UI/UX principles to improve the user interface, focusing on clarity and responsiveness. Integrated dynamic elements like haptic feedback, sound effects, and progress indicators for a more engaging experience.
- **Model-View-ViewModel (MVVM) Architecture:** Refined understanding of the MVVM design pattern by restructuring the app to separate business logic from UI components, improving maintainability and testability.
- **Game Logic Implementation:** Developed custom game logic, including handling user input, scoring, and question management. Implemented logic to ensure valid inputs and a smooth user experience.
- **Git and Version Control:** Utilized Git for version control, making frequent commits and maintaining a well-structured commit history to track project progress.

## Installation 🚀
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ShufMath.git
      
## License 📝
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
