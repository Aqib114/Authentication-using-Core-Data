import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!

    let loginViewModel = LoginViewModel()

    static func loadFromNib() -> LoginViewController {
        return LoginViewController(nibName: "LoginViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextFieldLayout()
        setupGestureRecognizers()
        setupTextFieldImages()
        setupTextFieldTargets()
        setupDismissKeyboardGesture()

    }

    // Function to set up the layout for text fields
    func setupTextFieldLayout() {
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.shadowColor = UIColor.lightGray.cgColor
        emailTextField.layer.shadowOpacity = 0.5
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailTextField.layer.shadowRadius = 4
        
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.shadowColor = UIColor.lightGray.cgColor
        passwordTextField.layer.shadowOpacity = 0.5
        passwordTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        passwordTextField.layer.shadowRadius = 4
    }

    // Function to set up tap gesture recognizers
    func setupGestureRecognizers() {
        let createAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(createAccountTapped))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(createAccountTapGesture)
    }

    //Function to set up images inside text fields
    func setupTextFieldImages() {
        setLeftImageForTextField(emailTextField, imageName: "email", padding: 10)
        setLeftImageForTextField(passwordTextField, imageName: "pass", padding: 10)
    }

    // Method to set up targets for text fields
    func setupTextFieldTargets() {
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
    }

    // Function to validate email input
    @objc func emailTextFieldChanged() {
        if let email = emailTextField.text {
            if isValidEmail(email) {
                emailValidationLabel.text = ""
                emailValidationLabel.textColor = .clear
            } else {
                emailValidationLabel.text = "Invalid Email"
                emailValidationLabel.textColor = .red
            }
        }
    }

    // Function to validate password input
    @objc func passwordTextFieldChanged() {
        if let password = passwordTextField.text {
            if isValidPassword(password) {
                passwordValidationLabel.text = ""
                passwordValidationLabel.textColor = .clear
            } else {
                passwordValidationLabel.text = "Password should be 4-8 characters"
                passwordValidationLabel.textColor = .red
            }
        }
    }

    // Function to check email validity
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    // Function to check password validity
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 4 && password.count <= 8
    }

    func setLeftImageForTextField(_ textField: UITextField, imageName: String, padding: CGFloat) {
        let imageView = UIImageView(image: UIImage(named: imageName))
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width + padding, height: imageView.frame.height))
        containerView.addSubview(imageView)
        imageView.frame = CGRect(x: padding, y: 0, width: imageView.frame.width, height: imageView.frame.height)
        textField.leftView = containerView
        textField.leftViewMode = .always
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            if emailTextField.text?.isEmpty ?? true {
                emailValidationLabel.text = "Email is required"
                emailValidationLabel.textColor = .red
            } else {
                emailValidationLabel.text = ""
            }

            if passwordTextField.text?.isEmpty ?? true {
                passwordValidationLabel.text = "Password is required"
                passwordValidationLabel.textColor = .red
            } else {
                passwordValidationLabel.text = ""
            }
            return
        }

//        if isValidEmail(email) && isValidPassword(password) {
//            if let savedUser = fetchUserFromCoreData(email: email) {
//                if savedUser.password == password {
//                    
//                    let homeScreenController = HomeViewController(nibName: "HomeViewController", bundle: nil)
//                    homeScreenController.userName = savedUser.name ?? "User"
//                    homeScreenController.userCity = savedUser.city ?? "Unknown City"
//                    homeScreenController.userEmail = savedUser.email ?? "Unknown Email"
//                    
//                    // Directly access the profile image from the existing savedUser object
//                    if let imageData = savedUser.profileimage {
//                        print("Image data found, size: \(imageData.count) bytes")
//                        
//                        // Convert the image data to UIImage
//                        if let image = UIImage.fromBase64(imageData) {
////                             UIImage(data: imageData) {
//                            print("Image successfully created from data.")
//                            homeScreenController.userImage = image
//                        } else {
//                            print("Failed to create image from data.")
//                        }
//                    } else {
//                        print("No image data found.")
//                        homeScreenController.userImage = UIImage(systemName: "pencil") // Use a placeholder if no image is available
//                    }
        if isValidEmail(email) && isValidPassword(password) {
                // Check if user exists in Core Data
                if let savedUser = fetchUserFromCoreData(email: email) {
                    // Validate the password
                    if savedUser.password == password {
                        print("User found: \(savedUser)")
                        
                        // Initialize the HomeViewController
                        let homeScreenController = HomeViewController(nibName: "HomeViewController", bundle: nil)
                        homeScreenController.userName = savedUser.name ?? "User"
                        homeScreenController.userCity = savedUser.city ?? "Unknown City"
                        homeScreenController.userEmail = savedUser.email ?? "Unknown Email"

                        // Fetch the profile image, if available
                        if let imageData = savedUser.profileimage {
                            print("Image data found, size: \(imageData.count) bytes")
                            
                            // Attempt to create an image from the data
                            if let image = UIImage(data: imageData) {
                                print("Image successfully created from data.")
                                homeScreenController.userImage = image
                            } else {
                                print("Failed to create image from data.")
                            }
                        } else {
                            print("No image data found.")
                            homeScreenController.userImage = UIImage(systemName: "pencil") // Use a placeholder if no image is available
                        }

                    let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    navigationItem.backBarButtonItem = backBarButton
                    navigationController?.navigationBar.tintColor = .black
                    navigationController?.pushViewController(homeScreenController, animated: true)
                } else {
                    showAlert(message: "Password didn't match. Please try again.")
                }
            } else {
                showAlert(message: "Email doesn't exist. Please check your email.")
            }
        } else {
            showAlert(message: "Invalid email or password")
        }
    }

    func fetchUserFromCoreData(email: String) -> Users? {
        let context = PersistenceService.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }
    
    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func createAccountTapped() {
   let signupViewController = SignUpVC.loadFromNib()
        navigationController?.pushViewController(signupViewController, animated: true)
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.navigationBar.tintColor = .white
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
