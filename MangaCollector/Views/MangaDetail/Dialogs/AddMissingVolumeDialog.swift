//  AddMissingVolumeDialog.swift

import SwiftUI

struct AddMissingVolumeDialog: View {
    @Binding var showingDialog: Bool
    @Binding var newVolumeNumber: Int16
    var maxVolumeNumber: Int16
    var onAdd: () -> Void
    @Environment(\.colorScheme) var colorScheme

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            newAddMissingVolumeDialogView()
        } else {
            oldAddMissingVolumeDialogView()
        }
    }

    private func newAddMissingVolumeDialogView() -> some View {
        NavigationView {
            missingVolumeDialogContents()
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
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func oldAddMissingVolumeDialogView() -> some View {
        VStack(alignment: .leading) {
            missingVolumeDialogContents()
                .padding(.top)
            HStack {
                Spacer()
                Button("閉じる") {
                    showingDialog = false
                }
                Spacer()
                Button("追加") {
                    onAdd()
                    showingDialog = false
                }
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
    }
}
