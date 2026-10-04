import Foundation

enum ShoppingStorage {
    private static let key = "shoppingItems"
    static func load() -> [ShoppingItem] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        do {
            return try JSONDecoder().decode(
                [ShoppingItem].self,
                from: data
            )
        } catch {
            print("Ошибка загрузки покупок: \(error)")
            return []
        }
    }

    static func save(_ items: [ShoppingItem]) {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Ошибка сохранения покупок: \(error)")
        }
    }
}
