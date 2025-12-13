import SwiftUI

class GameViewModel: ObservableObject {
    // MARK: - Inputs (Configuración)
    @Published var playerCount: Int = 4
    @Published var impostorCount: Int = 1
    @Published var selectedCategory: String = "Lugares"
    
    // MARK: - Game State
    @Published var players: [Player] = []
    @Published var currentRevealIndex: Int = 0 // Para controlar a quién le toca ver
    @Published var gameStarted: Bool = false
    
    // Mock Data (En una app real, esto vendría de un Service/SwiftData)
    privatelet categories = [
        "Lugares": ["Playa", "Escuela", "Hospital", "Cine"],
        "Comidas": ["Pizza", "Sushi", "Asado", "Ensalada"],
        "Animales": ["Perro", "Gato", "Elefante", "León"]
    ]
    
    // MARK: - Logic
    func startGame() {
        // 1. Validaciones básicas
        guard playerCount > impostorCount else { return }
        
        // 2. Elegir palabra secreta
        let words = categories[selectedCategory] ?? ["Error"]
        let secretWord = words.randomElement() ?? "Nada"
        
        // 3. Crear roles
        var roles: [GameRole] = []
        // Llenamos con impostores
        for _ in 0..<impostorCount { roles.append(.impostor) }
        // Llenamos el resto con civiles
        for _ in 0..<(playerCount - impostorCount) { roles.append(.civilian(word: secretWord)) }
        
        // 4. Barajar roles (Shuffle) - CRUCIAL para que sea aleatorio
        roles.shuffle()
        
        // 5. Crear jugadores
        players = roles.enumerated().map { (index, role) in
            Player(name: "Jugador \(index + 1)", role: role)
        }
        
        currentRevealIndex = 0
        gameStarted = true
    }
    
    func resetGame() {
        gameStarted = false
        players = []
    }
}
