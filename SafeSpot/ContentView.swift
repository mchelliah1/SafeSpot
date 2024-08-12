//
//  ContentView.swift
//  SafeSpot
//
//  Created by Matthew Chelliah on 8/3/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

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
                    
                    NavigationLink(destination: Text("You are logged in @\(username)"), isActive: $showingLoginScreen) {
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
