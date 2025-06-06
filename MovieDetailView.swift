import SwiftUI
import CoreData

struct MovieDetailView: View {
    let movie: Movie
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var showings: FetchedResults<Showing>
    
    @State private var selectedDate: Date = Date()
    @State private var selectedTimeRange: String = "Wszystkie"
    @State private var selectedShowingDate: Date?
    @State private var isImageExpanded = false
    
    let timeRanges = ["Wszystkie", "Poranek (8-12)", "Popołudnie (12-17)", "Wieczór (17-22)", "Noc (22-24)"]
    
    var timeRangeMapping: [String: (Int, Int)] {
        return [
            "Poranek (8-12)": (8, 12),
            "Popołudnie (12-17)": (12, 17),
            "Wieczór (17-22)": (17, 22),
            "Noc (22-24)": (22, 24)
        ]
    }
    
    init(movie: Movie) {
        self.movie = movie
        
        let fetchRequest = Showing.getShowingsForMovie(movie: movie)
        _showings = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var filteredShowings: [Showing] {
        let calendar = Calendar.current
        let startOfSelectedDay = calendar.startOfDay(for: selectedDate)
        let endOfSelectedDay = calendar.date(byAdding: .day, value: 1, to: startOfSelectedDay)!
        
        var filtered = showings.filter { showing in
            let showingDate = showing.date
            return showingDate >= startOfSelectedDay && showingDate < endOfSelectedDay
        }
        
        if selectedTimeRange != "Wszystkie", let (startHour, endHour) = timeRangeMapping[selectedTimeRange] {
            filtered = filtered.filter { showing in
                let hour = calendar.component(.hour, from: showing.date)
                return hour >= startHour && hour < endHour
            }
        }
        
        return filtered
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .topTrailing) {
                    Image(movie.imageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: isImageExpanded ? 400 : 250)
                        .clipped()
                        .scaleEffect(isImageExpanded ? 1.1 : 1.0)
                        .animation(.spring(), value: isImageExpanded)
                        .onTapGesture {
                            withAnimation {
                                isImageExpanded.toggle()
                            }
                        }
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(movie.duration) min")
                            .font(.caption)
                            .padding(5)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        
                        Text(movie.genre)
                            .font(.caption)
                            .padding(5)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .padding(8)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(movie.movieDescription)
                        .font(.body)
                        .lineLimit(nil)
                        .padding(.bottom, 10)
                    
                    Divider()
                    
                    Text("Dostępne seanse")
                        .font(.headline)
                        .padding(.top, 5)
                    
                    DatePicker("Wybierz datę", selection: $selectedDate, displayedComponents: .date)
                        .padding(.vertical, 5)
                        .onChange(of: selectedDate) { _ in
                            selectedShowingDate = nil
                        }
                    
                    Picker("Pora dnia", selection: $selectedTimeRange) {
                        ForEach(timeRanges, id: \.self) { range in
                            Text(range).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 10)
                    .onChange(of: selectedTimeRange) { _ in
                        selectedShowingDate = nil
                    }
                    
                    if filteredShowings.isEmpty {
                        Text("Brak dostępnych seansów w wybranym terminie")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(filteredShowings, id: \.id) { showing in
                                    ShowingItemView(showing: showing, isSelected: selectedShowingDate == showing.date)
                                        .onTapGesture {
                                            selectedShowingDate = showing.date
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 110)
                        
                        if let selectedDate = selectedShowingDate,
                           let selectedShowing = filteredShowings.first(where: { $0.date == selectedDate }) {
                            
                            NavigationLink(destination: SeatsSelectionView(showing: selectedShowing)) {
                                Text("Wybierz miejsca")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Szczegóły filmu")
        .gesture(
            MagnificationGesture()
                .onChanged { scale in
                    if scale > 1 {
                        isImageExpanded = true
                    } else {
                        isImageExpanded = false
                    }
                }
        )
    }
}

struct ShowingItemView: View {
    let showing: Showing
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Text(dateFormatter.string(from: showing.date))
                .font(.subheadline)
            
            Text(timeFormatter.string(from: showing.date))
                .font(.headline)
            
            Text("Sala \(showing.hallNumber)")
                .font(.caption)
            
            Text("\(showing.availableSeats) miejsc")
                .font(.caption2)
                .foregroundColor(showing.availableSeats > 10 ? .green : .orange)
        }
        .padding(10)
        .frame(width: 100)
        .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}
