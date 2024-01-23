//  AddAuthorDialog.swift

import SwiftUI

struct AddAuthorDialog: View {
    @Binding var showingDialog: Bool
    @State private var authorName = ""
    var onAdd: (String) -> Void

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
                trailing: Button("追加") {
                    onAdd(authorName)
                    showingDialog = false
                }
            )
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
