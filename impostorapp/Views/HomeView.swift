import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var viewModel = GameViewModel()
    var authViewModel: AuthViewModel
    
    // Estado para controlar la navegación a SetupView desde la Grid
    @State private var navigateToSetup = false

    var body: some View {
        TabView {
            // PESTAÑA 1: JUGAR
            NavigationStack {
                ZStack {
                    Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Grid de Categorías
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 20)], spacing: 20) {
                                ForEach(viewModel.categories) { category in
                                    CategoryCard(category: category)
                                        .onTapGesture {
                                            handleCategorySelection(category)
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                    .navigationTitle("Impostor")
                    .navigationDestination(isPresented: $navigateToSetup) {
                        SetupView(viewModel: viewModel)
                    }
                }
            }
            .tabItem {
                Label("Jugar", systemImage: "gamecontroller.fill")
            }
            
            // PESTAÑA 2: PERFIL
            NavigationStack {
                List {
                    Section {
                        HStack(spacing: 15) {
                            ZStack {
                                Circle().fill(Color.blue.gradient)
                                Text(authViewModel.userSession?.displayName?.prefix(1).uppercased() ?? "J")
                                    .font(.title.bold())
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 60, height: 60)
                            
                            VStack(alignment: .leading) {
                                Text(authViewModel.userSession?.displayName ?? "Jugador")
                                    .font(.headline)
                                Text(authViewModel.userSession?.email ?? "")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    } header: {
                        Text("Mi Cuenta")
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            authViewModel.signOut()
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Cerrar Sesión")
                            }
                        }
                    }
                }
                .navigationTitle("Perfil")
            }
            .tabItem {
                Label("Perfil", systemImage: "person.crop.circle.fill")
            }
        }
        .tint(.indigo) // Color de acento estilo Apple
    }
    
    func handleCategorySelection(_ category: GameCategory) {
        if category.isCustom {
            // Aquí iría tu lógica futura para crear categorías
            print("Crear categoría")
        } else {
            viewModel.selectedCategory = category
            navigateToSetup = true
        }
    }
}

// Tarjeta rediseñada para ser más limpia
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
