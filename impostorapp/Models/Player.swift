import Foundation

enum GameRole: Equatable {
    case civilian(word: String) // El civil conoce la palabra
    case impostor               // El impostor no tiene palabra
}

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var role: GameRole
    var hasSeenRole: Bool = false
}
