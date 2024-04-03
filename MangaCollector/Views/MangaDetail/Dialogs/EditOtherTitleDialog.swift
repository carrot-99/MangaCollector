//  EditOtherTitleDialog.swift

import SwiftUI

struct EditOtherTitleDialog: View {
    @Binding var showingDialog: Bool
    @Binding var editedOtherTitleName: String
    @Binding var editedOtherTitleOwnedVolumes: Int16
    var onSave: () -> Void
    var onDelete: () -> Void
    @Environment(\.colorScheme) var colorScheme

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            newEditOtherTitleDialogView()
        } else {
            oldEditOtherTitleDialogView()
        }
    }

    private func newEditOtherTitleDialogView() -> some View {
        NavigationView {
            otherTitleDialogContents()
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

    private func oldEditOtherTitleDialogView() -> some View {
        VStack(alignment: .leading) {
            otherTitleDialogContents()
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
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal)
        .background(backgroundColor)
        .padding()
    }

    private func otherTitleDialogContents() -> some View {
        VStack(alignment: .leading) {
            Text("タイトル")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            TextField("タイトル", text: $editedOtherTitleName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
            
            Text("所有巻数")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            Picker("所有巻数", selection: $editedOtherTitleOwnedVolumes) {
                ForEach(1...100, id: \.self) { number in
                    Text("\(number)巻").tag(Int16(number) as Int16)
                }
            }
        }
    }

    @ViewBuilder
    private func editDeleteButtons() -> some View {
        HStack {
            Button("削除") {
                onDelete()
                showingDialog = false
            }
            .foregroundColor(.red)

            Spacer()

            Button("保存") {
                onSave()
                showingDialog = false
            }
        }
    }
}
