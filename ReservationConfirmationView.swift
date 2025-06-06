import SwiftUI

struct ReservationConfirmationView: View {
    let dismissAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            Text("Rezerwacja potwierdzona!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Dziękujemy za Twoją rezerwację. Potwierdzenie zostało wysłane na Twój adres e-mail.")
                .multilineTextAlignment(.center)
                .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Wskazówki:")
                    .font(.headline)
                
                BulletPoint(text: "Przyjść 15 minut przed rozpoczęciem seansu")
                BulletPoint(text: "W kasie kina należy podać imię, nazwisko oraz numer rezerwacji")
                BulletPoint(text: "Można również pokazać kod QR z potwierdzenia wysłanego na e-mail")
                BulletPoint(text: "W przypadku pytań, prosimy o kontakt z obsługą kina")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button(action: {
                dismissAction()
            }) {
                Text("Powrót")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
        .padding()
    }
}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .font(.headline)
                .padding(.trailing, 5)
            Text(text)
                .font(.subheadline)
        }
    }
}
