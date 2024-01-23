//  EditAuthorDialog.swift

import SwiftUI

struct EditAuthorDialog: View {
    @Binding var showingDialog: Bool
    @Binding var author: Author
    @State private var authorName: String
    var onEdit: (Author, String) -> Void
    var onDelete: (Author) -> Void

    init(showingDialog: Binding<Bool>, author: Binding<Author>, onEdit: @escaping (Author, String) -> Void, onDelete: @escaping (Author) -> Void) {
        self._showingDialog = showingDialog
        self._author = author
        self._authorName = State(initialValue: author.wrappedValue.name ?? "")
        self.onEdit = onEdit
        self.onDelete = onDelete
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("著者名")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 1)
                TextField("著者名", text: $authorName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .navigationBarItems(
                leading: Button("閉じる") {
                    showingDialog = false
                },
                trailing: HStack {
                    Button("削除") {
                        onDelete(author)
                        showingDialog = false
                    }
                    .foregroundColor(.red)

                    Spacer()

                    Button("保存") {
                        onEdit(author, authorName)
                        showingDialog = false
                    }
                }
            )
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
