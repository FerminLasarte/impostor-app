import SwiftUI
import FirebaseAuth
import Observation

@Observable
class AuthViewModel {
    var userSession: User?
    var errorMessage: String?
    
    init() {
        // Escuchar cambios en el estado de autenticación al iniciar
        self.userSession = Auth.auth().currentUser
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.userSession = user
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            self.errorMessage = nil
        } catch {
            self.errorMessage = "Error al iniciar sesión: \(error.localizedDescription)"
        }
    }
    
    func signUp(email: String, password: String, name: String) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // Aquí podrías guardar el nombre en Firestore o actualizar el perfil del usuario
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            self.errorMessage = nil
        } catch {
            self.errorMessage = "Error al registrarse: \(error.localizedDescription)"
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
