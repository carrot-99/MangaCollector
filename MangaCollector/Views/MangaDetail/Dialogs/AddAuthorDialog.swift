//  AddAuthorDialog.swift

import SwiftUI

struct AddAuthorDialog: View {
    @Binding var showingDialog: Bool
    @State private var authorName = ""
    @Binding var currentAlert: AlertType?
    var onAdd: (String) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            newAddAuthorDialogView()
        } else {
            oldAddAuthorDialogView()
        }
    }

    private func newAddAuthorDialogView() -> some View {
        NavigationView {
            authorDialogContents()
                .navigationBarItems(
                    leading: Button("閉じる") {
                        showingDialog = false
                    },
                    trailing: Button("追加") {
                        addAuthorAction()
                    }
                )
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func oldAddAuthorDialogView() -> some View {
        VStack(alignment: .leading) {
            authorDialogContents()
                .padding(.top)
            HStack {
                Spacer()
                Button("閉じる") {
                    showingDialog = false
                }
                Spacer()
                Button("追加") {
                    addAuthorAction()
                }
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

    private func addAuthorAction() {
        if isAuthorNameValid(authorName) {
            onAdd(authorName)
            showingDialog = false
        } else {
            currentAlert = .authorNameError
        }
    }

    private func isAuthorNameValid(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
