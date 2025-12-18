//
//  InGameStatusView.swift
//  impostorapp
//
//  Created by Fermin Lasarte on 18/12/2025.
//


import SwiftUI

struct InGameStatusView: View {
    var viewModel: GameViewModel
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            // Fondo oscuro para mantener inmersión
            Color.black.ignoresSafeArea()
            
            // Efecto sutil de "Radar" o tensión
            Circle()
                .stroke(lineWidth: 2)
                .foregroundStyle(.red.opacity(0.2))
                .frame(width: 300, height: 300)
                .scaleEffect(1.2)
                .blur(radius: 10)

            VStack(spacing: 40) {
                
                // Header: Estado
                Text("EN CURSO")
                    .font(.system(size: 14, weight: .black))
                    .tracking(4)
                    .foregroundStyle(.red)
                    .opacity(0.8)
                    .padding(.top, 50)
                
                Spacer()

                // Contadores Grandes
                HStack(spacing: 40) {
                    GameStatCircle(
                        count: viewModel.playerCount - viewModel.impostorCount,
                        label: "Civiles",
                        color: .blue,
                        icon: "person.fill"
                    )
                    
                    GameStatCircle(
                        count: viewModel.impostorCount,
                        label: "Impostores",
                        color: .red,
                        icon: "eye.slash.fill"
                    )
                }
                
                Text("Debatan y encuentren al traidor")
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .padding(.top, 20)

                Spacer()

                // Botón Terminar Juego
                Button {
                    // 1. Primero salimos de la pantalla (Navegación)
                    path = NavigationPath() // Esto es más robusto que removeLast(count) para volver al root
                    
                    // 2. Luego reseteamos los datos (con un pequeño delay imperceptible si fuera necesario, o directo)
                    // Al hacerlo así, damos chance a que SwiftUI empiece a desmontar las vistas
                    viewModel.resetGame()
                } label: {
                    Text("Terminar Partida")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .red.opacity(0.4), radius: 10, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startRound()
        }
    }
}

// Subcomponente para los círculos de estadísticas
struct GameStatCircle: View {
    let count: Int
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 4)
                    .frame(width: 100, height: 100)
                
                VStack(spacing: 5) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                    Text("\(count)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            Text(label.uppercased())
                .font(.caption.bold())
                .foregroundStyle(color)
        }
    }
}
