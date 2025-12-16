import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct impostorappApp: App {
    
    // 1. Inicializamos Firebase aquí, ANTES de que se cree cualquier variable
    init() {
        FirebaseApp.configure()
    }
    
    // 2. Ahora es seguro crear el ViewModel, porque Firebase ya está configurado
    @State private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            // Verificamos el estado de la sesión
            if authViewModel.userSession != nil {
                HomeView(authViewModel: authViewModel)
            } else {
                AuthView()
            }
        }
    }
}
