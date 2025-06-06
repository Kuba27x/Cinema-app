import SwiftUI

@main
struct projekcikApp: App {
    let persistenceController = PersistenceController.shared
        
        var body: some Scene {
            WindowGroup {
                MoviesListView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
