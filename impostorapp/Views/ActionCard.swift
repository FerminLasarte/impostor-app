import SwiftUI

struct ActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    var isDark: Bool = false
    let screenWidth: CGFloat // Recibimos el ancho para calcular tamaños dinámicos
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: screenWidth * 0.05) {
                // Icono en caja dinámica
                ZStack {
                    RoundedRectangle(cornerRadius: screenWidth * 0.03)
                        .fill(.white.opacity(isDark ? 0.1 : 0.2))
                        .frame(width: screenWidth * 0.13, height: screenWidth * 0.13)
                    
                    Image(systemName: icon)
                        .font(.system(size: screenWidth * 0.06))
                        .foregroundStyle(isDark ? .gray : .white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: screenWidth * 0.05, weight: .heavy))
                        .foregroundStyle(isDark ? .gray : .white)
                    
                    Text(subtitle)
                        .font(.system(size: screenWidth * 0.03, weight: .medium))
                        .foregroundStyle(isDark ? .gray.opacity(0.6) : .white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: screenWidth * 0.04, weight: .bold))
                    .foregroundStyle(isDark ? .gray.opacity(0.5) : .white.opacity(0.5))
            }
            .padding(screenWidth * 0.04)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: screenWidth * 0.06, style: .continuous))
            .shadow(color: isDark ? .clear : .purple.opacity(0.4), radius: screenWidth * 0.025, x: 0, y: screenWidth * 0.01)
            .overlay(
                RoundedRectangle(cornerRadius: screenWidth * 0.06)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Estilo para animación de pulsación
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.05 : 0)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            // Versión Normal
            ActionCard(
                title: "Jugar Local",
                subtitle: "Un dispositivo",
                icon: "iphone",
                gradient: LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing),
                screenWidth: 390, // Ancho simulado de iPhone
                action: {}
            )
            
            // Versión "Dark" / Deshabilitada
            ActionCard(
                title: "Online",
                subtitle: "Próximamente",
                icon: "cloud",
                gradient: LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.4)], startPoint: .leading, endPoint: .trailing),
                isDark: true,
                screenWidth: 390,
                action: {}
            )
        }
        .padding()
    }
}
