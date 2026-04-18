import SwiftUI

struct RevealView: View {
    @Bindable var viewModel: GameViewModel
    @Binding var path: NavigationPath
    @State private var isRevealed = false

    private var isLastPlayer: Bool {
        viewModel.currentRevealIndex >= viewModel.players.count - 1
    }

    private var currentPlayer: Player {
        guard viewModel.players.indices.contains(viewModel.currentRevealIndex) else {
            return Player(name: "Cargando...", role: .impostor)
        }
        return viewModel.players[viewModel.currentRevealIndex]
    }

    private var isImpostor: Bool {
        currentPlayer.role == .impostor
    }

    private var ambientColor: Color {
        isRevealed ? (isImpostor ? .red : .blue) : .indigo
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                // Orbe ambiental dinámico según rol
                Circle()
                    .fill(ambientColor.opacity(0.28))
                    .frame(width: geo.size.width * 1.3)
                    .blur(radius: geo.size.width * 0.38)
                    .offset(y: -geo.size.height * 0.08)
                    .animation(.easeInOut(duration: 0.55), value: isRevealed)

                VStack(spacing: 0) {
                    // Progreso
                    Text("\(viewModel.currentRevealIndex + 1) / \(viewModel.players.count)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.38))
                        .padding(.top, 14)

                    Spacer()

                    // Tarjeta principal
                    ZStack {
                        if isRevealed {
                            RevealedContent(player: currentPlayer)
                                .transition(.scale(scale: 0.93).combined(with: .opacity))
                        } else {
                            HiddenContent(playerName: currentPlayer.name)
                                .transition(.opacity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * 0.52)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .padding(.horizontal, 20)
                    .shadow(
                        color: isRevealed ? ambientColor.opacity(0.18) : .clear,
                        radius: 28
                    )
                    .animation(.spring(response: 0.45, dampingFraction: 0.74), value: isRevealed)

                    Spacer()

                    // Botón de acción
                    Button { handleTap() } label: {
                        Text(buttonTitle)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                isRevealed && isLastPlayer
                                    ? Color.indigo
                                    : Color.white.opacity(0.12)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .animation(.easeInOut(duration: 0.2), value: isRevealed)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 44)
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
        .navigationTitle("Identidad")
        .navigationBarBackButtonHidden(true)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Salir") {
                    viewModel.resetGame()
                    path.removeLast(path.count)
                }
                .tint(.red.opacity(0.88))
            }
        }
    }

    private var buttonTitle: String {
        !isRevealed ? "Ver Rol" : (isLastPlayer ? "Comenzar Juego" : "Siguiente")
    }

    private func handleTap() {
        if isRevealed {
            isRevealed = false
            if !isLastPlayer {
                viewModel.currentRevealIndex += 1
            } else {
                path.append("inGameStatus")
            }
        } else {
            isRevealed = true
        }
    }
}

// MARK: - Subvistas

struct HiddenContent: View {
    let playerName: String

    var body: some View {
        VStack(spacing: 22) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60, weight: .light))
                .foregroundStyle(.white.opacity(0.45))

            VStack(spacing: 7) {
                Text(playerName)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text("Toca para ver tu rol")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.42))
            }
        }
    }
}

struct RevealedContent: View {
    let player: Player

    private var isImpostor: Bool { player.role == .impostor }
    private var roleColor: Color { isImpostor ? .red : .blue }

    var body: some View {
        VStack(spacing: 22) {
            ZStack {
                Circle()
                    .fill(roleColor.opacity(0.16))
                    .frame(width: 88, height: 88)
                Image(systemName: isImpostor ? "eye.slash.fill" : "checkmark.seal.fill")
                    .font(.system(size: 38, weight: .medium))
                    .foregroundStyle(roleColor)
            }
            .shadow(color: roleColor.opacity(0.3), radius: 14)

            VStack(spacing: 5) {
                Text(player.name)
                    .font(.system(size: 17))
                    .foregroundStyle(.white.opacity(0.55))

                Text(isImpostor ? "IMPOSTOR" : "CIVIL")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundStyle(isImpostor ? .red : .white)
                    .minimumScaleFactor(0.6)
            }

            Rectangle()
                .fill(.white.opacity(0.1))
                .frame(height: 1)
                .padding(.horizontal, 28)

            if case let .civilian(word) = player.role {
                VStack(spacing: 5) {
                    Text("PALABRA")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white.opacity(0.38))
                        .tracking(2.5)
                    Text(word)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
            } else {
                VStack(spacing: 5) {
                    Text("🤫")
                        .font(.system(size: 30))
                    Text("Engaña a todos")
                        .font(.system(size: 15))
                        .foregroundStyle(.red.opacity(0.72))
                }
            }
        }
        .padding(28)
    }
}

#Preview {
    let vm = GameViewModel()
    vm.players = [
        Player(name: "Jugador 1", role: .impostor),
        Player(name: "Jugador 2", role: .civilian(word: "Fútbol"))
    ]
    vm.currentRevealIndex = 0
    return RevealView(viewModel: vm, path: .constant(NavigationPath()))
}
