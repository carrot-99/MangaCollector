//  AddMissingVolumeDialog.swift

import SwiftUI

struct AddMissingVolumeDialog: View {
    @Binding var showingDialog: Bool
    @Binding var newVolumeNumber: Int16
    var maxVolumeNumber: Int16
    var onAdd: () -> Void

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("不足巻数")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 1)
                Picker("不足巻数", selection: $newVolumeNumber) {
                    ForEach(0...maxVolumeNumber, id: \.self) { number in
                        Text("\(number)巻").tag(number as Int16)
                    }
                }
            }
            .navigationBarItems(
                leading: Button("閉じる") {
                    showingDialog = false
                },
                trailing: Button("追加") {
                    onAdd()
                    showingDialog = false
                }
            )
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
