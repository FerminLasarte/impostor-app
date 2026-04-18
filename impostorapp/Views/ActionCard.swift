import SwiftUI

struct ActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: isEnabled ? action : {}) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .fill(.white.opacity(isEnabled ? 0.14 : 0.05))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(isEnabled ? .white : .white.opacity(0.28))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(isEnabled ? .white : .white.opacity(0.32))
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(isEnabled ? .white.opacity(0.52) : .white.opacity(0.18))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(isEnabled ? .white.opacity(0.36) : .white.opacity(0.12))
            }
            .padding(18)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .opacity(isEnabled ? 1 : 0.58)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(!isEnabled)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(duration: 0.18, bounce: 0.08), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 12) {
            ActionCard(title: "Jugar Local", subtitle: "Un dispositivo, varios amigos", icon: "iphone.gen3", isEnabled: true) {}
            ActionCard(title: "Sala Online", subtitle: "Próximamente", icon: "wifi", isEnabled: false) {}
        }
        .padding(20)
    }
}
