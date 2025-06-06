import SwiftUI
import CoreData

struct UserReservationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var userEmail = ""
    @State private var isEmailEntered = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if !isEmailEntered {
                    VStack(spacing: 20) {
                        Text("Podaj adres e-mail, aby zobaczyć swoje rezerwacje")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        TextField("Email", text: $userEmail)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        Button(action: {
                            if isValidEmail(userEmail) {
                                isEmailEntered = true
                            } else {
                                alertMessage = "Podaj poprawny adres e-mail"
                                showAlert = true
                            }
                        }) {
                            Text("Pokaż rezerwacje")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 50)
                } else {
                    ReservationListView(userEmail: userEmail)
                }
            }
            .navigationTitle("Moje rezerwacje")
            .navigationBarItems(trailing: Button("Zamknij") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Błąd"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}


struct ReservationListView: View {
    let userEmail: String
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var reservations: FetchedResults<Reservation>
    
    init(userEmail: String) {
        self.userEmail = userEmail
        
        let fetchRequest = Reservation.getReservationsByCustomer(email: userEmail)
        _reservations = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var groupedReservations: [(Showing, [Reservation])] {
        let dict = Dictionary(grouping: reservations) { $0.showing! }
        return dict.sorted { $0.key.date > $1.key.date }
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter
    }()
    
    var body: some View {
        if reservations.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "ticket.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Text("Nie znaleziono rezerwacji")
                    .font(.headline)
                
                Text("Dla podanego adresu e-mail nie znaleziono żadnych rezerwacji.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        } else {
            List {
                ForEach(groupedReservations, id: \.0.id) { showing, reservationsForShowing in
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            if let movie = showing.movie {
                                Text(movie.title)
                                    .font(.headline)
                            }
                            
                            
                            Text("Seans: \(Self.dateFormatter.string(from: showing.date))")
                                .font(.subheadline)
                            
                            Text("Sala: \(showing.hallNumber)")
                                .font(.subheadline)
                            
                            Divider()
                            
                            Text("Miejsca:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            ForEach(reservationsForShowing, id: \.id) { reservation in
                                HStack {
                                    Text("Miejsce \(reservation.seatNumber)")
                                    Spacer()
                                    Text("\(reservation.ticketType)")
                                    Text("\(reservation.ticketPrice, specifier: "%.2f") zł")
                                        .foregroundColor(.secondary)
                                }
                                .font(.subheadline)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Razem:")
                                    .fontWeight(.bold)
                                Spacer()
                                let total = reservationsForShowing.reduce(0) { $0 + $1.ticketPrice }
                                Text("\(total, specifier: "%.2f") zł")
                                    .fontWeight(.bold)
                            }
                            
                            let resDate = reservationsForShowing.first?.reservationDate ?? Date()
                            Text("Data rezerwacji: \(Self.dateFormatter.string(from: resDate))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 5)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    
}
