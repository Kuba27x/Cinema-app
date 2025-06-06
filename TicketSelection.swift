import SwiftUI

struct TicketSelection: Identifiable {
    let id = UUID()
    let seatNumber: Int
    var ticketType: String
    
    init(seatNumber: Int, ticketType: String = "Normalny") {
        self.seatNumber = seatNumber
        self.ticketType = ticketType
    }
    
    var price: Double {
        return Reservation.ticketTypes[ticketType] ?? 25.0
    }
}
