//  TitleView.swift

import SwiftUI

struct TitleView: View {
    @Binding var title: String
    @Binding var editingTitle: Bool
    var onSave: () -> Void
    @Binding var currentAlert: AlertType?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label(editingTitle ? "タイトル（編集中）" : "タイトル", systemImage: "book.closed")
                    .font(.caption)
                    .foregroundColor(.gray)

                Button(action: {
                    if editingTitle {
                        if title.trimmingCharacters(in: .whitespaces).isEmpty {
                            currentAlert = .titleError
                        } else {
                            onSave()
                            editingTitle = false
                        }
                    } else {
                        editingTitle = true
                    }
                }) {
                    Image(systemName: editingTitle ? "checkmark.circle.fill" : "pencil")
                }
            }
            .padding(.bottom, 1)

            HStack {
                if editingTitle {
                    TextField("タイトル", text: $title)
                } else {
                    Text(title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2))
        }
        .padding(.horizontal)
    }
}
