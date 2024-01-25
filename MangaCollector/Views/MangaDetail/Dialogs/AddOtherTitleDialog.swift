//  AddOtherTitleDialog.swift

import SwiftUI

struct AddOtherTitleDialog: View {
    @Binding var showingDialog: Bool
    @Binding var newOtherTitleName: String
    @Binding var newOtherTitleOwnedVolumes: Int16
    var onAdd: () -> Void
    @Environment(\.colorScheme) var colorScheme

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            newAddOtherTitleDialogView()
        } else {
            oldAddOtherTitleDialogView()
        }
    }

    private func newAddOtherTitleDialogView() -> some View {
        NavigationView {
            otherTitleDialogContents()
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

    private func oldAddOtherTitleDialogView() -> some View {
        VStack(alignment: .leading) {
            otherTitleDialogContents()
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
            TextField("タイトル", text: $newOtherTitleName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
            
            Text("所有巻数")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            Picker("所有巻数", selection: $newOtherTitleOwnedVolumes) {
                ForEach(0...100, id: \.self) { number in
                    Text("\(number)巻").tag(Int16(number) as Int16)
                }
            }
        }
    }
}
