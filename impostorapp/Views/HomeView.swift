import SwiftUI
import FirebaseAuth
import FirebaseCore

struct HomeView: View {
    @State private var viewModel = GameViewModel()
    var authViewModel: AuthViewModel
    @State private var path = NavigationPath()

    var userName: String {
        if let name = authViewModel.userSession?.displayName, !name.isEmpty {
            return name
        }
        return "Impostor"
    }

    var body: some View {
        GeometryReader { geometry in
            // Guardamos anchos y altos para escribir menos
            let width = geometry.size.width
            let height = geometry.size.height
            
            NavigationStack(path: $path) {
                ZStack {
                    // 1. FONDO CON ACTITUD (Deep Gradient)
                    ZStack {
                        Color.black.ignoresSafeArea()
                        
                        // Orbe de luz ambiental (Responsive)
                        // Usamos width para el tamaño para que sean circulares
                        Circle()
                            .fill(Color.indigo.opacity(0.4))
                            .frame(width: width * 0.8, height: width * 0.8) // 80% del ancho
                            .blur(radius: width * 0.25)
                            .offset(x: -width * 0.25, y: -height * 0.25)
                        
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: width * 0.8, height: width * 0.8)
                            .blur(radius: width * 0.25)
                            .offset(x: width * 0.25, y: height * 0.25)
                    }
                    .ignoresSafeArea()

                    VStack(spacing: 0) {
                        
                        // 2. TOP BAR (Perfil minimalista)
                        HStack {
                            HStack(spacing: width * 0.03) { // Espaciado dinámico
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: width * 0.12, height: width * 0.12) // ~45pt en iPhone normal
                                    
                                    Text(userName.prefix(1).uppercased())
                                        .font(.system(size: width * 0.05, weight: .bold)) // Fuente dinámica
                                        .foregroundStyle(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("BIENVENIDO")
                                        .font(.system(size: width * 0.025, weight: .black)) // Caption dinámica
                                        .foregroundStyle(.gray)
                                        .tracking(1)
                                    
                                    Text(userName)
                                        .font(.system(size: width * 0.045, weight: .bold)) // Headline dinámica
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.horizontal, width * 0.04)
                            .padding(.vertical, width * 0.02)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal, width * 0.06)
                        .padding(.top, height * 0.02)

                        Spacer()

                        // 3. HÉROE (Máscaras y Título)
                        VStack(spacing: -height * 0.015) { // Spacing negativo relativo
                            ZStack {
                                Image(systemName: "theatermasks.fill")
                                    .font(.system(size: width * 0.35)) // 35% del ancho de pantalla
                                    .foregroundStyle(.blue.opacity(0.5))
                                    .blur(radius: width * 0.05)
                                    .offset(y: height * 0.015)
                                
                                Image(systemName: "theatermasks.fill")
                                    .font(.system(size: width * 0.35))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.white, .indigo],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .indigo.opacity(0.5), radius: width * 0.05, x: 0, y: height * 0.015)
                            }
                            .padding(.bottom, height * 0.03)

                            Text("IMPOSTOR")
                                .font(.system(size: width * 0.16)) // ~64pt
                                .fontWeight(.black)
                                .fontDesign(.rounded)
                                .foregroundStyle(.white)
                                .tracking(-2)
                                .shadow(color: .blue.opacity(0.8), radius: width * 0.04)
                            
                            Text("DESCUBRE AL TRAIDOR")
                                .font(.system(size: width * 0.035, weight: .bold)) // Caption dinámica
                                .foregroundStyle(.gray)
                                .tracking(width * 0.01) // Tracking relativo
                        }
                        .padding(.vertical, height * 0.05)

                        Spacer()

                        // 4. ACCIONES
                        VStack(spacing: height * 0.02) {
                            // Pasamos el ancho calculado para que la tarjeta se adapte
                            ActionCard(
                                title: "Jugar Local",
                                subtitle: "Un dispositivo, varios amigos",
                                icon: "iphone.gen3",
                                gradient: LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing),
                                screenWidth: width // <--- Nuevo parámetro
                            ) {
                                path.append("localGame")
                            }
                            
                            ActionCard(
                                title: "Crear Sala Online",
                                subtitle: "Próximamente",
                                icon: "cloud.fill",
                                gradient: LinearGradient(colors: [Color(uiColor: .systemGray5), Color(uiColor: .systemGray4)], startPoint: .leading, endPoint: .trailing),
                                isDark: true,
                                screenWidth: width // <--- Nuevo parámetro
                            ) {
                                print("Crear sala")
                            }
                        }
                        .padding(.horizontal, width * 0.06)
                        .padding(.bottom, height * 0.05)
                    }
                }
                .navigationDestination(for: String.self) { value in
                    if value == "localGame" {
                        LocalCategorySelectionView(viewModel: viewModel, path: $path)
                    } else if value == "revealGame" {
                        RevealView(viewModel: viewModel, path: $path)
                    }
                }
            }
        }
    }
}

// --- ACTION CARD RESPONSIVE ---
struct ActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    var isDark: Bool = false
    let screenWidth: CGFloat // Recibimos el ancho de pantalla para calcular tamaños internos
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: screenWidth * 0.05) {
                // Icono en caja dinámica
                ZStack {
                    RoundedRectangle(cornerRadius: screenWidth * 0.03)
                        .fill(.white.opacity(isDark ? 0.1 : 0.2))
                        .frame(width: screenWidth * 0.13, height: screenWidth * 0.13) // ~50pt
                    
                    Image(systemName: icon)
                        .font(.system(size: screenWidth * 0.06)) // ~Title2
                        .foregroundStyle(isDark ? .gray : .white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: screenWidth * 0.05, weight: .heavy)) // ~Title3
                        .foregroundStyle(isDark ? .gray : .white)
                    
                    Text(subtitle)
                        .font(.system(size: screenWidth * 0.03, weight: .medium)) // ~Caption
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

// Estilo para que el botón se encoja al pulsar (Toque premium)
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.05 : 0)
    }
}

// --- SUBVISTA: CATEGORÍAS (Ligeramente ajustada para encajar) ---
struct LocalCategorySelectionView: View {
    @Bindable var viewModel: GameViewModel
    @Binding var path: NavigationPath
    
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 20)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Elige un Tema")
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                    .padding(.top)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.categories) { category in
                        CategoryCard(category: category)
                            .onTapGesture {
                                if category.isCustom {
                                    print("Crear")
                                } else {
                                    viewModel.selectedCategory = category
                                    path.append(category)
                                }
                            }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground)) // Mantenemos contraste aquí
        .navigationDestination(for: GameCategory.self) { category in
            SetupView(viewModel: viewModel, path: $path)
        }
    }
}

// --- COMPONENTE: TARJETA DE CATEGORÍA ---
// (Mantenemos la que tenías pero aseguramos que compile aquí)
struct CategoryCard: View {
    let category: GameCategory

    var body: some View {
        VStack {
            Image(systemName: category.iconName)
                .font(.system(size: 40))
                .foregroundStyle(category.color.gradient)
                .frame(height: 50)
                .shadow(color: category.color.opacity(0.3), radius: 5)
            
            Text(category.name)
                .font(.headline)
                .fontDesign(.rounded)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel())
}
