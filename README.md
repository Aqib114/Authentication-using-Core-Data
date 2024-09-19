# Authentication-using-Core-Data
This iOS app demonstrates a simple user authentication flow using **CoreData** for storing and fetching user data. The app consists of three main screens: **SignUp, Login, and Home.**

## Screenshots
### Signup Screen
![Signup Screen](signup.png)

### Login Screen
![Login Screen](login.png)

### Home Screen
![Home Screen](home.png)

## Features
**1. User Sign-Up:**
- The user creates an account by entering their **name, email, password, and confirm password**.
- The app checks that the email is in a valid format and that the password meets certain criteria.
- After successful sign-up, the user data (name, email, and password) is saved locally using **CoreData**.
- Upon successful account creation, the user is automatically navigated to the **Login** screen.

**2. User Login:**
- Users who have already signed up can log in by entering their **email** and **password**.
- The app checks if the entered credentials match with a user stored in **CoreData**.
- Only authenticated users can log in. If the credentials are incorrect, an appropriate error message is shown.
- Upon successful login, the user is navigated to the Home screen.
  
**3. Home Screen:**
- Once logged in, the **Home** screen displays a welcome message along with the user's **name**.
- This screen is only accessible to users who have successfully authenticated.

## Project Structure
The app consists of three view controllers:

**1. SignUpViewController:**
- Handles user account creation.
- Inputs: Name, Email, Password, and Confirm Password.
- Validations:
    - All fields are required.
    - Password and confirm password must match.
- Upon successful sign-up, the user is saved to **CoreData** and redirected to the **Login** screen.
  
**2. LoginViewController:**
- Handles user authentication.
- Inputs: Email and Password.
- Checks if the entered credentials match any existing user in **CoreData**.
- Upon successful login, the user is redirected to the **Home** screen.

**3. HomeViewController:**
- Displays a personalized welcome message with the logged-in user's name.
- This screen is only shown after a successful login.

## CoreData Implementation
- **CoreData** is used to store user data locally on the device.
- The following user properties are saved:
   - name: User's name.
   - email: User's email (used for authentication).
   - password: User's password (used for authentication).
The **Users** entity in CoreData stores the above attributes, and a custom **CoreDataManager** class manages the fetch, save, and context operations.

## UI Design
**1. Programmatic Design**
- Certain UI components such as buttons and labels have been created programmatically in the view controllers for better flexibility and dynamic customization.

**2. XIB-based Design:**
- Some parts of the UI are designed using XIB files to achieve a reusable, modular design. This includes the login and sign-up forms, which are designed using XIB for a clean and structured layout.

## Technologies Used
- **Swift**: For the app's programming language.
- **UIKit**: For building the user interface.
- **CoreData**: For local data storage and user authentication.
- **XIB Files**: Used for building reusable UI components.

## Installation and Setup

### Prerequisites
- Xcode 12 or later
- iOS 13.0 or later

### Steps to Run the Ap
1. **Clone the Repository**
   
bash
   git clone https://github.com/yourusername/Authentication-using-Core-Data.git

   Replace yourusername with your GitHub username.

2. **Open the Project in Xcode**
   - Navigate to the project folder and open the .xcodeproj file.
   - Xcode will launch the project.

3. **Build the Project**
   - Select your target device or simulator.
   - Press Cmd + B to build the project.

4. **Run the Project**
   - Press Cmd + R to run the app on the selected device or simulator.
