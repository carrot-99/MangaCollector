//  ListSectionView.swift

import SwiftUI

struct ListSectionView<Item: Identifiable & CustomStringConvertible>: View {
    let title: String
    let items: [Item]
    let onAdd: () -> Void
    let onEdit: (Item) -> Void
    @State private var isExpanded: Bool

    init(title: String, items: [Item], onAdd: @escaping () -> Void, onEdit: @escaping (Item) -> Void) {
        self.title = title
        self.items = items
        self.onAdd = onAdd
        self.onEdit = onEdit
        // 登録がある場合は最初から開いておく
        self._isExpanded = State(initialValue: !items.isEmpty)
    }

    var body: some View {
        VStack {
            HStack {
                Label(items.isEmpty ? title : "\(title)（\(items.count)）", systemImage: "list.bullet")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 1)
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button(action: {
                    isExpanded = true
                    onAdd()
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("\(title)を追加")
            }
            .padding(.bottom, 1)

            if isExpanded {
                if items.isEmpty {
                    Text("登録はありません")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                VStack(spacing: 5) {
                    ForEach(items, id: \.id) { item in
                        Button(action: { onEdit(item) }) {
                            HStack {
                                Text(item.description)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
    }
}
