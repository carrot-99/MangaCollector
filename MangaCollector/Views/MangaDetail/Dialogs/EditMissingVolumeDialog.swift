//  EditMissingVolumeDialog.swift

import SwiftUI

struct EditMissingVolumeDialog: View {
    @Binding var showingDialog: Bool
    @Binding var editedVolumeNumber: Int16
    var maxVolumeNumber: Int16
    var onSave: () -> Void
    var onDelete: () -> Void

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("不足巻数（編集）")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 1)
                Picker("編集巻数", selection: $editedVolumeNumber) {
                    ForEach(0...maxVolumeNumber, id: \.self) { number in
                        Text("\(number)巻").tag(number as Int16)
                    }
                }
            }
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
