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
    @State private var showPopUp = false
    @State private var showingForgotPassword = false
    @State private var showingRegisterScreen = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Text("SafeSpot")
                        .font(.system(size: 60, weight: .black, design: .serif))
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors: [.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .overlay(
                            Text("SafeSpot")
                                .font(.system(size: 60, weight: .black, design: .serif))
                                .foregroundColor(.clear)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.5), .clear]), startPoint: .top, endPoint: .bottom)
                                )
                                .mask(
                                    Text("SafeSpot")
                                        .font(.system(size: 60, weight: .black, design: .serif))
                                )
                        )
                    TextField("Email", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: CGFloat(wrongUsername)))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: CGFloat(wrongPassword)))
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                    
                    Button("Login") {
                        authenticateUser(username: username, password: password)
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    
                    Button("Create Account") {
                        showingRegisterScreen = true
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    
                    Button("Forgot Password?") {
                        showingForgotPassword = true
                    }
                    .foregroundColor(.white)
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
                .padding()
                
                if showPopUp {
                    GeometryReader { geometry in
                        CustomPopUp(showPopUp: $showPopUp)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .background(Color.black.opacity(0.6))
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
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("Create Account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                TextField("Email", text: $username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                Button("Register") {
                    registerUser(username: username, password: password)
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.green)
                .cornerRadius(10)
                .padding(.bottom, 10)
                
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
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("Reset Password")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                TextField("Enter your email", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                Button("Send Reset Link") {
                    resetPassword(email: email)
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .padding(.bottom, 10)
                
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
        if isValidEmail(email) {
            showConfirmation = true
            errorMessage = nil
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showConfirmation = false
                }
            }
        } else {
            errorMessage = "Please enter a valid email address."
            showConfirmation = false
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
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
                    .background(Color.black)
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
