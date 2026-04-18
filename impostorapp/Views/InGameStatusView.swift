import SwiftUI

struct InGameStatusView: View {
    var viewModel: GameViewModel
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Pulso rojo de tensión
            Circle()
                .fill(Color.red.opacity(0.18))
                .frame(width: 340, height: 340)
                .blur(radius: 70)

            VStack(spacing: 0) {
                Text("PARTIDA EN CURSO")
                    .font(.system(size: 11, weight: .black))
                    .tracking(3.5)
                    .foregroundStyle(.red.opacity(0.68))
                    .padding(.top, 52)

                Spacer()

                // Panel de estadísticas
                HStack(spacing: 0) {
                    StatColumn(
                        count: viewModel.playerCount - viewModel.impostorCount,
                        label: "Civiles",
                        color: .blue,
                        icon: "person.fill"
                    )

                    Rectangle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 1, height: 90)

                    StatColumn(
                        count: viewModel.impostorCount,
                        label: "Impostores",
                        color: .red,
                        icon: "eye.slash.fill"
                    )
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 28)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                .padding(.horizontal, 20)

                Text("Debatan y encuentren al traidor")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.38))
                    .padding(.top, 28)

                Spacer()

                Button {
                    path = NavigationPath()
                    viewModel.resetGame()
                } label: {
                    Text("Terminar Partida")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.red.opacity(0.88))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: .red.opacity(0.28), radius: 12, y: 4)
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
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(color.opacity(0.8))

            Text("\(count)")
                .font(.system(size: 56, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText())

            Text(label.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(color.opacity(0.65))
                .tracking(1.5)
        }
        .frame(maxWidth: .infinity)
    }
}
