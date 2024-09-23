import UIKit

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

        // Set user details
        userNameLabel.text = "\(userName ?? "Unknown")"
        userEmailLabel.text = "\(userEmail ?? "Unknown")"
        userCityLabel.text = "\(userCity ?? "Unknown")"
        userProfileImageView.image = userImage ?? UIImage(named: "placeholder-image")
    }
}
