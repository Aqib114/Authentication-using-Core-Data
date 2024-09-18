import Foundation
import CoreData
import UIKit
class DataBaseHelper {
    
    static var sharedInstance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func create(object : [String : String]){
        let Users = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context!) as! Users
        Users.name = object["name"]
        Users.email = object["email"]
        Users.password = object["password"]
        
        
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
