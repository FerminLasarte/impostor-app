import SwiftUI
import FirebaseCore // 1. Importar el módulo base

// 2. Crear el adaptador para el AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure() // 3. ¡La línea mágica!
    return true
  }
}

@main
struct impostorappApp: App {
    // 4. Inyectar el delegado
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeView() // Asumiendo que ya creaste la HomeView del paso anterior
        }
    }
}
