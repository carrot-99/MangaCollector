//  AddMangaDialog.swift

import SwiftUI

struct AddMangaDialog: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: MangaListViewModel

    @State private var title: String = ""
    @State private var authorName: String = ""
    @State private var publicationStatus: PublicationStatus = .ongoing
    @State private var ownedVolumes: Int = 0
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("タイトル", text: $title)
                    TextField("著者", text: $authorName)
                    
                    Picker("連載状況", selection: $publicationStatus) {
                        ForEach(PublicationStatus.allCases) { status in
                            Text(status.description).tag(status)
                        }
                    }
                    
                    Stepper("最新巻: \(ownedVolumes)", value: $ownedVolumes, in: 1...300)
                }
                
                Section(header: Text("画像")) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Text("画像を選択")
                        }
                    }
                }
            }
            .navigationBarTitle("漫画を追加", displayMode: .inline)
            .navigationBarItems(
                leading: Button("キャンセル") { isPresented = false },
                trailing: Button("追加") { addManga() }
            )
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private func addManga() {
        let imageData = selectedImage?.jpegData(compressionQuality: 1.0)
        viewModel.addManga(
            title: title,
            authorName: authorName,
            publicationStatus: publicationStatus.rawValue,
            ownedVolumes: Int16(ownedVolumes),
            image: imageData
        )
        isPresented = false
    }
    
    private func loadImage() {
        guard let selectedImage = selectedImage else { return }
        self.selectedImage = selectedImage
    }
}
