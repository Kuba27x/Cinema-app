import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "projekcik")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data stores: \(error.localizedDescription)")
            }
        }
        
        let context = container.viewContext
        let request: NSFetchRequest<Movie> = Movie.fetchRequest() as! NSFetchRequest<Movie>
        request.fetchLimit = 1

        if let count = try? context.count(for: request), count == 0 {
            addSampleData(context: context)
        }
    }
    
    private func addSampleData(context: NSManagedObjectContext) {
        let showtimes: [String] = ["10:00", "12:30", "15:00", "17:30", "20:00"]
        
        let movie1 = Movie(context: context)
        movie1.id = UUID()
        movie1.title = "Incepcja"
        movie1.movieDescription = "Złodziej, który kradnie korporacyjne sekrety za pomocą technologii dzielenia się snami."
        movie1.imageUrl = "inception"
        movie1.duration = 148
        movie1.genre = "Sci-Fi"

        let movie2 = Movie(context: context)
        movie2.id = UUID()
        movie2.title = "Mroczny Rycerz"
        movie2.movieDescription = "Kiedy złośliwy Joker sieje chaos w Gotham, Batman staje przed największym wyzwaniem."
        movie2.imageUrl = "darknight"
        movie2.duration = 152
        movie2.genre = "Akcja"

        let movie3 = Movie(context: context)
        movie3.id = UUID()
        movie3.title = "Toy Story 4"
        movie3.movieDescription = "Kiedy nowa zabawka, Forky, dołącza do Woody'ego i reszty, podróż drogowa ujawnia, jak wielki może być świat dla zabawki."
        movie3.imageUrl = "toy4"
        movie3.duration = 100
        movie3.genre = "Animowany"

        let movie4 = Movie(context: context)
        movie4.id = UUID()
        movie4.title = "Minecraft"
        movie4.movieDescription = "W blokowym świecie Minecrafta, gracze muszą zbierać zasoby, tworzyć przedmioty i przetrwać w ciągle zmieniającym się środowisku."
        movie4.imageUrl = "minecraft"
        movie4.duration = 120
        movie4.genre = "Przygodowy"

        let movie5 = Movie(context: context)
        movie5.id = UUID()
        movie5.title = "Jak wytresować smoka"
        movie5.movieDescription = "Młody Wiking zaprzyjaźnia się z smokiem, zmieniając bieg historii na swojej wyspie."
        movie5.imageUrl = "smok"
        movie5.duration = 98
        movie5.genre = "Animowany"

        let movie6 = Movie(context: context)
        movie6.id = UUID()
        movie6.title = "Szpiedzy"
        movie6.movieDescription = "Grupa tajnych agentów o unikalnych umiejętnościach musi współpracować, aby udaremnić globalny spisek."
        movie6.imageUrl = "szpiedzy "
        movie6.duration = 135
        movie6.genre = "Akcja"

        let movie7 = Movie(context: context)
        movie7.id = UUID()
        movie7.title = "Lilo i Stitch"
        movie7.movieDescription = "Młoda dziewczyna z Hawajów zaprzyjaźnia się z psotnym obcym, a razem próbują uniknąć schwytania."
        movie7.imageUrl = "lilo"
        movie7.duration = 85
        movie7.genre = "Animowany"

        let today = Date()
        let calendar = Calendar.current
        
        for i in 0..<2 {
            for time in showtimes {
                let showing = Showing(context: context)
                showing.id = UUID()
                
                let components = time.split(separator: ":")
                let hour = Int(components[0])!
                let minute = Int(components[1])!
                
                let showingTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: calendar.date(byAdding: .day, value: i, to: today)!)!
                showing.date = showingTime
                
                showing.movie = movie1
                showing.hallNumber = Int16(Int.random(in: 1...3))
                showing.availableSeats = 96
            }
        }
        
        for i in 0..<2 {
            for time in showtimes {
                let showing = Showing(context: context)
                showing.id = UUID()
                
                let components = time.split(separator: ":")
                let hour = Int(components[0])!
                let minute = Int(components[1])!
                
                let showingTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: calendar.date(byAdding: .day, value: i, to: today)!)!
                showing.date = showingTime
                
                showing.movie = movie2
                showing.hallNumber = Int16(Int.random(in: 1...3))
                showing.availableSeats = 96
            }
        }
        
        for i in 0..<2 {
            for time in showtimes {
                let showing = Showing(context: context)
                showing.id = UUID()
                
                let components = time.split(separator: ":")
                let hour = Int(components[0])!
                let minute = Int(components[1])!
                
                let showingTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: calendar.date(byAdding: .day, value: i, to: today)!)!
                showing.date = showingTime
                
                showing.movie = movie3
                showing.hallNumber = Int16(Int.random(in: 1...3))
                showing.availableSeats = 96
            }
        }
        
        for i in 0..<2 {
            for time in showtimes {
                let showing = Showing(context: context)
                showing.id = UUID()
                
                let components = time.split(separator: ":")
                let hour = Int(components[0])!
                let minute = Int(components[1])!
                
                let showingTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: calendar.date(byAdding: .day, value: i, to: today)!)!
                showing.date = showingTime
                
                showing.movie = movie4
                showing.hallNumber = Int16(Int.random(in: 1...3))
                showing.availableSeats = 96
            }
        }

        for i in 0..<2 {
            for time in showtimes {
                let showing = Showing(context: context)
                showing.id = UUID()
                
                let components = time.split(separator: ":")
                let hour = Int(components[0])!
                let minute = Int(components[1])!
                
                let showingTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: calendar.date(byAdding: .day, value: i, to: today)!)!
                showing.date = showingTime
                
                showing.movie = movie5
                showing.hallNumber = Int16(Int.random(in: 1...3))
                showing.availableSeats = 96
            }
        }

        for i in 0..<2 {
            for time in showtimes {
                let showing = Showing(context: context)
                showing.id = UUID()
                
                let components = time.split(separator: ":")
                let hour = Int(components[0])!
                let minute = Int(components[1])!
                
                let showingTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: calendar.date(byAdding: .day, value: i, to: today)!)!
                showing.date = showingTime
                
                showing.movie = movie6
                showing.hallNumber = Int16(Int.random(in: 1...3))
                showing.availableSeats = 96
            }
        }

        for i in 0..<2 {
            for time in showtimes {
                let showing = Showing(context: context)
                showing.id = UUID()
                
                let components = time.split(separator: ":")
                let hour = Int(components[0])!
                let minute = Int(components[1])!
                
                let showingTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: calendar.date(byAdding: .day, value: i, to: today)!)!
                showing.date = showingTime
                
                showing.movie = movie7
                showing.hallNumber = Int16(Int.random(in: 1...3))
                showing.availableSeats = 96
            }
        }

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error saving context: \(nsError.userInfo)")
        }
    }
}
