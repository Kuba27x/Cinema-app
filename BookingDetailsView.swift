import SwiftUI
import CoreData

struct BookingDetailsView: View {
    let showing: Showing
    let selectedSeats: Set<Int>
    let dismissAction: () -> Void
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var customerName = ""
    @State private var customerEmail = ""
    @State private var customerPhone = ""
    @State private var isShowingConfirmation = false
    @State private var isShowingError = false
    @State private var errorMessage = ""
    
    @State private var ticketSelections: [TicketSelection] = []
    
    var totalPrice: Double {
        return ticketSelections.reduce(0) { $0 + $1.price }
    }
    
    init(showing: Showing, selectedSeats: Set<Int>, dismissAction: @escaping () -> Void) {
        self.showing = showing
        self.selectedSeats = selectedSeats
        self.dismissAction = dismissAction
        
        _ticketSelections = State(initialValue: selectedSeats.sorted().map { TicketSelection(seatNumber: $0) })
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informacje o rezerwacji")) {
                    Text("Film: \(showing.movie?.title ?? "Nieznany")")
                    
                    Text("Seans: \(dateFormatter.string(from: showing.date))")
                    
                    Text("Sala: \(showing.hallNumber)")
                }
                
                Section(header: Text("Wybór rodzaju biletów")) {
                    
                    ForEach(0..<ticketSelections.count, id: \.self) { index in
                        TicketSelectionRow(selection: $ticketSelections[index])
                    }
                    
                    HStack {
                        Text("Razem:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(totalPrice, specifier: "%.2f") zł")
                            .fontWeight(.bold)
                    }
                    .padding(.top, 5)
                }
                
                Section(header: Text("Dane kontaktowe")) {
                    TextField("Imię i nazwisko", text: $customerName)
                        .autocapitalization(.words)
                    
                    TextField("E-mail", text: $customerEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    TextField("Telefon", text: $customerPhone)
                        .keyboardType(.phonePad)
                }
                
                Section {
                    Button(action: {
                        if validateInputs() {
                            saveReservation()
                            isShowingConfirmation = true
                        }
                    }) {
                        Text("Potwierdź rezerwację")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Dane rezerwacji")
            .navigationBarItems(trailing: Button("Anuluj") {
                dismissAction()
            })
            .alert(isPresented: $isShowingError) {
                Alert(
                    title: Text("Błąd"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $isShowingConfirmation) {
                ReservationConfirmationView(dismissAction: dismissAction)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 100 {
                            dismissAction()
                        }
                    }
            )
        }
    }

    private func validateInputs() -> Bool {
        if customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Podaj imię i nazwisko"
            isShowingError = true
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: customerEmail) {
            errorMessage = "Podaj poprawny adres e-mail"
            isShowingError = true
            return false
        }
        
        let phoneRegex = "^[0-9+]{9,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phonePredicate.evaluate(with: customerPhone) {
            errorMessage = "Podaj poprawny numer telefonu"
            isShowingError = true
            return false
        }
        
        return true
    }

    private func saveReservation() {
        for ticketSelection in ticketSelections {
            let reservation = Reservation(context: viewContext)
            reservation.id = UUID()
            reservation.customerName = customerName
            reservation.customerEmail = customerEmail
            reservation.customerPhone = customerPhone
            reservation.seatNumber = Int16(ticketSelection.seatNumber)
            reservation.ticketType = ticketSelection.ticketType
            reservation.ticketPrice = ticketSelection.price
            reservation.showing = showing
            reservation.reservationDate = Date()
        }
        
        showing.availableSeats = showing.availableSeats - Int16(selectedSeats.count)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving reservation: \(nsError.localizedDescription)")
        }
    }
}

struct TicketSelectionRow: View {
    @Binding var selection: TicketSelection

    var body: some View {
        HStack {
            Text("Miejsce \(selection.seatNumber)")
                .frame(width: 90, alignment: .leading)

            Picker("", selection: $selection.ticketType) {
                ForEach(Array(Reservation.ticketTypes.keys), id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Spacer()

            Text("\(selection.price, specifier: "%.2f") zł")
                .foregroundColor(.secondary)
        }
    }
}
