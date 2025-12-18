import SwiftUI
import Observation

@Observable
class GameViewModel {
    // Configuración
    var playerCount: Int = 4
    var impostorCount: Int = 1
    var selectedCategory: GameCategory?

    // Estado del juego
    var players: [Player] = []
    var currentRevealIndex: Int = 0
    var gameStarted: Bool = false
    
    // --- NUEVO: Estado para controlar si el juego está en curso (post-revelación) ---
    var isRoundActive: Bool = false

    // Datos estáticos (Categorías) ... [Mantener igual que antes]
    let categories: [GameCategory] = [
        GameCategory(name: "Futbolistas", iconName: "figure.soccer", color: .green, words: ["Messi", "Cristiano", "Neymar", "Mbappé", "Maradona"]),
        GameCategory(name: "Clubes", iconName: "sportscourt", color: .blue, words: ["Boca", "River", "Real Madrid", "Barcelona", "Manchester City"]),
        GameCategory(name: "Palabras Random", iconName: "dice", color: .orange, words: ["Silla", "Nube", "Guitarra", "Unicornio", "Saturno"]),
        GameCategory(name: "Crear Categoría", iconName: "plus", color: .gray, words: [], isCustom: true)
    ]

    func startGame() {
        guard let category = selectedCategory, !category.words.isEmpty else { return }
        guard impostorCount <= playerCount else { return }

        let secretWord = category.words.randomElement() ?? "Error"
        var roles: [GameRole] = []
        roles += Array(repeating: .impostor, count: impostorCount)
        let civilianCount = max(0, playerCount - impostorCount)
        roles += Array(repeating: .civilian(word: secretWord), count: civilianCount)
        roles.shuffle()

        players = roles.enumerated().map {
            Player(name: "Jugador \($0 + 1)", role: $1)
        }

        currentRevealIndex = 0
        gameStarted = true
        isRoundActive = false // Aún no están jugando, están revelando
    }
    
    // Función para cuando termina la revelación
    func startRound() {
        isRoundActive = true
    }

    func resetGame() {
        gameStarted = false
        isRoundActive = false
        players = []
        currentRevealIndex = 0
        // No reseteamos la categoría para que no tenga que elegirla de nuevo si quiere re-jugar
    }
}
