# Cinema-app

Cinema-app is a movie theater seat reservation application built with SwiftUI and Core Data. The app allows users to browse movies, filter by genre, view details, select seats, and book tickets for showings in a modern and intuitive interface.

## Features

- **Movies List**: Browse the currently available movies, filter by genre, and search by title.
- **Movie Details**: View detailed information about each movie, including title, genre, and duration.
- **Seat Selection**: Intuitive seat selection interface, showing availability and allowing for multi-seat selection via tap or drag.
- **Reservation Process**:
  - Select the desired seats for a chosen showing.
  - Enter personal details (name, email, phone).
  - Choose ticket types for each seat.
  - Confirm and save the reservation.
- **Reservations Management**: View your active reservations in a dedicated panel.
- **Localization**: The app can be easily extended for localization.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **Core Data**: For persistent storage of movies, showings, and reservations.
- **MVVM Architecture**: Clean separation of concerns and maintainable codebase.

## Getting Started

1. **Clone the repository**:
   ```sh
   git clone https://github.com/Kuba27x/Cinema-app.git
   ```
2. **Open the project in Xcode**:
   - Open `Cinema-app.xcodeproj` or `Cinema-app.xcworkspace` if using Swift Package Manager or CocoaPods.
3. **Build and Run**:
   - Select a simulator or your device and run the project.

## Project Structure

- `projekcikApp.swift`: Main entry point of the app.
- `MoviesListView.swift`: Main movie listing and filtering screen.
- `MovieDetailView.swift`: Detailed movie information.
- `SeatsSelectionView.swift`: Select seats for a given showing.
- `BookingDetailsView.swift`: Enter customer information and confirm booking.
- `UserReservationsView.swift`: See your reservations.
- Model files: `Movie.swift`, `Reservation.swift`, `Showing.swift`, etc.

## License

This project is licensed under the MIT License.

---

For more information, see the [GitHub repository](https://github.com/Kuba27x/Cinema-app).
