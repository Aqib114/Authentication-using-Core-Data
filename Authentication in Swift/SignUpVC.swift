//
//  SignUpVC.swift
//  Authentication in Swift
//
//  Created by Mapple.pk on 13/09/2024.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    
    static func loadFromNib() -> SignUpVC{
        SignUpVC(nibName: "SignUpVC", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTextFields(txtName, icon: UIImage(named: "profile"))
        customizeTextFields(txtEmail, icon: UIImage(named: "email"))
        customizeTextFields(txtPassword, icon: UIImage(named: "pass"))
        customizeTextFields(txtConfirmPassword, icon: UIImage(named: "pass"))
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func customizeTextFields(_ textfield : UITextField, icon : UIImage?){
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 100
        textfield.layer.shadowColor = UIColor.black.cgColor
        textfield.layer.shadowOpacity = 0.3
        textfield.layer.shadowOffset = CGSize(width: 0, height: 1)
        textfield.layer.shadowRadius = 8
        let leftView = UIView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        if let iconImage = icon {
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.tintColor = .gray
            iconImageView.contentMode = .scaleAspectFill
            iconImageView.frame = CGRect(x: 10, y: 10, width: 14, height: 14)
        
            leftView.addSubview(iconImageView)
        }
        textfield.leftView = leftView
        textfield.leftViewMode = .always
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
