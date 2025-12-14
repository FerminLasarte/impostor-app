import SwiftUI

struct HomeView: View {
    @State private var viewModel = GameViewModel()
    @State private var navigateToSetup = false

    // Definimos el diseño de la grilla (2 columnas flexibles)
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
                        Text("¡Hola, Fermin!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Vamos a jugar")
                            .font(.largeTitle.weight(.bold))
                    }
                    .padding(.horizontal)

                    Text("Selecciona una categoría")
                        .font(.headline)
                        .padding(.horizontal)

                    // Grilla de Categorías
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
            .background(Color(uiColor: .systemGroupedBackground)) // Color de fondo típico de iOS
            .navigationTitle("Impostor")
            .navigationBarHidden(true) // Ocultamos el título nativo para usar el nuestro custom
            .navigationDestination(isPresented: $navigateToSetup) {
                // Pasamos el mismo ViewModel
                SetupView(viewModel: viewModel)
            }
        }
    }

    func handleCategorySelection(_ category: GameCategory) {
        if category.isCustom {
            // Aquí podrías abrir una alerta o sheet para crear categoría
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
