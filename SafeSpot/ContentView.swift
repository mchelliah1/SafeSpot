//
//  ContentView.swift
//  SafeSpot
//
//  Created by Matthew Chelliah on 8/3/24.
//
//
//  ContentView.swift
//  SafeSpot
//
//  Created by Matthew Chelliah on 8/3/24.
//
import SwiftUI
import Firebase
import FirebaseAuth
import MapKit
import Alamofire
struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var showingLoginScreen = false
    @State private var showPopUp = false // State variable to show custom pop-up
    @State private var showingForgotPassword = false // State variable to show Forgot Password view
    @State private var showingRegisterScreen = false // State variable to show Register view
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    TextField("Email", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                        
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Login") {
                        authenticateUser(username: username, password: password)
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
                    
                    Button("Create Account") {
                        showingRegisterScreen = true
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    Button("Forgot Password?") {
                        showingForgotPassword = true
                    }
                    .foregroundColor(.blue)
                    .padding()
                    
                    NavigationLink(destination: HomeScreenView(), isActive: $showingLoginScreen) {
                       EmptyView()
                    }
                    
                    NavigationLink(destination: ForgotPasswordView(), isActive: $showingForgotPassword) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: RegisterView(), isActive: $showingRegisterScreen) {
                        EmptyView()
                    }
                }
                
                if showPopUp {
                    GeometryReader { geometry in
                        CustomPopUp(showPopUp: $showPopUp)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .background(Color.black.opacity(0.5))
                            .edgesIgnoringSafeArea(.all)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
            }.navigationBarHidden(true)
        }
    }
    
    func authenticateUser(username: String, password: String) {
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                wrongUsername = 2
                wrongPassword = 2
                showPopUp = true
            } else {
                wrongUsername = 0
                wrongPassword = 0
                showingLoginScreen = true
            }
        }
    }
}
struct RegisterView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmationMessage = ""
    @State private var showConfirmation = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            Color(.blue.opacity(1.0))
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white)
            VStack {
                Text("Register")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Email", text: $username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                Button("Register") {
                    registerUser(username: username, password: password)
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.green)
                .cornerRadius(10)
                .padding(.bottom, 20)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if showConfirmation {
                    Text(confirmationMessage)
                        .foregroundColor(.green)
                        .padding()
                }
            }
            .padding()
        }
    }
    func registerUser(username: String, password: String) {
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
                showConfirmation = false
            } else {
                errorMessage = nil
                confirmationMessage = "User registered successfully! You can now log in."
                showConfirmation = true
            }
        }
    }
}
struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showConfirmation = false
    @State private var errorMessage: String?
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white)
            VStack {
                Text("Forgot Password")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                TextField("Enter your email", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.bottom, 20)

                Button("Reset Password") {
                    resetPassword(email: email)
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.bottom, 20)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                if showConfirmation {
                    Text("Password reset instructions sent to \(email)")
                        .foregroundColor(.green)
                        .padding()
                }
            }
            .padding()
        }
    }

    func resetPassword(email: String) {
        // Simulate a password reset operation
        if isValidEmail(email) {
            // Simulate successful password reset
            showConfirmation = true
            errorMessage = nil
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
              // ...
            }
        } else {
            // Show error message
            errorMessage = "Please enter a valid email address."
            showConfirmation = false
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Simple regex to validate email
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
struct CustomPopUp: View {
    @Binding var showPopUp: Bool
    
    var body: some View {
        VStack {
            Text("Invalid Username or Password")
                .font(.headline)
                .padding()
            
            Button(action: {
                showPopUp = false
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 100)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .frame(width: 300, height: 150)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .transition(.scale)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct HomeScreenView: View {
    @State private var selectedTab = 0 // State to track the selected tab
    @State private var searchText = "" // State to track search text
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedLocation: CLLocationCoordinate2D? = nil // Track selected location
    @State private var isLocationSelected = false // Track if a location is selected
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Home Screen with Map and Search
            ZStack {
                MapView(region: $mapRegion, selectedLocation: $selectedLocation)
                    .ignoresSafeArea()
                
                VStack {
                    // Parking search
                    VStack(spacing: 10) {
                        HStack {
                            TextField("Enter location", text: $searchText, onCommit: {
                                searchLocation()
                            })
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // Find Parking Button
                    Button(action: {
                        searchLocation()
                    }) {
                        Text("Find Parking")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                    
                    // Confirm Location Button (only visible when a location is selected)
                    if isLocationSelected {
                        Button(action: {
                            confirmLocation()
                        }) {
                            Text("Confirm Location")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .tabItem {
                Image(systemName: "map.fill")
                Text("Home")
            }
            .tag(0)
            
            // History Screen
            RideHistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
                .tag(1)
            
            // Help Screen
            HelpView()
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Help")
                }
                .tag(2)
            
            // Account Settings Screen
            AccountSettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Account")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
    
    private func searchLocation() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                mapRegion.center = location.coordinate
                mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                selectedLocation = location.coordinate
                isLocationSelected = true
            }
        }
    }
    
    private func confirmLocation() {
        guard let location = selectedLocation else { return }
        // Handle location confirmation logic here
        print("Location confirmed: \(location.latitude), \(location.longitude)")
        // Perform any further actions after confirming the location
    }
}

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedLocation: CLLocationCoordinate2D?
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: selectedLocation.map { [Location(coordinate: $0)] } ?? []) { location in
            MapPin(coordinate: location.coordinate)
        }
    }
}

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
// Ride History View
struct RideHistoryView: View {
    var body: some View {
        VStack {
            Text("Parking History")
                .font(.largeTitle)
                .bold()
                .padding()
            
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Parked at Central Garage")
                            .font(.headline)
                        Text("Date: Sep 12, 2024")
                        Text("Duration: 2 hours")
                    }
                    Spacer()
                    Button("Details") {
                        // Action to show details
                    }
                    .foregroundColor(.blue)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Parked at Downtown Lot")
                            .font(.headline)
                        Text("Date: Sep 10, 2024")
                        Text("Duration: 3 hours")
                    }
                    Spacer()
                    Button("Details") {
                        // Action to show details
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
    }
}

// Help View
struct HelpView: View {
    var body: some View {
        VStack {
            Text("Help Center")
                .font(.largeTitle)
                .bold()
                .padding()
            
            List {
                VStack(alignment: .leading, spacing: 10) {
                    Text("How to Find Parking")
                        .font(.headline)
                    Button("Learn More") {
                        // Action to show more information
                    }
                    .foregroundColor(.blue)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Payment Issues")
                        .font(.headline)
                    Button("Learn More") {
                        // Action to show more information
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
    }
}

// Account Settings View with Save Functionality
struct AccountSettingsView: View {
    @State private var name: String = UserDefaults.standard.string(forKey: "userName") ?? "John Doe"
    @State private var email: String = UserDefaults.standard.string(forKey: "userEmail") ?? "john.doe@example.com"
    @State private var phone: String = UserDefaults.standard.string(forKey: "userPhone") ?? "+1 234 567 890"
    @State private var showSuccessMessage = false
    
    var body: some View {
        VStack {
            Text("Account Settings")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Name", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        TextField("Email", text: $email)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Phone")
                        Spacer()
                        TextField("Phone", text: $phone)
                            .multilineTextAlignment(.trailing)
                    }
                    Button("Save Changes") {
                        saveChanges()
                    }
                }
                
                Section(header: Text("Security")) {
                    Button("Change Password") {
                        // Action to change password
                    }
                    Button("Enable Two-Factor Authentication") {
                        // Action to toggle two-factor authentication
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Button("Change Language") {
                        // Action to change language
                    }
                    Button("Change Currency") {
                        // Action to change currency
                    }
                }
            }
            .padding(.top)
            
            if showSuccessMessage {
                Text("Changes saved successfully!")
                    .foregroundColor(.green)
                    .padding(.top)
            }
        }
        .background(Color.gray.opacity(0.1))
    }
    
    private func saveChanges() {
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(phone, forKey: "userPhone")
        showSuccessMessage = true
    }
}

// Preview
struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
