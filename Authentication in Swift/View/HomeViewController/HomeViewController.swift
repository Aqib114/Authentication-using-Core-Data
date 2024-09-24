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

            // Show user details
            if let name = userName {
                userNameLabel.text = "Name: \(name)"
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
