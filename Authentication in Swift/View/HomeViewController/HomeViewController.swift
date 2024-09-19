import UIKit

class HomeViewController: UIViewController {

    // Define the userName property to hold the passed username
    var userName: String?

    // Label to display the username
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Show the userName in the label
        if let name = userName {
            userNameLabel.text = "Welcome, \(name)!"
        } else {
            userNameLabel.text = "Welcome!"
        }
    }
}
