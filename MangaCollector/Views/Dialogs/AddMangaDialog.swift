//  AddMangaDialog.swift

import Foundation
import SwiftUI

struct AddMangaDialog: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: MangaListViewModel
    @State private var title: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("新規漫画タイトル")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 1)
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 5)
            }
            .padding(.horizontal)
            .navigationBarTitle("新しい漫画を追加", displayMode: .inline)
            .navigationBarItems(
                leading: Button("閉じる") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("追加") {
                    viewModel.addManga(title: title)
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
