import SwiftUI
import FirebaseAuth
import FirebaseFirestore // 1. Importar Firestore
import Observation

@Observable
class AuthViewModel {
    var userSession: User?
    var errorMessage: String?
    
    init() {
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
    
    func signUp(email: String, password: String, displayName: String) async {
        do {
            // 1. Crear usuario en Auth
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // 2. Actualizar el nombre visible (Auth)
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
            
            // 3. GUARDAR EN FIRESTORE (Base de datos)
            let db = Firestore.firestore()
            let userId = result.user.uid
            
            // Creamos un Diccionario con los datos
            let userData: [String: Any] = [
                "uid": userId,
                "displayName": displayName,
                "email": email,
                "createdAt": Timestamp(date: Date()),
                "isOnline": true
            ]
            
            // Esto crea la colección "users" si no existe, y el documento con el ID del usuario
            try await db.collection("users").document(userId).setData(userData)
            
            // Ejemplo de SUBCOLECCIÓN: Crear un historial vacío
            try await db.collection("users").document(userId).collection("gameHistory").addDocument(data: [
                "message": "Usuario creado",
                "date": Timestamp(date: Date())
            ])
            
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
