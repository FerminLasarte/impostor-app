import SwiftUI
import FirebaseAuth

struct MenuSelectionView: View {
    var authViewModel: AuthViewModel
    @Binding var path: NavigationPath
    var viewModel: GameViewModel

    private var userName: String {
        authViewModel.userSession?.displayName ?? "Jugador"
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Orbes ambientales
            GeometryReader { geo in
                Circle()
                    .fill(Color.indigo.opacity(0.38))
                    .frame(width: geo.size.width)
                    .blur(radius: geo.size.width * 0.3)
                    .offset(x: -geo.size.width * 0.25, y: -geo.size.height * 0.12)

                Circle()
                    .fill(Color.purple.opacity(0.22))
                    .frame(width: geo.size.width * 0.9)
                    .blur(radius: geo.size.width * 0.3)
                    .offset(x: geo.size.width * 0.32, y: geo.size.height * 0.52)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    ProfileChip(name: userName)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Spacer()

                // Hero
                VStack(spacing: 22) {
                    Image(systemName: "theatermasks.fill")
                        .font(.system(size: 80, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .indigo.opacity(0.75)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .indigo.opacity(0.65), radius: 28, y: 10)

                    VStack(spacing: 9) {
                        Text("IMPOSTOR")
                            .font(.system(size: 54, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .tracking(-1.5)

                        Text("DESCUBRE AL TRAIDOR")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white.opacity(0.35))
                            .tracking(3.5)
                    }
                }

                Spacer()

                // Acciones
                VStack(spacing: 10) {
                    ActionCard(
                        title: "Jugar Local",
                        subtitle: "Un dispositivo, varios amigos",
                        icon: "iphone.gen3",
                        isEnabled: true
                    ) {
                        path.append("localGame")
                    }

                    ActionCard(
                        title: "Sala Online",
                        subtitle: "Próximamente",
                        icon: "wifi",
                        isEnabled: false
                    ) {}
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
            }
        }
        .navigationBarHidden(true)
    }
}

struct ProfileChip: View {
    let name: String

    var body: some View {
        HStack(spacing: 9) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.indigo, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 30, height: 30)
                Text(name.prefix(1).uppercased())
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
            }
            Text(name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.88))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .glassEffect(.regular, in: Capsule())
    }
}

#Preview {
    MenuSelectionView(
        authViewModel: AuthViewModel(),
        path: .constant(NavigationPath()),
        viewModel: GameViewModel()
    )
}
