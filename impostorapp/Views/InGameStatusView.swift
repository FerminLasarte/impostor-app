import SwiftUI

struct InGameStatusView: View {
    var viewModel: GameViewModel
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Pulso de tensión — más vívido
            Circle()
                .fill(Color.red.opacity(0.35))
                .frame(width: 380, height: 380)
                .blur(radius: 80)

            VStack(spacing: 0) {
                Text("PARTIDA EN CURSO")
                    .font(.system(size: 11, weight: .black))
                    .tracking(4)
                    .foregroundStyle(.red)
                    .padding(.top, 52)

                Spacer()

                // Panel de estadísticas
                HStack(spacing: 0) {
                    StatColumn(
                        count: viewModel.playerCount - viewModel.impostorCount,
                        label: "Civiles",
                        color: .cyan,
                        icon: "person.fill"
                    )

                    Rectangle()
                        .fill(.white.opacity(0.12))
                        .frame(width: 1, height: 100)

                    StatColumn(
                        count: viewModel.impostorCount,
                        label: "Impostores",
                        color: .red,
                        icon: "eye.slash.fill"
                    )
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 32)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                .padding(.horizontal, 20)

                Text("Debatan y encuentren al traidor")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.55))
                    .padding(.top, 28)

                Spacer()

                Button {
                    viewModel.resetGame()
                    // Vuelve a la selección de temática (elimina inGameStatus + revealGame + GameCategory)
                    path.removeLast(3)
                } label: {
                    Text("Terminar Partida")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: .red.opacity(0.5), radius: 16, y: 5)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            viewModel.startRound()
        }
    }
}

struct StatColumn: View {
    let count: Int
    let label: String
    let color: Color
    let icon: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(color)
                .shadow(color: color.opacity(0.6), radius: 8)

            Text("\(count)")
                .font(.system(size: 64, weight: .black, design: .rounded))
                .foregroundStyle(color)
                .shadow(color: color.opacity(0.5), radius: 12)
                .contentTransition(.numericText())

            Text(label.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.white.opacity(0.6))
                .tracking(1.5)
        }
        .frame(maxWidth: .infinity)
    }
}
