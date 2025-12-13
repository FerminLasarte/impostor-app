//
//  RevealView.swift
//  impostorapp
//
//  Created by Fermin Lasarte on 11/12/2025.
//


import SwiftUI

struct RevealView: View {
    // Recibimos el ViewModel compartido
    @ObservedObject var viewModel: GameViewModel
    
    // Estado local solo para esta vista (no necesita estar en el ViewModel global)
    @State private var isRevealed: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // Lógica de visualización
            if isRevealed {
                // ----------------------------
                // ESTADO: CARTA REVELADA
                // ----------------------------
                VStack(spacing: 20) {
                    Text(currentPlayer.role == .impostor ? "🤫" : "👀")
                        .font(.system(size: 80))
                    
                    Text(currentPlayer.name)
                        .font(.title2)
                        .foregroundStyle(.gray)
                    
                    if case let .civilian(word) = currentPlayer.role {
                        Text("TU PALABRA ES:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Text(word)
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundStyle(.blue)
                    } else {
                        Text("ERES EL")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Text("IMPOSTOR")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundStyle(.red)
                        
                        Text("Intenta pasar desapercibido...")
                            .font(.body)
                            .italic()
                    }
                }
                .transition(.scale) // Animación al aparecer
                
            } else {
                // ----------------------------
                // ESTADO: CARTA OCULTA (Instrucciones)
                // ----------------------------
                VStack(spacing: 20) {
                    Image(systemName: "iphone.gen3")
                        .font(.system(size: 60))
                        .foregroundStyle(.purple)
                    
                    Text("Pásale el teléfono a:")
                        .font(.title3)
                    
                    Text(currentPlayer.name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.purple)
                    
                    Text("Toca la pantalla para ver tu rol")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            // Botón de acción (Cambia según el estado)
            Button(action: handleButtonTap) {
                Text(isRevealed ? "Ocultar y Siguiente" : "Mostrar Rol")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isRevealed ? Color.black : Color.purple)
                    .cornerRadius(15)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Ronda de Roles")
        .navigationBarBackButtonHidden(true) // Evitar que vuelvan atrás por error
    }
    
    // Helper computado para obtener el jugador actual de forma segura
    private var currentPlayer: Player {
        // Si el índice se pasa del límite, devolvemos un dummy (fail-safe)
        if viewModel.currentRevealIndex < viewModel.players.count {
            return viewModel.players[viewModel.currentRevealIndex]
        }
        return Player(name: "Error", role: .impostor)
    }
    
    // Lógica del botón
    private func handleButtonTap() {
        if isRevealed {
            // Si ya estaba revelado, pasamos al siguiente
            isRevealed = false
            
            if viewModel.currentRevealIndex < viewModel.players.count - 1 {
                viewModel.currentRevealIndex += 1
            } else {
                // TODO: ¡Todos vieron! Ir a la pantalla de juego/votación
                print("Todos los jugadores han visto sus roles")
            }
        } else {
            // Si estaba oculto, revelamos
            isRevealed = true
        }
    }
}

// Preview para probar la vista en Xcode sin ejecutar la app
#Preview {
    let vm = GameViewModel()
    vm.playerCount = 3
    vm.impostorCount = 1
    vm.startGame()
    return RevealView(viewModel: vm)
}