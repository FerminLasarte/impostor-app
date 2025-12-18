import SwiftUI


struct HomeView: View {
    @State private var viewModel = GameViewModel()
    var authViewModel: AuthViewModel
    @State private var path = NavigationPath() // Gestión centralizada de rutas

    var body: some View {
        NavigationStack(path: $path) {
            // Vista Principal (Menú) separada
            MenuSelectionView(authViewModel: authViewModel, path: $path, viewModel: viewModel)
                .navigationDestination(for: String.self) { value in
                    switch value {
                    case "localGame":
                        // Usamos tu vista de selección de categorías existente
                        LocalCategorySelectionView(viewModel: viewModel, path: $path)
                    case "revealGame":
                        // Vista de revelación de cartas
                        RevealView(viewModel: viewModel, path: $path)
                    case "inGameStatus":
                        // LA NUEVA VISTA: Estado del juego en curso
                        InGameStatusView(viewModel: viewModel, path: $path)
                    default:
                        EmptyView()
                    }
                }
                .navigationDestination(for: GameCategory.self) { category in
                    // Navegación a la configuración (SetupView)
                    SetupView(viewModel: viewModel, path: $path)
                }
        }
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel())
}
