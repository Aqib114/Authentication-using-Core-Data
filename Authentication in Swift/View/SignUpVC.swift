import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var confirmErrorLbl: UILabel!
    @IBOutlet weak var passErrorLbl: UILabel!
    @IBOutlet weak var emailErrorLbl: UILabel!
    @IBOutlet weak var nameErrorLbl: UILabel!
    
    static func loadFromNib() -> SignUpVC {
        return SignUpVC(nibName: "SignUpVC", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        setupDismissKeyboardGesture()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        customizeTextFields(txtName, icon: UIImage(systemName: "person.crop.circle.fill"))
        customizeTextFields(txtEmail, icon: UIImage(systemName: "envelope.fill"))
        customizeTextFields(txtPassword, icon: UIImage(systemName: "lock.fill"))
        customizeTextFields(txtConfirmPassword, icon: UIImage(systemName: "lock.fill"))
    }
    
    // MARK: - Delegate Setup
    func setupDelegates() {
        txtName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
    
    // MARK: - Keyboard Dismiss Setup
    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        validateTextField(textField)
        return true
    }
    
    // MARK: - Validation Logic
    func validateTextField(_ textField: UITextField) {
        switch textField {
        case txtName:
            validateName()
        case txtEmail:
            validateEmail()
        case txtPassword:
            validatePassword()
        case txtConfirmPassword:
            validateConfirmPassword()
        default:
            break
        }
    }
    
    func validateName() {
        if txtName.text?.isEmpty == true {
            setLabel(nameErrorLbl, text: "Name is required.", for: txtName)
        } else {
            resetLabel(nameErrorLbl, for: txtName)
        }
    }
    
    func validateEmail() {
        if let email = txtEmail.text, !isValidEmail(email) {
            setLabel(emailErrorLbl, text: "Invalid email address.", for: txtEmail)
        } else if txtEmail.text?.isEmpty == true {
            setLabel(emailErrorLbl, text: "Email is required.", for: txtEmail)
        } else {
            resetLabel(emailErrorLbl, for: txtEmail)
        }
    }
    
    func validatePassword() {
        if txtPassword.text?.isEmpty == true {
            setLabel(passErrorLbl, text: "Password is required.", for: txtPassword)
        } else {
            resetLabel(passErrorLbl, for: txtPassword)
        }
    }
    
    func validateConfirmPassword() {
        if txtConfirmPassword.text?.isEmpty == true {
            setLabel(confirmErrorLbl, text: "Confirm password is required.", for: txtConfirmPassword)
        } else if txtPassword.text != txtConfirmPassword.text {
            setLabel(confirmErrorLbl, text: "Passwords do not match.", for: txtConfirmPassword)
        } else {
            resetLabel(confirmErrorLbl, for: txtConfirmPassword)
        }
    }
    
    // MARK: - Create User Action
    @IBAction func createdUser(_ sender: Any) {
        validateFormAndCreateUser()
    }
    
    func validateFormAndCreateUser() {
        guard let name = txtName.text, !name.isEmpty,
              let email = txtEmail.text, !email.isEmpty,
              let password = txtPassword.text, !password.isEmpty,
              let confirmPassword = txtConfirmPassword.text, !confirmPassword.isEmpty else {
            validateName()
            validateEmail()
            validatePassword()
            validateConfirmPassword()
            return
        }
        
        if password != confirmPassword {
            setLabel(confirmErrorLbl, text: "Passwords do not match.", for: txtConfirmPassword)
            return
        }
        
        if !isValidEmail(email) {
            setLabel(emailErrorLbl, text: "Invalid email.", for: txtEmail)
            return
        }
        
        if DataBaseHelper.sharedInstance.isEmailExists(email: email) {
            setLabel(emailErrorLbl, text: "User with this email already exists.", for: txtEmail)
            return
        }
        
        // Create user
        let userDict = ["name": name, "email": email, "password": password]
        DataBaseHelper.sharedInstance.create(object: userDict)
        print("User added successfully.")
    }
    
    // MARK: - TextField Customization
    func customizeTextFields(_ textField: UITextField, icon: UIImage?) {
        textField.borderStyle = .roundedRect
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 1, height: 1)
        textField.layer.shadowRadius = 4
        textField.layer.masksToBounds = false
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if let iconImage = icon {
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.tintColor = .gray.withAlphaComponent(0.8)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.frame = CGRect(x: 10, y: 2, width: 25, height: 25)
            leftView.addSubview(iconImageView)
        }
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
    // MARK: - Label Handling
    func setLabel(_ label: UILabel, text: String, for textField: UITextField) {
        label.text = text
        label.textColor = .red
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
    }
    
    func resetLabel(_ label: UILabel, for textField: UITextField) {
        textField.layer.borderWidth = 0
        label.text = ""
        label.textColor = .clear
    }
    
    // MARK: - Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
