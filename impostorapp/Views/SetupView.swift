import SwiftUI

struct SetupView: View {
    @Bindable var viewModel: GameViewModel
    @Binding var path: NavigationPath // Para volver al inicio si hace falta

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo temático
                LinearGradient(
                    colors: [viewModel.selectedCategory?.color.opacity(0.3) ?? .blue, .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    
                    // 1. Icono Grande Responsive
                    Image(systemName: viewModel.selectedCategory?.iconName ?? "questionmark")
                        .font(.system(size: geometry.size.height * 0.15)) // 15% de la altura
                        .foregroundStyle(viewModel.selectedCategory?.color ?? .primary)
                        .padding(.vertical, geometry.size.height * 0.05)
                        .shadow(radius: 10)
                    
                    Text(viewModel.selectedCategory?.name ?? "Configuración")
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                        .padding(.bottom, 20)

                    // 2. Panel de Configuración
                    VStack(spacing: 30) {
                        // JUGADORES (Sin límite máximo fijo, pongamos 50 por usabilidad)
                        SettingRow(
                            icon: "person.2.fill",
                            color: .blue,
                            title: "Jugadores",
                            value: $viewModel.playerCount,
                            range: 2...50
                        )
                        // IMPORTANTE: Al cambiar jugadores, ajustamos impostores si exceden
                        .onChange(of: viewModel.playerCount) { _, newValue in
                            if viewModel.impostorCount > newValue {
                                viewModel.impostorCount = newValue
                            }
                        }

                        Divider()

                        // IMPOSTORES (Límite dinámico: 1...playerCount)
                        SettingRow(
                            icon: "theatermasks.fill",
                            color: .red,
                            title: "Impostores",
                            value: $viewModel.impostorCount,
                            range: 1...viewModel.playerCount // AQUÍ ESTÁ LA LÓGICA SOLICITADA
                        )
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .padding(.horizontal)

                    Spacer()

                    // 3. Botón Jugar
                    Button {
                        viewModel.startGame()
                        path.append("revealGame") // Navegamos al juego
                    } label: {
                        Text("Jugar Ahora")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .foregroundColor(Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, geometry.size.height * 0.05)
                }
            }
        }
        .navigationTitle("Configurar Partida")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: String.self) { value in
            if value == "revealGame" {
                RevealView(viewModel: viewModel, path: $path)
            }
        }
    }
}

struct SettingRow: View {
    let icon: String
    let color: Color
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        HStack {
            Label {
                Text(title)
                    .fontWeight(.medium)
                    .minimumScaleFactor(0.8)
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(color)
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                // Botón Menos
                Button {
                    if value > range.lowerBound { value -= 1 }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        // CORRECCIÓN: Usamos Color.secondary explícitamente
                        .foregroundStyle(value > range.lowerBound ? Color.secondary : Color.secondary.opacity(0.3))
                }
                .disabled(value <= range.lowerBound)
                
                // Número
                Text("\(value)")
                    .font(.title.bold())
                    .fontDesign(.monospaced)
                    .frame(minWidth: 40)
                    .contentTransition(.numericText())
                
                // Botón Más
                Button {
                    if value < range.upperBound { value += 1 }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        // CORRECCIÓN: Aseguramos que 'color' sea tratado consistentemente
                        .foregroundStyle(value < range.upperBound ? color : color.opacity(0.3))
                }
                .disabled(value >= range.upperBound)
            }
        }
        .animation(.snappy, value: value)
    }
}

#Preview {
    let vm = GameViewModel()
    // Simulamos que el usuario eligió la primera categoría
    vm.selectedCategory = vm.categories.first
    
    return SetupView(viewModel: vm, path: .constant(NavigationPath()))
}
