import UIKit

class HomeViewController: UIViewController {

    // Define the userName property to hold the passed username
    var userName: String?
    var userImage: UIImage?
    var userCity: String?
    var userEmail: String?

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!

    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
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

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
           logoutUser()
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
                userNameLabel.text = "Name: Unknown"
            }

            if let email = userEmail {
                userEmailLabel.text = "Email: \(email)"
            } else {
                userEmailLabel.text = "Email: Unknown"
            }

            if let city = userCity {
                userCityLabel.text = "City: \(city)"
            } else {
                userCityLabel.text = "City: Unknown"
            }

            if let image = userImage {
                userProfileImageView.image = image
            } else {
                userProfileImageView.image = UIImage(named: "placeholder-image")
            }
        }
    }
    
    
    func logoutUser() {
        // Clear login state
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userCity")
        UserDefaults.standard.removeObject(forKey: "userProfileImage")
        
        // Navigate back to the Login screen
        let loginController = LoginViewController.loadFromNib()
        if let navController = navigationController {
            navController.setViewControllers([loginController], animated: true)
        }
    }

}
