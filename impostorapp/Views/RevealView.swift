import SwiftUI

struct RevealView: View {
    @Bindable var viewModel: GameViewModel
    @State private var isRevealed = false
    
    // Calcula si es el último jugador para cambiar el texto del botón
    private var isLastPlayer: Bool {
        viewModel.currentRevealIndex >= viewModel.players.count - 1
    }

    var body: some View {
        ZStack {
            // 1. Fondo Degradado (Coherente con el resto de la app)
            LinearGradient(
                colors: [Color.indigo.opacity(0.4), Color.purple.opacity(0.4), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Header (Progreso)
                Text("Jugador \(viewModel.currentRevealIndex + 1) de \(viewModel.players.count)")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
                    .padding(.top, 20)
                
                Spacer()
                
                // 2. Tarjeta Central (Estilo Cristal)
                VStack(spacing: 25) {
                    if isRevealed {
                        revealedContent
                            .transition(.push(from: .bottom).combined(with: .opacity))
                    } else {
                        hiddenContent
                            .transition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 50)
                .padding(.horizontal, 20)
                .background(.ultraThinMaterial) // Efecto Apple Glass
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(radius: 10)
                .padding(.horizontal)
                // Animación fluida al cambiar el contenido
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isRevealed)
                
                Spacer()
                
                // 3. Botón de Acción
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
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Tu Identidad")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Subvistas de Contenido

    // Contenido cuando el rol es visible
    private var revealedContent: some View {
        VStack(spacing: 20) {
            Image(systemName: currentPlayer.role == .impostor ? "eye.slash.fill" : "person.fill.checkmark")
                .font(.system(size: 80))
                .foregroundStyle(currentPlayer.role == .impostor ? .red : .green)
                .symbolEffect(.bounce, value: isRevealed)
            
            VStack(spacing: 8) {
                Text(currentPlayer.name)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                Text(currentPlayer.role == .impostor ? "IMPOSTOR" : "CIVIL")
                    .font(.largeTitle.weight(.heavy))
                    .fontDesign(.rounded)
                    .foregroundStyle(currentPlayer.role == .impostor ? .red : .primary)
            }
            
            Divider()
                .padding(.horizontal, 40)
            
            if case let .civilian(word) = currentPlayer.role {
                VStack(spacing: 5) {
                    Text("Palabra Secreta:")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)
                    
                    Text(word)
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundStyle(.primary)
                }
            } else {
                Text("Engaña a los demás y descubre la palabra.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
        }
    }

    // Contenido cuando está oculto (Pasa el teléfono)
    private var hiddenContent: some View {
        VStack(spacing: 25) {
            Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                .font(.system(size: 70))
                .foregroundStyle(.blue)
                .symbolEffect(.variableColor.iterative.dimInactiveLayers) // Animación nativa iOS 17
            
            VStack(spacing: 10) {
                Text("Dale el teléfono a:")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                Text(currentPlayer.name)
                    .font(.largeTitle.bold())
                    .fontDesign(.rounded)
                    .foregroundStyle(.primary)
            }
            
            Text("Nadie más debe ver la pantalla.")
                .font(.caption)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
        }
    }

    // MARK: - Lógica y Helpers

    private var currentPlayer: Player {
        viewModel.players[viewModel.currentRevealIndex]
    }
    
    private var buttonTitle: String {
        if !isRevealed {
            return "Ver mi Rol"
        } else {
            return isLastPlayer ? "Comenzar Juego" : "Ocultar y Siguiente"
        }
    }

    private func handleTap() {
        if isRevealed {
            // Ocultar y avanzar
            isRevealed = false
            if !isLastPlayer {
                viewModel.currentRevealIndex += 1
            } else {
                print("Todos listos, iniciar timer o juego principal")
                // Aquí podrías navegar a una 'GameSessionView'
            }
        } else {
            // Mostrar
            withAnimation {
                isRevealed = true
            }
        }
    }
}
