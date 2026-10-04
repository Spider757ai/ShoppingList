import SwiftUI

enum ShoppingFilter: Hashable {
    case all
    case active
    case purchased
}

enum SortOption: Hashable {
    case name
    case category
    case quantity
}

struct ContentView: View {
    @State private var items: [ShoppingItem] = ShoppingStorage.load()
    @State private var selectsort: SortOption = .name
    @State private var selectedFilter: ShoppingFilter = .all
    @State private var searchText = ""
    @State private var showingAddItem = false

    private var visibleItems: [ShoppingItem] {
        let filteredItems = items.filter { item in
            let matchesSearch = searchText.isEmpty
                || item.name.localizedCaseInsensitiveContains(searchText)
                || item.category.localizedCaseInsensitiveContains(searchText)

            let matchesStatus: Bool

            switch selectedFilter {
            case .all:
                matchesStatus = true

            case .active:
                matchesStatus = !item.isPurchased

            case .purchased:
                matchesStatus = item.isPurchased
            }

            return matchesSearch && matchesStatus
        }

        return filteredItems.sorted { first, second in
            switch selectsort {
            case .name:
                return first.name < second.name

            case .category:
                return first.category < second.category

            case .quantity:
                return first.quantity < second.quantity
            }
        }
    }
    private var remainingCount: Int {
        items.filter { !$0.isPurchased }.count
    }
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Осталось купить: \(remainingCount)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                List {
                    Picker("Статус", selection: $selectedFilter) {
                        Text("Все").tag(ShoppingFilter.all)
                        Text("Нужно купить").tag(ShoppingFilter.active)
                        Text("Куплено").tag(ShoppingFilter.purchased)
                    }
                    .pickerStyle(.segmented)

                    if visibleItems.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                    } else {
                        ForEach(visibleItems) { item in
                            NavigationLink(value: item.id) {
                                ShoppingItemRow(item: item) {
                                    toggle(item)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Покупки")
            .searchable(
                text: $searchText,
                prompt: "Название или категория"
            )
            .toolbar {
                Button("Добавить", systemImage: "plus") {
                    showingAddItem = true
                }

                Menu("Сортировка", systemImage: "arrow.up.arrow.down") {
                    Picker("Сортировать по", selection: $selectsort) {
                        Text("По названию").tag(SortOption.name)
                        Text("По категории").tag(SortOption.category)
                        Text("По количеству").tag(SortOption.quantity)
                    }
                }
                .accessibilityIdentifier("sortMenu")
            }
            .sheet(isPresented: $showingAddItem) {
                AddShoppingItemView { newItem in
                    items.append(newItem)
                }
            }
            .navigationDestination(for: UUID.self) { id in
                if let index = items.firstIndex(where: { $0.id == id }) {
                    ShoppingItemDetailView(item: $items[index])
                }
            }
        }
        .onChange(of: items) {
            ShoppingStorage.save(items)
        }
    }

    private func toggle(_ item: ShoppingItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        items[index].isPurchased.toggle()
    }

    private func delete(at offsets: IndexSet) {
        let ids = offsets.map { visibleItems[$0].id }
        items.removeAll { ids.contains($0.id) }
    }
}

#Preview("Список покупок") {
    ContentView()
}
