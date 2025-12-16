import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var viewModel = GameViewModel() // Tu ViewModel del juego
    var authViewModel: AuthViewModel // <--- NUEVO: Inyectamos el Auth
    
    @State private var navigateToSetup = false

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Header de Bienvenida
                    VStack(alignment: .leading) {
                        // Usamos el nombre del usuario de Firebase si existe
                        Text("¡Hola, \(authViewModel.userSession?.displayName ?? "Jugador")!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Vamos a jugar")
                            .font(.largeTitle.weight(.bold))
                    }
                    .padding(.horizontal)

                    // ... (El resto de tu código sigue igual: Grid de categorías, etc.) ...
                     Text("Selecciona una categoría")
                        .font(.headline)
                        .padding(.horizontal)

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.categories) { category in
                            CategoryCard(category: category)
                                .onTapGesture {
                                    handleCategorySelection(category)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Impostor")
            .navigationBarHidden(false) // <--- CAMBIO: Mostrar barra para el botón de logout
            .toolbar { // <--- NUEVO: Botón de logout
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToSetup) {
                SetupView(viewModel: viewModel)
            }
        }
    }
    
    // ... (El resto de tus funciones y CategoryCard siguen igual) ...
    func handleCategorySelection(_ category: GameCategory) {
        if category.isCustom {
            print("Lógica para crear categoría")
        } else {
            viewModel.selectedCategory = category
            navigateToSetup = true
        }
    }
}

// Subvista para la tarjeta (Componente visual)
struct CategoryCard: View {
    let category: GameCategory

    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: category.iconName)
                    .font(.title)
                    .foregroundStyle(category.color)
            }

            Text(category.name)
                .font(.system(.body, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
