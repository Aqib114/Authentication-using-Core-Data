import CoreData
import UIKit
import DropDown

class SignUpVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    var imagesArray : [UIImage] = []
    @IBOutlet weak var txtCity: UITextField!
    
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
//        txtCity.addTarget(self, action: #selector(textfieldTapped), for: .touchDown)
                txtCity.isUserInteractionEnabled = true

        textfieldTap()
//        txtCity.addTarget(self, action: #selector(textfieldTapped), for : .touchUpInside)
    }
    
    // MARK: - UI Setup
    func setupUI() {
        customizeTextFields(txtName, icon: UIImage(systemName: "person.crop.circle.fill"))
        customizeTextFields(txtEmail, icon: UIImage(systemName: "envelope.fill"))
        customizeTextFields(txtPassword, icon: UIImage(systemName: "lock.fill"))
        customizeTextFields(txtConfirmPassword, icon: UIImage(systemName: "lock.fill"))
//        customizeTextFields(txtCity, icon: UIImage(systemName: "globe.asia.australia.fill"))
        customizeCityTextField(txtCity, iconLeft: UIImage(systemName: "globe.asia.australia.fill"), iconRight: UIImage(systemName: "chevron.down.circle"))
//        txtCity.isUserInteractionEnabled = false
//        avatarImage.borderStyle = .roundedRect
        profileImage.layer.shadowColor = UIColor.black.cgColor
        profileImage.layer.shadowOpacity = 0.4
        profileImage.layer.shadowOffset = CGSize(width: 1, height: 1)
        profileImage.layer.shadowRadius = 4
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
    }
    
    // MARK: - Delegate Setup
    func setupDelegates() {
        txtName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtCity.delegate = self
    }
    func textfieldTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textfieldTapped))
        txtCity.addGestureRecognizer(tapGesture)
    }
    @objc func textfieldTapped(){
        let dropDown = DropDown()
        dropDown.anchorView = txtCity
        dropDown.dataSource = ["Karachi", "Lahore", "Islamabad", "Peshawar", "Quetta", "Multan"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            txtCity.text = item
        }
//        dropDownLeft.width = 200
        dropDown.show()
//        dropDown.hide()
        dropDown.direction = .bottom
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: txtCity.bounds.height)

        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        
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
//    func ValidateProfileImage(){
//        if profileImage.image == profileImage.image  {
//            btnUpload.titleLabel?.text = "Image Uploaded"
//        }
//        else{
//            btnUpload.titleLabel?.text = "Upload Profile Image"
//        }
//    }
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
    
    @IBAction func btnUploadClicked(_ sender: Any) {
        presentImageSourceOptions()
    }
    func presentImageSourceOptions(){
        let actionSheet = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            print("Selected image: \(selectedImage)")
//            imagesArray.append(selectedImage)
            profileImage.image = selectedImage
        } else {
                print("No image selected")
            }
        
        picker.dismiss(animated: true, completion: nil)
       
        btnUpload.setTitle("Image Uploaded", for: .normal)
        btnUpload.isEnabled = false
        
            
    }
    func setRounded() {
        self.view.layer.cornerRadius = (view.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.view.layer.masksToBounds = true
        }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func validateFormAndCreateUser() {
        guard let name = txtName.text, !name.isEmpty,
              let email = txtEmail.text, !email.isEmpty,
              let profileimage = profileImage.image,
              let city = txtCity.text,
              let password = txtPassword.text, !password.isEmpty,
              let confirmPassword = txtConfirmPassword.text, !confirmPassword.isEmpty else {
            validateName()
            validateEmail()
            validatePassword()
            validateConfirmPassword()
//            ValidateProfileImage()
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
        
        if SignUpViewModel.sharedInstance.isEmailExists(email: email) {
            setLabel(emailErrorLbl, text: "User with this email already exists.", for: txtEmail)
            return
        }
        
        let imageData = profileimage.pngData() ?? Data()
        
        // Create user
        let userDict = ["name": name, "email": email, "password": password, "imageData": imageData, "city": city] as [String : Any]
        SignUpViewModel.sharedInstance.create(object: userDict)
        print("User added successfully.")
        let LoginViewController = LoginViewController.loadFromNib()
        navigationController?.pushViewController(LoginViewController, animated: true)
        navigationController?.navigationBar.isHidden = true
       
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
            iconImageView.frame = CGRect(x: 10, y: 2, width: 20, height: 20)
            leftView.addSubview(iconImageView)
        }
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    func customizeCityTextField(_ textField: UITextField, iconLeft: UIImage?, iconRight : UIImage?) {
        textField.borderStyle = .roundedRect
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 1, height: 1)
        textField.layer.shadowRadius = 4
        textField.layer.masksToBounds = false
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if let iconImage = iconLeft {
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.tintColor = .gray.withAlphaComponent(0.8)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.frame = CGRect(x: 10, y: 2, width: 20, height: 20)
            leftView.addSubview(iconImageView)
        }
        textField.leftView = leftView
        textField.leftViewMode = .always 
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if let rightIcon = iconRight {
            let iconImageView = UIImageView(image: rightIcon)
            iconImageView.tintColor = .gray.withAlphaComponent(1.0)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.frame = CGRect(x: 0, y: 2, width: 20, height: 20)
            rightView.addSubview(iconImageView)
        }
        textField.rightView = rightView
        textField.rightViewMode = .always
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
