import SwiftUI

struct AddShoppingItemView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var category = ShoppingCategory.food.rawValue
    @State private var quantity = 1

    let onSave: (ShoppingItem) -> Void

    private var cleanedName: String {
        ShoppingItem.normalizedName(name)
    }
    private var canSave: Bool {
        !cleanedName.isEmpty && (1...99).contains(quantity)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Название", text: $name)

                Picker("Категория", selection: $category) {
                    ForEach(ShoppingCategory.allCases, id: \.self) { option in
                        Label {
                            Text(option.rawValue)
                        } icon: {
                            Image(systemName: option.symbol)
                                .foregroundStyle(option.color)
                        }
                        .tag(option.rawValue)
                    }
                }
                .pickerStyle(.navigationLink)

                Stepper(
                    "Количество: \(quantity)",
                    value: $quantity,
                    in: 1...99
                )
            }
            .navigationTitle("Новая покупка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        guard canSave else { return }

                        let item = ShoppingItem(
                            name: cleanedName,
                            category: category,
                            quantity: quantity
                        )

                        onSave(item)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
