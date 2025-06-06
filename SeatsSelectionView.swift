import SwiftUI
import CoreData

struct SeatsSelectionView: View {
    let showing: Showing
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var reservations: FetchedResults<Reservation>
    
    @State private var selectedSeats: Set<Int> = []
    @State private var isBookingViewPresented = false
    @State private var draggedSeats: Set<Int> = []
    @State private var dragSelectionMode: Bool? = nil
    @State private var refreshID = UUID()
    
    private let seatRows = 8
    private let seatsPerRow = 12
    
    init(showing: Showing) {
        self.showing = showing
        
        let fetchRequest = Reservation.getReservationsForShowing(showing: showing)
        _reservations = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var reservedSeats: Set<Int> {
        Set(reservations.map { Int($0.seatNumber) })
    }
    
    var formattedDateTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return dateFormatter.string(from: showing.date)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 30)
                    .cornerRadius(5)
                
                Text("EKRAN")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 30)
            
            VStack(spacing: 10) {
                ForEach(0..<seatRows, id: \.self) { row in
                    HStack(spacing: 8) {
                        Text("\(row + 1)")
                            .font(.caption)
                            .frame(width: 15)
                            .foregroundColor(.secondary)
                        
                        ForEach(0..<seatsPerRow, id: \.self) { col in
                            let seatNumber = row * seatsPerRow + col + 1
                            SeatView(
                                seatNumber: seatNumber,
                                isSelected: selectedSeats.contains(seatNumber),
                                isReserved: reservedSeats.contains(seatNumber)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSeatSelection(seatNumber)
                            }
                        }
                        
                        Text("\(row + 1)")
                            .font(.caption)
                            .frame(width: 15)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let location = value.location
                        handleGlobalDrag(location: location)
                    }
                    .onEnded { _ in
                        draggedSeats.removeAll()
                        dragSelectionMode = nil
                    }
            )
            
            HStack(spacing: 8) {
                Text("")
                    .frame(width: 15)
                
                ForEach(0..<seatsPerRow, id: \.self) { col in
                    Text("\(col + 1)")
                        .font(.caption)
                        .frame(width: 24)
                        .foregroundColor(.secondary)
                }
                
                Text("")
                    .frame(width: 15)
            }
            .padding(.horizontal)
            
            HStack(spacing: 20) {
                LegendItem(color: .gray, text: "Dostępne")
                LegendItem(color: .blue, text: "Wybrane")
                LegendItem(color: .red, text: "Zarezerwowane")
            }
            .padding()
            
            VStack {
                Text("Wybrane miejsca: \(selectedSeats.sorted().map { String($0) }.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Liczba miejsc: \(selectedSeats.count)")
                    .font(.headline)
                
                Button(action: {
                    isBookingViewPresented = true
                }) {
                    Text("Kontynuuj")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedSeats.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(selectedSeats.isEmpty)
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .padding()
        }
        .id(refreshID)
        .navigationTitle("\(showing.movie?.title ?? "Film") - \(formattedDateTime)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isBookingViewPresented, onDismiss: {
            selectedSeats = []
            refreshID = UUID()
        }) {
            if !selectedSeats.isEmpty {
                BookingDetailsView(showing: showing, selectedSeats: selectedSeats, dismissAction: {
                    isBookingViewPresented = false
                })
                .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private func handleGlobalDrag(location: CGPoint) {
        let seatSize: CGFloat = 24
        let spacing: CGFloat = 8
        let offsetX: CGFloat = 15 + spacing

        let col = Int((location.x - offsetX) / (seatSize + spacing))
        let row = Int(location.y / (seatSize + spacing))

        guard row >= 0, row < seatRows, col >= 0, col < seatsPerRow else { return }

        let seatNumber = row * seatsPerRow + col + 1

        guard !reservedSeats.contains(seatNumber),
              !draggedSeats.contains(seatNumber) else { return }

        if dragSelectionMode == nil {
            dragSelectionMode = !selectedSeats.contains(seatNumber)
        }

        if dragSelectionMode == true {
            selectedSeats.insert(seatNumber)
        } else {
            selectedSeats.remove(seatNumber)
        }

        draggedSeats.insert(seatNumber)
    }
    
    private func toggleSeatSelection(_ seatNumber: Int) {
        guard !reservedSeats.contains(seatNumber) else { return }
        if selectedSeats.contains(seatNumber) {
            selectedSeats.remove(seatNumber)
        } else {
            selectedSeats.insert(seatNumber)
        }
    }
    
    private func handleDrag(_ seatNumber: Int) {
        guard !reservedSeats.contains(seatNumber), !draggedSeats.contains(seatNumber) else { return }
        
        if dragSelectionMode == nil {
            dragSelectionMode = !selectedSeats.contains(seatNumber)
        }
        
        if dragSelectionMode == true {
            selectedSeats.insert(seatNumber)
        } else {
            selectedSeats.remove(seatNumber)
        }
        
        draggedSeats.insert(seatNumber)
    }
}

struct SeatView: View {
    let seatNumber: Int
    let isSelected: Bool
    let isReserved: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(isReserved ? Color.red : isSelected ? Color.blue : Color.gray.opacity(0.3))
                .frame(width: 24, height: 24)
            
            if isReserved {
                Image(systemName: "xmark")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
        }
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 15, height: 15)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
