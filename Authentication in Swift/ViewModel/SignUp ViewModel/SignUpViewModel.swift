import Foundation
import CoreData
import UIKit
class SignUpViewModel {
    
    static var sharedInstance = SignUpViewModel()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func create(object : [String : Any]){
        let Users = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context!) as! Users
        Users.name = object["name"] as? String
        Users.email = object["email"] as? String
        Users.password = object["password"] as? String
        Users.city = object["city"] as? String
        Users.profileimage = object["imageData"] as? Data
        
        
        do{
            try context?.save()
        }
        catch{
            print("User is not created.")
        }
    }
    func isEmailExists(email: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let count = try context?.count(for: fetchRequest)
            return count ?? 0 > 0
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
            return false
        }
    }
}
