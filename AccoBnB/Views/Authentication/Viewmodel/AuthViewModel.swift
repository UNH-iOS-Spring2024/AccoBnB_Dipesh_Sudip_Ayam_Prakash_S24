//
//  AuthViewModel.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/21/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private let userCollection = "users" // TODO: Store all collection names in a single file.
    
    init() {
        // Auth.auth().currentUser is the functionality from firebase to check for a logged in user
        // Initializing userSession with currently logged in user.
            self.userSession = Auth.auth().currentUser
    }
    
    func signIn(withEmail email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            // Using "DispatchQueue.main.async" to publish all the UI changes to the Main Thread.
            // Basically all the asynchronous task run on the background thread and the changes occured through these tasks should be published on the main thread so "DispatchQueue.main.async" helps us achieve this
            DispatchQueue.main.async {
                self.userSession = result.user
            }
        } catch {
            print("DEBUG: Failed to signin user with error \(error.localizedDescription)")
        }
    }
    
    func signUp(withEmail email: String, password: String, firstName: String, lastName: String) async throws{
        do {
            // Creating a user using firebase auth functionality
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // creating a user session
            DispatchQueue.main.async {
                self.userSession = result.user
            }
            // Creating our User model with the result from firebase auth
            let user = User(id: result.user.uid, firstName: firstName, lastName: lastName, email: email)
            // Encoding the user to store user information in "users" collection
            let encodedUser = try Firestore.Encoder().encode(user)
            //storing the user additional information in Firestore cloud under "users" collection.
            try await Firestore.firestore().collection(userCollection).document(user.id).setData(encodedUser)
            
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // signs out user from Firebase server.
            self.userSession = nil // wipes out userSession and takes us back to login screen.
            self.currentUser = nil // wipes out current user data model.

        } catch {
            print("DEBUG: Failed to logout user with error: \(error.localizedDescription)")
        }
    }
}
