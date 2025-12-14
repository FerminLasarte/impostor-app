import SwiftUI

struct GameCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String
    let color: Color
    let words: [String]
    
    // Para identificar si es la opción de "Crear"
    var isCustom: Bool = false
}
