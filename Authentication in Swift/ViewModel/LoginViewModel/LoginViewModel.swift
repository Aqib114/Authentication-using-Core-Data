import Foundation
import CoreData

class LoginViewModel {
    
    func authenticateUser(email: String, password: String) -> Bool {
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let users = try PersistenceService.context.fetch(fetchRequest)
            return !users.isEmpty
        } catch {
            print("Error fetching user: \(error)")
            return false
        }
    }
    
    func getUserName(email: String) -> String? {
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try PersistenceService.context.fetch(fetchRequest)
            return users.first?.name
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
}
