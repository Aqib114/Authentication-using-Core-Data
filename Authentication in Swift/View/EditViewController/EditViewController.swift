import UIKit
import CoreData
import DropDown

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Properties for user details
    var userName: String?
    var userCity: String?
    var userImage: UIImage?
    var userEmail: String?
    
    // Outlets for the UI elements
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityTextField.isUserInteractionEnabled = true
        reloadUserData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDismissKeyboardGesture()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Setup UI
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        customizeTextFields(nameTextField, icon: UIImage(systemName: "person.crop.circle.fill"))
        customizeCityTextField(cityTextField, iconLeft: UIImage(systemName: "globe.asia.australia.fill"), iconRight: UIImage(systemName: "chevron.down.circle"))
        profileImageView.image = userImage ?? UIImage(named: "placeholder-image")
        nameTextField.text = userName
        cityTextField.text = userCity
        textfieldTap()
    }
    func textfieldTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textfieldTapped))
        cityTextField.addGestureRecognizer(tapGesture)
    }
    @objc func textfieldTapped(){
        let dropDown = DropDown()
        dropDown.anchorView = cityTextField
        dropDown.dataSource = ["Karachi", "Lahore", "Islamabad", "Peshawar", "Quetta", "Multan"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            cityTextField.text = item
        }
        dropDown.show()
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: cityTextField.bounds.height)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
    }
    private func reloadUserData() {
        guard let email = userEmail else { return }
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                userName = user.name
                userCity = user.city
                if let imageData = user.profileimage {
                    userImage = UIImage(data: imageData)
                }
                setupUI()
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
    }
    
    // MARK: - Keyboard Dismiss Setup
    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if let rightIcon = iconRight {
            let iconImageView = UIImageView(image: rightIcon)
            iconImageView.tintColor = .gray.withAlphaComponent(1.0)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.frame = CGRect(x: 0, y: 2, width: 20, height: 20)
            rightView.addSubview(iconImageView)
        }
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.rightView = rightView
        textField.rightViewMode = .always
    }
    // Action for saving the updated data
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let city = cityTextField.text, !city.isEmpty,
              let email = userEmail else {
            print("Name, city or email is missing")
            return
        }
        updateUserData(name: name, city: city, email: email)
    }
    // Function to update user data in Core Data
    private func updateUserData(name: String, city: String, email: String) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.name = name
                user.city = city
                
                try context.save()
                print("User data updated successfully")
                showUpdateSuccessAlert()
            }
        } catch {
            print("Failed to update user: \(error)")
        }
    }
    
    // Function to show an alert after successful update
    private func showUpdateSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "User data updated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadProfileImageTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Upload Profile Image", message: "Choose an option", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.presentImagePicker(sourceType: .camera)
            }))
        }
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    // Function to present the image picker
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    // UIImagePickerControllerDelegate method to handle selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage // Set the selected image to the imageView
            if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                if let email = userEmail {
                    CoreDataManager.shared.saveUserProfileImage(imageData, forEmail: email)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
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
            iconImageView.frame = CGRect(x: 5, y: 2, width: 25, height: 25)
            leftView.addSubview(iconImageView)
        }
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
}
