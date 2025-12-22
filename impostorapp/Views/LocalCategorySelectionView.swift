//
//  LocalCategorySelectionView.swift
//  impostorapp
//
//  Created by Fermin Lasarte on 18/12/2025.
//


import SwiftUI

struct LocalCategorySelectionView: View {
    @Bindable var viewModel: GameViewModel
    @Binding var path: NavigationPath
    
    // Grid adaptativo para las tarjetas
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 20)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Elige un Tema")
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                    .padding(.top)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.categories) { category in
                        CategoryCard(category: category)
                            .onTapGesture {
                                if category.isCustom {
                                    // Aquí iría la lógica para crear categoría (futuro)
                                    print("Crear nueva categoría")
                                } else {
                                    viewModel.selectedCategory = category
                                    // Al añadir la categoría al path, el NavigationStack de HomeView
                                    // detectará el tipo GameCategory y navegará a SetupView
                                    path.append(category)
                                }
                            }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Categorías")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

// Subcomponente visual para la tarjeta
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

#Preview {
    LocalCategorySelectionView(
        viewModel: GameViewModel(),
        path: .constant(NavigationPath())
    )
}
