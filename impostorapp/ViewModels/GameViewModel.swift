import SwiftUI
import Observation

@Observable
class GameViewModel {
    // Configuración
    var playerCount: Int = 4
    var impostorCount: Int = 1
    var selectedCategory: String = "Lugares"

    // Estado del juego
    var players: [Player] = []
    var currentRevealIndex: Int = 0
    var gameStarted: Bool = false

    private let categories = [
        "Lugares": ["Playa", "Escuela", "Hospital", "Cine"],
        "Comidas": ["Pizza", "Sushi", "Asado", "Ensalada"],
        "Animales": ["Perro", "Gato", "Elefante", "León"]
    ]

    func startGame() {
        guard playerCount > impostorCount else { return }

        let secretWord = categories[selectedCategory]?.randomElement() ?? "Nada"

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
    }
}
