import SwiftUI

enum ShoppingCategory: String, CaseIterable {
    case food = "Продукты"
    case home = "Дом"
    case study = "Учёба"
    case clothes = "Одежда"
    case other = "Другое"

    var symbol: String {
        switch self {
        case .food: return "cart.fill"
        case .home: return "house.fill"
        case .study: return "book.fill"
        case .clothes: return "tshirt.fill"
        case .other: return "tag.fill"
        }
    }

    var color: Color {
        switch self {
        case .food: return .green
        case .home: return .orange
        case .study: return .blue
        case .clothes: return .purple
        case .other: return .gray
        }
    }
}
