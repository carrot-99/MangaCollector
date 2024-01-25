//  EditMissingVolumeDialog.swift

import SwiftUI

struct EditMissingVolumeDialog: View {
    @Binding var showingDialog: Bool
    @Binding var editedVolumeNumber: Int16
    var maxVolumeNumber: Int16
    var onSave: () -> Void
    var onDelete: () -> Void
    @Environment(\.colorScheme) var colorScheme

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            newEditMissingVolumeDialogView()
        } else {
            oldEditMissingVolumeDialogView()
        }
    }

    private func newEditMissingVolumeDialogView() -> some View {
        NavigationView {
            missingVolumeDialogContents()
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

    private func oldEditMissingVolumeDialogView() -> some View {
        VStack(alignment: .leading) {
            missingVolumeDialogContents()
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
        }
        .padding(.horizontal)
        .background(backgroundColor)
        .padding()
    }

    private func missingVolumeDialogContents() -> some View {
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
    }

    @ViewBuilder
    private func editDeleteButtons() -> some View {
        HStack {
            Button("削除") {
                onDelete()
                showingDialog = false
            }
            .foregroundColor(.red)

            Button("保存") {
                onSave()
                showingDialog = false
            }
        }
    }
}
