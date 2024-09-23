import UIKit
import CoreData

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Properties for user details
    var userName: String?
    var userCity: String?
    var userImage: UIImage?
    var userEmail: String?
    
    // Outlets for the UI elements
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDismissKeyboardGesture()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        // Set initial values from the current user data
        customizeTextFields(nameTextField, icon: UIImage(systemName: "person.crop.circle.fill"))
        customizeTextFields(cityTextField, icon: UIImage(systemName: "globe.americas.fill"))
        profileImageView.image = userImage ?? UIImage(named: "placeholder-image")
        nameTextField.text = userName
        cityTextField.text = userCity
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
            // Optionally navigate back or perform additional actions
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
            
            // Convert image to Data
            if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                // Save the image data to Core Data
                if let email = userEmail { // Ensure userEmail is accessible here
                    CoreDataManager.shared.saveUserProfileImage(imageData, forEmail: email)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
