import SwiftUI

struct RevealView: View {
    @Bindable var viewModel: GameViewModel
    @State private var isRevealed = false

    var body: some View {
        VStack {
            Spacer()

            if isRevealed {
                revealedView
            } else {
                hiddenView
            }

            Spacer()

            Button(isRevealed ? "Ocultar y Siguiente" : "Mostrar Rol") {
                handleTap()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Ronda de Roles")
        .navigationBarBackButtonHidden()
    }

    // MARK: - Subviews

    private var revealedView: some View {
        VStack(spacing: 20) {
            Text(currentPlayer.role == .impostor ? "🤫" : "👀")
                .font(.system(size: 80))

            Text(currentPlayer.name)
                .font(.title2)
                .foregroundStyle(.gray)

            if case let .civilian(word) = currentPlayer.role {
                Text("TU PALABRA ES:")
                    .font(.caption)
                    .fontWeight(.bold)

                Text(word)
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundStyle(.blue)
            } else {
                Text("ERES EL")
                    .font(.caption)
                    .fontWeight(.bold)

                Text("IMPOSTOR")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundStyle(.red)

                Text("Intenta pasar desapercibido...")
                    .italic()
            }
        }
        .transition(.scale)
    }

    private var hiddenView: some View {
        VStack(spacing: 20) {
            Image(systemName: "iphone.gen3")
                .font(.system(size: 60))
                .foregroundStyle(.purple)

            Text("Pásale el teléfono a:")
                .font(.title3)

            Text(currentPlayer.name)
                .font(.largeTitle.bold())
                .foregroundStyle(.purple)

            Text("Toca la pantalla para ver tu rol")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Helpers

    private var currentPlayer: Player {
        viewModel.players[viewModel.currentRevealIndex]
    }

    private func handleTap() {
        if isRevealed {
            isRevealed = false

            if viewModel.currentRevealIndex < viewModel.players.count - 1 {
                viewModel.currentRevealIndex += 1
            } else {
                print("Todos los jugadores han visto sus roles")
            }
        } else {
            isRevealed = true
        }
    }
}
