import SwiftUI

struct RevealView: View {
    @Bindable var viewModel: GameViewModel
    @Binding var path: NavigationPath // Recibimos el path para controlar la salida
    @State private var isRevealed = false
    
    private var isLastPlayer: Bool {
        viewModel.currentRevealIndex >= viewModel.players.count - 1
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo
                LinearGradient(
                    colors: [Color.indigo.opacity(0.4), Color.purple.opacity(0.4), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // Header
                        Text("Jugador \(viewModel.currentRevealIndex + 1) / \(viewModel.players.count)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.top, geometry.size.height * 0.05)
                        
                        Spacer()
                        
                        // Tarjeta Responsive (altura relativa)
                        VStack(spacing: 20) {
                            if isRevealed {
                                revealedContent
                                    .transition(.scale.combined(with: .opacity))
                            } else {
                                hiddenContent
                                    .transition(.opacity)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.55) // 55% de pantalla
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(radius: 10)
                        .padding(.horizontal)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isRevealed)
                        
                        Spacer()
                        
                        // Botón Acción
                        Button {
                            handleTap()
                        } label: {
                            Text(buttonTitle)
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isRevealed ? Color.primary : Color.blue)
                                .foregroundColor(isRevealed ? Color(uiColor: .systemBackground) : .white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, geometry.size.height * 0.05)
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .navigationTitle("Identidad")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Botón para cancelar partida y volver al menú
            ToolbarItem(placement: .topBarLeading) {
                Button("Salir") {
                    viewModel.resetGame()
                    path.removeLast(path.count) // Vuelve a la raíz (HomeView)
                }
                .tint(.red)
            }
        }
    }

    // --- Subvistas (Igual que la versión responsive anterior) ---
    private var revealedContent: some View {
        VStack(spacing: 15) {
            Image(systemName: currentPlayer.role == .impostor ? "eye.slash.fill" : "person.fill.checkmark")
                .font(.system(size: 80))
                .foregroundStyle(currentPlayer.role == .impostor ? .red : .green)
                .minimumScaleFactor(0.5)
            
            VStack(spacing: 5) {
                Text(currentPlayer.name)
                    .font(.title2)
                    .foregroundStyle(.secondary)
                
                Text(currentPlayer.role == .impostor ? "IMPOSTOR" : "CIVIL")
                    .font(.largeTitle.weight(.heavy))
                    .fontDesign(.rounded)
                    .foregroundStyle(currentPlayer.role == .impostor ? .red : .primary)
                    .minimumScaleFactor(0.5)
            }
            
            Divider().padding(.horizontal)
            
            if case let .civilian(word) = currentPlayer.role {
                VStack {
                    Text("PALABRA:").font(.caption).bold().foregroundStyle(.secondary)
                    Text(word).font(.largeTitle.bold()).minimumScaleFactor(0.5)
                }
            } else {
                Text("🤫 Engaña a todos").font(.body)
            }
        }
    }

    private var hiddenContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                .font(.system(size: 70))
                .foregroundStyle(.blue)
            
            Text(currentPlayer.name)
                .font(.largeTitle.bold())
                .fontDesign(.rounded)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Text("Toca para ver tu rol")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    // Helpers
    private var currentPlayer: Player { viewModel.players[viewModel.currentRevealIndex] }
    
    private var buttonTitle: String {
        !isRevealed ? "Ver Rol" : (isLastPlayer ? "Comenzar Juego" : "Siguiente Jugador")
    }

    private func handleTap() {
        if isRevealed {
            isRevealed = false
            if !isLastPlayer {
                viewModel.currentRevealIndex += 1
            } else {
                // Lógica de fin de revelación -> Iniciar Timer o Juego
                print("Juego Iniciado")
            }
        } else {
            isRevealed = true
        }
    }
}
