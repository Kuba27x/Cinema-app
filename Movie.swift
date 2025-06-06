import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var movieDescription: String
    @NSManaged public var imageUrl: String
    @NSManaged public var duration: Int16
    @NSManaged public var genre: String 
    @NSManaged public var showings: NSSet?
    
    static let categories = ["Akcja", "Sci-Fi", "Animowany", "Dokumentalny", "Przygodowy"]
}

extension Movie {
    @objc(addShowingsObject:)
    @NSManaged public func addToShowings(_ value: Showing)
    
    @objc(removeShowingsObject:)
    @NSManaged public func removeFromShowings(_ value: Showing)
    
    @objc(addShowings:)
    @NSManaged public func addToShowings(_ values: NSSet)
    
    @objc(removeShowings:)
    @NSManaged public func removeFromShowings(_ values: NSSet)
    
    static func getAllMovies() -> NSFetchRequest<Movie> {
        let request = Movie.fetchRequest() as! NSFetchRequest<Movie>
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            return request
    }
    
    static func getMoviesByGenre(genre: String) -> NSFetchRequest<Movie> {
        let request = Movie.fetchRequest() as! NSFetchRequest<Movie>
        request.predicate = NSPredicate(format: "genre == %@", genre)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }
}



