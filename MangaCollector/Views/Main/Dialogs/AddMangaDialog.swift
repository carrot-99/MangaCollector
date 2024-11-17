//  AddMangaDialog.swift

import SwiftUI

struct AddMangaDialog: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: MangaListViewModel

    @State private var title: String = ""
    @State private var publicationStatus: PublicationStatus = .ongoing
    @State private var ownedVolumesText: String = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showTitleError = false
    
    // 巻数有効チェック
    private var isOwnedVolumesValid: Bool {
        if let volumes = Int(ownedVolumesText), volumes > 0 {
            return true
        }
        return false
    }
    
    // 追加ボタン有効チェック
    private var isAddButtonDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !isOwnedVolumesValid
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("タイトル*", text: $title)
                        .onChange(of: title) { newValue in
                            if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                showTitleError = false
                            }
                        }
                    
                    if showTitleError {
                        Text("タイトルを入力してください")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Picker("連載状況", selection: $publicationStatus) {
                        ForEach(PublicationStatus.allCases) { status in
                            Text(status.description).tag(status)
                        }
                    }
                    
                    TextField("巻数*", text: $ownedVolumesText)
                        .keyboardType(.numberPad) // 数字専用キーボードを指定
                        .onChange(of: ownedVolumesText) { newValue in
                            // 数値のみを許可する制御
                            ownedVolumesText = newValue.filter { $0.isNumber }
                        }
                    
                    if !isOwnedVolumesValid && !ownedVolumesText.isEmpty {
                        Text("巻数は1以上の自然数で入力してください")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
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
                    .disabled(isAddButtonDisabled)
            )
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private func addManga() {
        let ownedVolumes = Int16(ownedVolumesText) ?? 1
        let imageData = selectedImage?.jpegData(compressionQuality: 1.0)
        viewModel.addManga(
            title: title,
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
