import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // Persistent container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Authentication_in_Swift")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Managed object context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Function to save user credentials
    func saveUserCredentials(email: String, password: String, name: String, profileimage: Data) {
        let newUser = Users(context: context)
        newUser.email = email
        newUser.password = password
        newUser.name = name
        newUser.profileimage = profileimage
        
        do {
            try context.save()
            print("User saved successfully!")
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    // Function to fetch user by email
    func fetchUser(byEmail email: String) -> Users? {
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }
    
    // Function to save user profile image
    func saveUserProfileImage(_ imageData: Data, forEmail email: String) {
        // Fetch the user from Core Data
        if let user = fetchUser(byEmail: email) {
            user.profileimage = imageData
            do {
                try context.save()
                print("Profile image saved successfully!")
            } catch {
                print("Failed to save profile image: \(error)")
            }
        } else {
            print("User not found with email: \(email)")
        }
    }
}
