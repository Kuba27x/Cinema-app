import SwiftUI
import CoreData

struct MoviesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Movie.getAllMovies())
    private var movies: FetchedResults<Movie>
    
    @State private var searchText = ""
    @State private var showFilterMenu = false
    @State private var selectedGenre: String?
    @State private var showingUserReservations = false
    @State private var shakeMovieId: UUID? = nil
    
    var filteredMovies: [Movie] {
        let result: [Movie]
        
        if let genre = selectedGenre, !genre.isEmpty {
            let genreFiltered = movies.filter { $0.genre == genre }
            result = searchText.isEmpty
                ? Array(genreFiltered)
                : genreFiltered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        } else if searchText.isEmpty {
            result = Array(movies)
        } else {
            result = movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }

        return result
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if showFilterMenu {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            GenreFilterButton(title: "Wszystkie", isSelected: selectedGenre == nil) {
                                selectedGenre = nil
                            }
                            
                            ForEach(Movie.categories, id: \.self) { genre in
                                GenreFilterButton(title: genre, isSelected: selectedGenre == genre) {
                                    selectedGenre = genre
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                }
                
                List {
                    ForEach(filteredMovies, id: \.id) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            HStack {
                                Image(movie.imageUrl)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 120)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(movie.title)
                                        .font(.headline)
                                    
                                    Text("\(movie.duration) min • \(movie.genre)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.leading, 5)
                            }
                            .padding(.vertical, 5)
                            .offset(x: shakeMovieId == movie.id ? -10 : 0)
                            .animation(shakeMovieId == movie.id ? Animation.default.repeatCount(3, autoreverses: true).speed(6) : .default, value: shakeMovieId)
                        }
                        .gesture(
                            LongPressGesture(minimumDuration: 1.0)
                                .onEnded { _ in
                                    shakeMovieId = movie.id
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                                        shakeMovieId = nil
                                    }
                                }
                        )
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Repertuar")
            .searchable(text: $searchText, prompt: "Szukaj filmu...")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            showFilterMenu.toggle()
                        }
                    }) {
                        Label("Filtry", systemImage: "line.horizontal.3.decrease.circle\(showFilterMenu ? ".fill" : "")")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingUserReservations = true
                    }) {
                        Label("Moje rezerwacje", systemImage: "ticket")
                    }
                }
            }
            .sheet(isPresented: $showingUserReservations) {
                UserReservationsView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
}

struct GenreFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}
