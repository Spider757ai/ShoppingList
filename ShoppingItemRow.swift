import SwiftUI

struct ShoppingItemRow: View {
    let item: ShoppingItem
    let onToggle: () -> Void

    private var categoryInfo: ShoppingCategory {
        ShoppingCategory(rawValue: item.category) ?? .other
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(
                    systemName: item.isPurchased
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.title2)
                .foregroundStyle(
                    item.isPurchased ? Color.green : Color.secondary
                )
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .strikethrough(item.isPurchased)

                HStack(spacing: 6) {
                    Image(systemName: categoryInfo.symbol)
                        .foregroundStyle(categoryInfo.color)

                    Text("\(item.category) · \(item.quantity) шт.")
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}
