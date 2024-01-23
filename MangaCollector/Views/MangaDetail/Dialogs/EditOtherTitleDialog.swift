//  EditOtherTitleDialog.swift

import SwiftUI

struct EditOtherTitleDialog: View {
    @Binding var showingDialog: Bool
    @Binding var editedOtherTitleName: String
    @Binding var editedOtherTitleOwnedVolumes: Int16
    var onSave: () -> Void
    var onDelete: () -> Void

    var body: some View {
        NavigationView {
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
                    ForEach(0...100, id: \.self) { number in
                        Text("\(number)巻").tag(Int16(number) as Int16)
                    }
                }
            }
            .padding(.horizontal)
            .navigationBarItems(
                leading: Button("閉じる") {
                    showingDialog = false
                },
                trailing: HStack {
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
            )
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
