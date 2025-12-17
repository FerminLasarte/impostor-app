import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var viewModel = GameViewModel()
    var authViewModel: AuthViewModel
    @State private var path = NavigationPath() // Control de navegación moderno

    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                ZStack {
                    // Fondo general
                    Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                    
                    VStack(spacing: geometry.size.height * 0.05) {
                        
                        // 1. Header de Usuario (Responsive)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Hola,")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(authViewModel.userSession?.displayName ?? "Jugador")
                                    .font(.system(size: geometry.size.width * 0.08)) // Texto dinámico
                                    .bold()
                            }
                            Spacer()
                            
                            // Botón Salir
                            Button {
                                authViewModel.signOut()
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundStyle(.red)
                                    .padding(10)
                                    .background(Color.red.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        // 2. Logo o Título Grande
                        Image(systemName: "theatermasks.fill")
                            .font(.system(size: geometry.size.width * 0.3)) // Icono gigante responsive
                            .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(radius: 10)
                        
                        Text("IMPOSTOR")
                            .font(.system(size: geometry.size.width * 0.1, weight: .heavy, design: .rounded))
                            .tracking(2)
                        
                        Spacer()
                        
                        // 3. Menú de Opciones
                        VStack(spacing: 20) {
                            MenuButton(
                                title: "Jugar Local",
                                icon: "iphone.gen3",
                                color: .blue,
                                width: geometry.size.width * 0.85
                            ) {
                                path.append("localGame")
                            }
                            
                            MenuButton(
                                title: "Crear Sala",
                                icon: "cloud.fill",
                                color: .purple,
                                width: geometry.size.width * 0.85
                            ) {
                                // Lógica futura para online
                                print("Ir a crear sala")
                            }
                        }
                        .padding(.bottom, geometry.size.height * 0.1)
                    }
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "localGame" {
                    LocalCategorySelectionView(viewModel: viewModel, path: $path)
                }
            }
        }
    }
}

// Botón de Menú Reutilizable y Responsive
struct MenuButton: View {
    let title: String
    let icon: String
    let color: Color
    let width: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.title3.bold())
            }
            .frame(width: width)
            .padding(.vertical, 18)
            .background(color.gradient)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
}

// --- SUBVISTA: Selección de Categorías (Lo que antes era HomeView) ---
struct LocalCategorySelectionView: View {
    @Bindable var viewModel: GameViewModel
    @Binding var path: NavigationPath
    
    // Grid adaptable
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 20)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.categories) { category in
                    CategoryCard(category: category)
                        .onTapGesture {
                            if category.isCustom {
                                print("Crear")
                            } else {
                                viewModel.selectedCategory = category
                                path.append(category) // Navegar a Setup
                            }
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Categorías")
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationDestination(for: GameCategory.self) { category in
            SetupView(viewModel: viewModel, path: $path)
        }
    }
}

// --- Componente: Tarjeta de Categoría ---
struct CategoryCard: View {
    let category: GameCategory

    var body: some View {
        VStack {
            Image(systemName: category.iconName)
                .font(.system(size: 40))
                .foregroundStyle(category.color.gradient)
                .frame(height: 50)
                .shadow(color: category.color.opacity(0.3), radius: 5)
            
            Text(category.name)
                .font(.headline)
                .fontDesign(.rounded)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
