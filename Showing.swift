import Foundation
import CoreData

@objc(Showing)
public class Showing: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var movie: Movie?
    @NSManaged public var reservations: NSSet?
    @NSManaged public var hallNumber: Int16
    @NSManaged public var availableSeats: Int16
}

extension Showing {
    @objc(addReservationsObject:)
    @NSManaged public func addToReservations(_ value: Reservation)
    
    @objc(removeReservationsObject:)
    @NSManaged public func removeFromReservations(_ value: Reservation)
    
    @objc(addReservations:)
    @NSManaged public func addToReservations(_ values: NSSet)
    
    @objc(removeReservations:)
    @NSManaged public func removeFromReservations(_ values: NSSet)
    
    static func getShowingsForMovie(movie: Movie) -> NSFetchRequest<Showing> {
        let request: NSFetchRequest<Showing> = Showing.fetchRequest() as! NSFetchRequest<Showing>
        request.predicate = NSPredicate(format: "movie == %@", movie)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }
    
    // Metoda do filtrowania seansów po dacie
    static func getShowingsByDate(date: Date) -> NSFetchRequest<Showing> {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let request = Showing.fetchRequest() as! NSFetchRequest<Showing>
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }

    // Metoda do filtrowania seansów po zakresie godzin
    static func getShowingsByTimeRange(startHour: Int, endHour: Int) -> NSFetchRequest<Showing> {
        let request: NSFetchRequest<Showing> = Showing.fetchRequest() as! NSFetchRequest<Showing>
        request.predicate = NSPredicate(format: "CAST(FORMATSTRING('%%H', date), 'integer') >= %d AND CAST(FORMATSTRING('%%H', date), 'integer') <= %d", startHour, endHour)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }
}
