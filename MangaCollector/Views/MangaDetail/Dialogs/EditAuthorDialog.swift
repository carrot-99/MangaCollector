//  EditAuthorDialog.swift

import SwiftUI

struct EditAuthorDialog: View {
    @Binding var showingDialog: Bool
    @Binding var author: Author
    @State private var authorName: String
    @Binding var currentAlert: AlertType?
    var onEdit: (Author, String) -> Void
    var onDelete: (Author) -> Void
    @Environment(\.colorScheme) var colorScheme

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    init(showingDialog: Binding<Bool>, author: Binding<Author>, currentAlert: Binding<AlertType?>, onEdit: @escaping (Author, String) -> Void, onDelete: @escaping (Author) -> Void) {
        self._showingDialog = showingDialog
        self._author = author
        self._authorName = State(initialValue: author.wrappedValue.name ?? "")
        self._currentAlert = currentAlert
        self.onEdit = onEdit
        self.onDelete = onDelete
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            newEditAuthorDialogView()
        } else {
            oldEditAuthorDialogView()
        }
    }

    private func newEditAuthorDialogView() -> some View {
        NavigationView {
            authorDialogContents()
                .navigationBarItems(
                    leading: Button("閉じる") {
                        showingDialog = false
                    },
                    trailing: editDeleteButtons()
                )
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func oldEditAuthorDialogView() -> some View {
        VStack(alignment: .leading) {
            authorDialogContents()
                .padding(.top)
            HStack {
                Spacer()
                Button("閉じる") {
                    showingDialog = false
                }
                Spacer()
                editDeleteButtons()
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal)
        .background(backgroundColor)
    }

    private func authorDialogContents() -> some View {
        VStack(alignment: .leading) {
            Text("著者名")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            TextField("著者名", text: $authorName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    @ViewBuilder
    private func editDeleteButtons() -> some View {
        HStack {
            Button("削除") {
                onDelete(author)
                showingDialog = false
            }
            .foregroundColor(.red)

            Button("保存") {
                if isAuthorNameValid(authorName) {
                    onEdit(author, authorName)
                    showingDialog = false
                } else {
                    currentAlert = .authorNameError
                }
            }
        }
    }

    private func isAuthorNameValid(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
