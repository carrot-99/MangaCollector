//  ListSectionView.swift

import SwiftUI

struct ListSectionView<Item: Identifiable & CustomStringConvertible>: View {
    let title: String
    let items: [Item]
    let onAdd: () -> Void
    let onEdit: (Item) -> Void
    @State private var isExpanded = false 

    var body: some View {
        VStack {
            HStack {
                Label(title, systemImage: "list.bullet")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 1)
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                if isExpanded {
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                    }
                }
            }
            .padding(.bottom, 1)

            if isExpanded {
                ScrollView {
                    VStack(spacing: 5) {
                        ForEach(items, id: \.id) { item in
                            HStack {
                                Text(item.description)
                                    .padding()
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: { onEdit(item) }) {
                                    Image(systemName: "pencil")
                                }
                                .padding()
                            }
                            .background(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2))
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(minHeight: 50, maxHeight: 200)
            }
        }
        .padding()
    }
}
