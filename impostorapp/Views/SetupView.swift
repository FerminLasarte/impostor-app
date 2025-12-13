import SwiftUI

struct SetupView: View {
    // Inyectamos el ViewModel como un StateObject (dueño del ciclo de vida)
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // Título y Header
                Text("🕵️ Impostor")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(.purple)
                    .padding(.top, 50)
                
                VStack(spacing: 20) {
                    // Selector de Jugadores
                    VStack(alignment: .leading) {
                        Text("Cantidad de Jugadores: \(viewModel.playerCount)")
                            .font(.headline)
                        Slider(value: Binding(
                            get: { Double(viewModel.playerCount) },
                            set: { viewModel.playerCount = Int($0) }
                        ), in: 3...12, step: 1)
                        .tint(.purple)
                    }
                    
                    // Selector de Impostores
                    VStack(alignment: .leading) {
                        Text("Cantidad de Impostores: \(viewModel.impostorCount)")
                            .font(.headline)
                        Stepper("", value: $viewModel.impostorCount, in: 1...3)
                            .labelsHidden()
                    }
                    
                    // Selector de Categoría
                    Picker("Categoría", selection: $viewModel.selectedCategory) {
                        Text("Lugares").tag("Lugares")
                        Text("Comidas").tag("Comidas")
                        Text("Animales").tag("Animales")
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                
                Spacer()
                
                // Botón de Inicio
                Button(action: {
                    viewModel.startGame()
                }) {
                    Text("Comenzar Juego")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .navigationDestination(isPresented: $viewModel.gameStarted) {
                    // Aquí iríamos a la vista de revelar cartas
                    Text("Juego Iniciado (Próximamente RevealView)")
                }
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground)) // Color de fondo grisaceo standard de iOS
        }
    }
}

#Preview {
    SetupView()
}
