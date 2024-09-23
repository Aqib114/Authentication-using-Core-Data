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
        // Set initial values from the current user data
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

        // Fetch the user from Core Data using the email
        let context = PersistenceService.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.name = name
                user.city = city
                
                // Update the profile image if it's changed
                if let newImage = profileImageView.image, let imageData = newImage.pngData() {
                    user.profileimage = imageData
                }
                
                // Save the updated user details
                try context.save()
                print("User details updated successfully: Name - \(user.name ?? ""), City - \(user.city ?? "")")
                
                // Go back to the Home screen
                navigationController?.popViewController(animated: true)
            } else {
                print("No user found with email: \(email)")
            }
        } catch {
            print("Failed to update user: \(error)")
        }
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
}
