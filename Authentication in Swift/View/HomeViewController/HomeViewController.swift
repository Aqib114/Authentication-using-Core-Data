import UIKit
import CoreData

class HomeViewController: UIViewController {

    // Define properties
    var userName: String?
    var userImage: UIImage?
    var userCity: String?
    var userEmail: String?

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserDetails()
    }

    // MARK: - UI Setup
    func setUserDetails() {
        userNameLabel.text = userName ?? "Unknown"
        userEmailLabel.text = userEmail ?? "Unknown"
        userCityLabel.text = userCity ?? "Unknown"
        userProfileImageView.image = userImage ?? UIImage(named: "placeholder-image")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUpdatedUserDetails() // Fetch updated user details
    }

    // MARK: - Fetch User Details
    private func fetchUpdatedUserDetails() {
        guard let email = userEmail else { return }
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                updateUI(with: user) // Update UI with fetched user data
            } else {
                print("No user found with email: \(email)")
            }
        } catch {
            print("Failed to fetch updated user details: \(error)")
        }
    }

    // MARK: - Update UI
    private func updateUI(with user: Users) {
        userNameLabel.text = user.name ?? "Unknown"
        userCityLabel.text = user.city ?? "Unknown"
        userProfileImageView.image = user.profileimage != nil ? UIImage(data: user.profileimage!) : UIImage(named: "placeholder-image")
        print("Fetched updated user data: Name - \(user.name ?? ""), City - \(user.city ?? "")")
    }

    @IBAction func editButtonTapped(_ sender: UIButton) {
        let editUserVC = EditViewController(nibName: "EditViewController", bundle: nil)
        
        // Pass the current user data to the EditViewController
        editUserVC.userName = userName
        editUserVC.userCity = userCity
        editUserVC.userImage = userImage
        editUserVC.userEmail = userEmail
        
        // Check if navigationController is available
        if let navController = navigationController {
            navController.pushViewController(editUserVC, animated: true)
        } else {
            print("Navigation controller is nil!")
        }
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        // Create a UIAlertController with the option for full delete only
        let alertController = UIAlertController(title: "Delete Confirmation", message: "Do you want to delete all user data?", preferredStyle: .alert)

        // Full delete action
        let deleteAllAction = UIAlertAction(title: "Delete All Data", style: .destructive) { _ in
            self.deleteAllData()
        }

        // Add action to the alert controller
        alertController.addAction(deleteAllAction)

        // Add a cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    // Function to delete all user data
    private func deleteAllData() {
        guard let email = userEmail else { return }
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                context.delete(user)
                try context.save()
                print("User data deleted successfully")
                navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Failed to delete user: \(error)")
        }
    }
}
