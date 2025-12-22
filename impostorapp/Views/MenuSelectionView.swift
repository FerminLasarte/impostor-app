//
//  MenuSelectionView.swift
//  impostorapp
//
//  Created by Fermin Lasarte on 18/12/2025.
//


import SwiftUI
import FirebaseAuth

struct MenuSelectionView: View {
    var authViewModel: AuthViewModel
    @Binding var path: NavigationPath
    var viewModel: GameViewModel

    var userName: String {
        authViewModel.userSession?.displayName ?? "Impostor"
    }

    var body: some View {
        GeometryReader {
            geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                // 1. Fondo Ambiental
                BackgroundView(
                    width: width,
                    height: height,
                )

                VStack(spacing: 0) {
                    // 2. Barra Superior (Perfil)
                    UserProfileHeader(
                        userName: userName,
                        width: width
                    ).padding(.top, height * 0.02)

                    Spacer()

                    // 3. Título Hero
                    HeroTitleView(width: width, height: height)

                    Spacer()

                    // 4. Tarjetas de Acción
                    VStack(spacing: height * 0.02) {
                        ActionCard(
                            title: "Jugar Local",
                            subtitle: "Un dispositivo, varios amigos",
                            icon: "iphone.gen3",
                            gradient: LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing),
                            screenWidth: width
                        ) {
                            path.append("localGame")
                        }
                        
                        ActionCard(
                            title: "Crear Sala Online",
                            subtitle: "Próximamente",
                            icon: "cloud.fill",
                            gradient: LinearGradient(colors: [Color(uiColor: .systemGray5), Color(uiColor: .systemGray4)], startPoint: .leading, endPoint: .trailing),
                            isDark: true,
                            screenWidth: width
                        ) {
                            // Aquí iría la lógica futura de online
                        }
                    }
                    .padding(.horizontal, width * 0.06)
                    .padding(.bottom, height * 0.05)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// --- Componentes Visuales Extraídos para Limpieza ---

struct BackgroundView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Circle()
                .fill(Color.indigo.opacity(0.4))
                .frame(width: width * 0.8, height: width * 0.8)
                .blur(radius: width * 0.25)
                .offset(x: -width * 0.25, y: -height * 0.25)
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: width * 0.8, height: width * 0.8)
                .blur(radius: width * 0.25)
                .offset(x: width * 0.25, y: height * 0.25)
        }
        .ignoresSafeArea()
    }
}

struct UserProfileHeader: View {
    let userName: String
    let width: CGFloat
    
    var body: some View {
        HStack {
            HStack(spacing: width * 0.03) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .blue,
                                    .purple
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: width * 0.12, height: width * 0.12)
                    Text(userName.prefix(1).uppercased())
                        .font(.system(size: width * 0.05, weight: .bold))
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("BIENVENIDO")
                        .font(.system(size: width * 0.025, weight: .black))
                        .foregroundStyle(.gray)
                        .tracking(1)
                    Text(userName)
                        .font(.system(size: width * 0.045, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, width * 0.04)
            .padding(.vertical, width * 0.02)
            .background(Color.white.opacity(0.1))
            .clipShape(Capsule())
            
            Spacer()
        }
        .padding(.horizontal, width * 0.06)
    }
}

struct HeroTitleView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: -height * 0.015) {
            ZStack {
                Image(systemName: "theatermasks.fill")
                    .font(.system(size: width * 0.35))
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
                .font(.system(size: width * 0.16))
                .fontWeight(.black)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
                .tracking(-2)
                .shadow(color: .blue.opacity(0.8), radius: width * 0.04)
            
            Text("DESCUBRE AL TRAIDOR")
                .font(.system(size: width * 0.035, weight: .bold))
                .foregroundStyle(.gray)
                .tracking(width * 0.01)
        }
    }
}

#Preview {
    MenuSelectionView(
        authViewModel: AuthViewModel(),
        path: .constant(NavigationPath()),
        viewModel: GameViewModel()
    )
}
