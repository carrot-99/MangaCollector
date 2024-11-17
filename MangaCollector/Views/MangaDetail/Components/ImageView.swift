//  ImageView.swift

import SwiftUI

struct ImageView: View {
    @Binding var image: UIImage?
    @Binding var showingImagePicker: Bool
    @State private var showingActionSheet = false

    var body: some View {
        Button(action: {
            showingImagePicker = true
        }) {
            Text("画像を変更")
                .foregroundColor(.blue)
                .underline()
                .padding()
        }
        if let image = image {
            // 画像が設定されている場合のみ表示
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
//                .padding()
        }
//        VStack(alignment: .leading) {
//            HStack {
//                Label("画像", systemImage: "photo")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                
//                Button(action: {
//                    showingActionSheet = true
//                }) {
//                    Image(systemName: "pencil")
//                }
//                .actionSheet(isPresented: $showingActionSheet) {
//                    ActionSheet(
//                        title: Text("画像の編集"),
//                        buttons: [
//                            .default(Text("変更")) { showingImagePicker = true },
//                            .destructive(Text("削除")) { image = nil },
//                            .cancel()
//                        ]
//                    )
//                }
//            }
//            .padding(.bottom, 1)
//            
//            HStack {
//                if let uiImage = self.image {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
//                        .cornerRadius(10)
//                        .shadow(radius: 5)
//                } else {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
//                        .cornerRadius(10)
//                }
//            }
//            .padding()
//            .frame(maxWidth: .infinity, minHeight: 50)
//            .background(RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.blue, lineWidth: 2))
//        }
//        .padding()
    }
}
