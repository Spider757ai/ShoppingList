import SwiftUI

struct ShoppingItemDetailView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var item: ShoppingItem
    @State private var draft: ShoppingItem

    init(item: Binding<ShoppingItem>) {
        self._item = item
        self._draft = State(initialValue: item.wrappedValue)
    }

    private var cleanedName: String {
        ShoppingItem.normalizedName(draft.name)
    }

    private var canSave: Bool {
        !cleanedName.isEmpty && (1...99).contains(draft.quantity)
    }

    var body: some View {
        Form {
            TextField("Название", text: $draft.name)

            Picker("Категория", selection: $draft.category) {
                // Сохраняем возможность показать старую категорию
                if ShoppingCategory(rawValue: draft.category) == nil {
                    Text(
                        draft.category.isEmpty
                            ? "Без категории"
                            : draft.category
                    )
                    .tag(draft.category)
                }

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
                "Количество: \(draft.quantity)",
                value: $draft.quantity,
                in: 1...99
            )

            Toggle("Куплено", isOn: $draft.isPurchased)
        }
        .navigationTitle("Покупка")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Сохранить") {
                    guard canSave else { return }

                    draft.name = cleanedName
                    item = draft
                    dismiss()
                }
                .disabled(!canSave)
            }
        }
    }
}
