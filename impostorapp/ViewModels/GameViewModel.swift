import SwiftUI
import Observation

@Observable
class GameViewModel {
    // Configuración
    var playerCount: Int = 4
    var impostorCount: Int = 1
    
    // Ahora guardamos la categoría completa, no solo el string
    var selectedCategory: GameCategory?

    // Estado del juego
    var players: [Player] = []
    var currentRevealIndex: Int = 0
    var gameStarted: Bool = false

    // Datos estáticos (Mock data)
    let categories: [GameCategory] = [
        GameCategory(name: "Futbolistas", iconName: "figure.soccer", color: .green, words: ["Messi", "Cristiano", "Neymar", "Mbappé", "Maradona"]),
        GameCategory(name: "Clubes", iconName: "sportscourt", color: .blue, words: ["Boca", "River", "Real Madrid", "Barcelona", "Manchester City"]),
        GameCategory(name: "Palabras Random", iconName: "dice", color: .orange, words: ["Silla", "Nube", "Guitarra", "Unicornio", "Saturno"]),
        GameCategory(name: "Crear Categoría", iconName: "plus", color: .gray, words: [], isCustom: true)
    ]

    func startGame() {
        guard let category = selectedCategory, !category.words.isEmpty else { return }
        guard playerCount > impostorCount else { return }

        // Elegimos palabra al azar
        let secretWord = category.words.randomElement() ?? "Error"

        var roles: [GameRole] = []
        roles += Array(repeating: .impostor, count: impostorCount)
        roles += Array(repeating: .civilian(word: secretWord),
                       count: playerCount - impostorCount)

        roles.shuffle()

        players = roles.enumerated().map {
            Player(name: "Jugador \($0 + 1)", role: $1)
        }

        currentRevealIndex = 0
        gameStarted = true
    }
    
    func resetGame() {
        gameStarted = false
        players = []
        // No reseteamos selectedCategory para que no tenga que volver a elegir
    }
}
