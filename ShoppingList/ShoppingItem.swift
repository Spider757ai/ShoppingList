import Foundation



struct ShoppingItem: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var category: String
    var quantity: Int
    var isPurchased: Bool

    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        quantity: Int = 1,
        isPurchased: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.quantity = quantity
        self.isPurchased = isPurchased
    }
    static func normalizedName(_ name: String) -> String {
        name.split(whereSeparator: { $0.isWhitespace })
            .joined(separator: " ")
    }
}

extension ShoppingItem {
    static let samples = [
        ShoppingItem(name: "Молоко", category: "Продукты", quantity: 2),
        ShoppingItem(name: "Блокнот", category: "Учёба"),
        ShoppingItem(name: "Батарейки", category: "Дом", isPurchased: true)
    ]
}
