import SwiftUI

struct SetupView: View {
    @Bindable var viewModel: GameViewModel // Usamos @Bindable porque viene de HomeView

    var body: some View {
        ZStack {
            // Fondo degradado sutil basado en la categoría
            LinearGradient(
                colors: [viewModel.selectedCategory?.color.opacity(0.3) ?? .blue, .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                
                // Título de la categoría seleccionada
                VStack {
                    Image(systemName: viewModel.selectedCategory?.iconName ?? "questionmark")
                        .font(.system(size: 60))
                        .foregroundStyle(viewModel.selectedCategory?.color ?? .primary)
                        .padding(.bottom, 10)
                    
                    Text(viewModel.selectedCategory?.name ?? "Juego")
                        .font(.largeTitle.bold())
                }
                .padding(.top, 40)

                // Tarjeta de Configuración
                VStack(spacing: 25) {
                    SettingRow(
                        icon: "person.2.fill",
                        color: .blue,
                        title: "Jugadores",
                        value: $viewModel.playerCount,
                        range: 3...12
                    )

                    Divider()

                    SettingRow(
                        icon: "theatermasks.fill",
                        color: .red,
                        title: "Impostores",
                        value: $viewModel.impostorCount,
                        range: 1...3
                    )
                }
                .padding(25)
                .background(.ultraThinMaterial) // Efecto cristal de Apple
                .cornerRadius(25)
                .padding(.horizontal)

                Spacer()

                Button {
                    viewModel.startGame()
                } label: {
                    Text("Jugar")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(Color(uiColor: .systemBackground)) // Color inverso al modo oscuro/claro
                        .cornerRadius(16)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationDestination(isPresented: $viewModel.gameStarted) {
            RevealView(viewModel: viewModel)
        }
    }
}

// Componente reutilizable para las filas de configuración
struct SettingRow: View {
    let icon: String
    let color: Color
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 30)
            
            Text(title)
                .fontWeight(.medium)
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: { if value > range.lowerBound { value -= 1 } }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.gray.opacity(0.5))
                }
                
                Text("\(value)")
                    .font(.title2.bold())
                    .frame(minWidth: 30)
                
                Button(action: { if value < range.upperBound { value += 1 } }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(color)
                }
            }
        }
    }
}
