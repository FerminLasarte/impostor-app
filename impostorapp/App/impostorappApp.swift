import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct impostorappApp: App {
    
    // 1. Declaramos la variable SIN inicializarla aquí
    @State private var authViewModel: AuthViewModel
    
    init() {
        // 2. Configuramos Firebase (Ahora sí es lo primero que ocurre)
        FirebaseApp.configure()
        
        // 3. Inicializamos el ViewModel manualmente DESPUÉS de configurar Firebase
        // Usamos "_authViewModel" para acceder al contenedor del State
        _authViewModel = State(initialValue: AuthViewModel())
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.userSession != nil {
                HomeView(authViewModel: authViewModel)
            } else {
                // 4. Pasamos el MISMO viewModel para que la app se entere del login
                AuthView(viewModel: authViewModel)
            }
        }
    }
}
