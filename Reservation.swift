import Foundation
import CoreData

@objc(Reservation)
public class Reservation: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var customerName: String
    @NSManaged public var customerEmail: String
    @NSManaged public var customerPhone: String
    @NSManaged public var seatNumber: Int16
    @NSManaged public var ticketType: String 
    @NSManaged public var ticketPrice: Double
    @NSManaged public var showing: Showing?
    @NSManaged public var reservationDate: Date
}


extension Reservation {
    static let ticketTypes = [
        "Normalny": 25.0,
        "Ulgowy": 18.0,
        "Senior": 15.0,
        "Student": 20.0,
        "Dziecko": 12.0
    ]
    
    static func getReservationsForShowing(showing: Showing) -> NSFetchRequest<Reservation> {
        let request = Reservation.fetchRequest() as! NSFetchRequest<Reservation>
        request.predicate = NSPredicate(format: "showing == %@", showing)
        request.sortDescriptors = [NSSortDescriptor(key: "seatNumber", ascending: true)]
        return request
    }

    static func getReservationsByCustomer(email: String) -> NSFetchRequest<Reservation> {
        let request = Reservation.fetchRequest() as! NSFetchRequest<Reservation>
        request.predicate = NSPredicate(format: "customerEmail == %@", email)
        request.sortDescriptors = [NSSortDescriptor(key: "reservationDate", ascending: false)]
        return request
    }
}
