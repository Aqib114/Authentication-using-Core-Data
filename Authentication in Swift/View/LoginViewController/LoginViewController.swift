import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var createAccountLabel: UILabel!

    let loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up rounded corners for text fields
        emailTextField.layer.cornerRadius = 10  // Updated to emailTextField
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor

        // Set up images inside text fields
        setLeftImageForTextField(emailTextField, imageName: "email")
        setLeftImageForTextField(passwordTextField, imageName: "pass")
        
        // Add tap gesture for forgot password label
        let forgotPasswordTapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(forgotPasswordTapGesture)

        // Add tap gesture for create account label
        let createAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(createAccountTapped))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(createAccountTapGesture)
    }

    // Function to add image inside text fields
    func setLeftImageForTextField(_ textField: UITextField, imageName: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        textField.leftView = imageView
        textField.leftViewMode = .always
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        // Make sure to reference the correct text fields
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            showAlert(message: "Please enter both email and password")
            return
        }

        // Authenticate using the ViewModel
        let isAuthenticated = loginViewModel.authenticateUser(email: email, password: password)

        if isAuthenticated {
            // Fetch the user to get the name
            let userName = loginViewModel.getUserName(email: email)
            
            // Navigate to Home screen and pass the user's name
            let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            homeViewController.userName = userName
            navigationController?.pushViewController(homeViewController, animated: true)
        } else {
            // Show an error message
            showAlert(message: "Invalid email or password")
        }
    }
    
    @objc func forgotPasswordTapped() {
        // Handle forgot password action
        print("Forgot password tapped")
    }
    
    @objc func createAccountTapped() {
        // Handle create account action
        // Example: Navigate to signup view controller
//        let signupViewController = storyboard?.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
//        navigationController?.pushViewController(signupViewController, animated: true)
    }

    // Helper function to display alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
