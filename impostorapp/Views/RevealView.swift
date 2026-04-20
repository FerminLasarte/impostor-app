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

    private var isImpostor: Bool { currentPlayer.role == .impostor }
    private var roleColor: Color { isImpostor ? .red : .cyan }
    private var ambientColor: Color { isRevealed ? roleColor : .indigo }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                // Orbe ambiental vívido
                Circle()
                    .fill(ambientColor.opacity(0.5))
                    .frame(width: geo.size.width * 1.5)
                    .blur(radius: geo.size.width * 0.3)
                    .offset(y: -geo.size.height * 0.1)
                    .animation(.easeInOut(duration: 0.5), value: isRevealed)

                VStack(spacing: 0) {
                    // Progreso
                    Text("\(viewModel.currentRevealIndex + 1) / \(viewModel.players.count)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.55))
                        .padding(.top, 14)

                    Spacer()

                    // Tarjeta sólida con borde de color
                    ZStack {
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .fill(Color(white: 0.08))

                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .stroke(
                                isRevealed ? roleColor.opacity(0.65) : Color.white.opacity(0.1),
                                lineWidth: isRevealed ? 2 : 1
                            )
                            .animation(.easeInOut(duration: 0.3), value: isRevealed)

                        if isRevealed {
                            RevealedContent(player: currentPlayer)
                                .transition(.scale(scale: 0.88).combined(with: .opacity))
                        } else {
                            HiddenContent(playerName: currentPlayer.name)
                                .transition(.opacity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * 0.54)
                    .padding(.horizontal, 20)
                    .shadow(color: isRevealed ? roleColor.opacity(0.35) : .black.opacity(0.5), radius: 32, y: 8)
                    .animation(.spring(response: 0.42, dampingFraction: 0.72), value: isRevealed)

                    Spacer()

                    // Botón acción
                    Button { handleTap() } label: {
                        Text(buttonTitle)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(buttonColor)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: buttonColor.opacity(0.5), radius: 14, y: 5)
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
                .tint(.red)
            }
        }
    }

    private var buttonTitle: String {
        !isRevealed ? "Ver Rol" : (isLastPlayer ? "Comenzar Juego" : "Siguiente")
    }

    private var buttonColor: Color {
        guard isRevealed else { return Color(white: 0.2) }
        return isLastPlayer ? .indigo : Color(white: 0.22)
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
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 90, height: 90)
                Image(systemName: "questionmark")
                    .font(.system(size: 38, weight: .thin))
                    .foregroundStyle(.white.opacity(0.7))
            }

            VStack(spacing: 8) {
                Text(playerName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)

                Text("Toca para ver tu rol")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
}

struct RevealedContent: View {
    let player: Player

    private var isImpostor: Bool { player.role == .impostor }
    private var roleColor: Color { isImpostor ? .red : .cyan }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Icono con glow vívido
            ZStack {
                Circle()
                    .fill(roleColor.opacity(0.18))
                    .frame(width: 96, height: 96)
                Circle()
                    .fill(roleColor.opacity(0.08))
                    .frame(width: 120, height: 120)
                Image(systemName: isImpostor ? "eye.slash.fill" : "checkmark.seal.fill")
                    .font(.system(size: 42, weight: .medium))
                    .foregroundStyle(roleColor)
            }
            .shadow(color: roleColor.opacity(0.7), radius: 22)

            Spacer().frame(height: 18)

            // Nombre y rol
            VStack(spacing: 4) {
                Text(player.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))

                Text(isImpostor ? "IMPOSTOR" : "CIVIL")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(roleColor)
                    .shadow(color: roleColor.opacity(0.5), radius: 12)
                    .minimumScaleFactor(0.6)
            }

            Spacer().frame(height: 22)

            // Divisor con color
            Rectangle()
                .fill(roleColor.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 24)

            Spacer().frame(height: 22)

            // Palabra o mensaje impostor
            if case let .civilian(word) = player.role {
                VStack(spacing: 7) {
                    Text("TU PALABRA")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white.opacity(0.45))
                        .tracking(3)

                    Text(word)
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: Color.cyan.opacity(0.5), radius: 10)
                        .minimumScaleFactor(0.45)
                        .lineLimit(1)
                }
            } else {
                VStack(spacing: 8) {
                    Text("🤫")
                        .font(.system(size: 38))
                    Text("Engaña a todos")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.red)
                        .shadow(color: .red.opacity(0.4), radius: 6)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 28)
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
