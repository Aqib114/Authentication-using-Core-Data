import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var deviceId: String?
    @NSManaged public var isLoggedIn: Bool
    @NSManaged public var loginTimestamp: Date?
    @NSManaged public var userId: UUID?

}
