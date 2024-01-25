//  MangaDetailView.swift

import Foundation
import SwiftUI

struct MangaDetailView: View {
    @ObservedObject var viewModel: MangaListViewModel
    // Mnaga
    @State private var title: String
    @State private var editingTitle: Bool = false
    @State private var editingVolumes: Bool = false
    @State private var ownedVolumes: Int
    @State private var publicationStatus: PublicationStatus
    @State private var notes: String
    @State private var editingMemo: Bool = false
    @State private var isFavorite: Bool
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var publisher: String = ""
    // MissingVolume
    @State private var showingAddMissingVolumeDialog = false
    @State private var newMissingVolumeNumber: Int16 = 0
    @State private var showingEditMissingVolumeDialog = false
    @State private var editingVolume: MissingVolume?
    @State private var editedVolumeNumber: Int16 = 0
    // OtherTitle
    @State private var showingAddOtherTitleDialog = false
    @State private var newOtherTitleName: String = ""
    @State private var newOtherTitleOwnedVolumes: Int16 = 0
    @State private var newOtherTitleNotes: String = ""
    @State private var showingEditOtherTitleDialog = false
    @State private var editingOtherTitle: OtherTitle?
    @State private var editedOtherTitleName: String = ""
    @State private var editedOtherTitleOwnedVolumes: Int16 = 0
    @State private var editedOtherTitleNotes: String = ""

    @State private var currentAlert: AlertType?
    var manga: Manga

    init(manga: Manga, viewModel: MangaListViewModel) {
        self.manga = manga
        self.viewModel = viewModel
        _title = State(initialValue: manga.title ?? "")
        _ownedVolumes = State(initialValue: Int(manga.ownedVolumes))
        _publicationStatus = State(initialValue: PublicationStatus(rawValue: manga.publicationStatus) ?? .ongoing)
        _notes = State(initialValue: manga.notes ?? "")
        _isFavorite = State(initialValue: manga.favorite)

        if let imageData = manga.image {
            _image = State(initialValue: UIImage(data: imageData))
        } else {
            _image = State(initialValue: nil)
        }
        _publisher = State(initialValue: manga.publisher ?? "")
    }

    var body: some View {
        ScrollView {
            VStack {
                // タイトル、お気に入り
                HStack {
                    TitleView(title: $title, editingTitle: $editingTitle, onSave: { editingTitle = false }, currentAlert: $currentAlert)
                    Spacer()
                    FavoriteView(isFavorite: $isFavorite)
                }
//                .padding(.bottom, 10)
                
                // 著者リスト
                AuthorsListView(manga: manga, authors: Array(manga.authors as? Set<Author> ?? []), viewModel: viewModel, currentAlert: $currentAlert)
                    .frame(height: 100)
                
                // 画像
                ImageView(image: $image, showingImagePicker: $showingImagePicker)
                
                // 連載状況、最新巻
                HStack {
                    PublicationStatusView(publicationStatus: $publicationStatus)
                    Spacer()
                    OwnedVolumesView(ownedVolumes: $ownedVolumes)
                }
                .padding()
                
                // 出版社
                PublisherView(publisher: $publisher)
                
                // 不足巻数リスト
                MissingVolumesListView(manga: manga, newMissingVolumeNumber: $newMissingVolumeNumber, editingVolume: $editingVolume, editedVolumeNumber: $editedVolumeNumber, viewModel: viewModel, ownedVolumes: $ownedVolumes, currentAlert: $currentAlert)
                
                // 外伝などリスト
                OtherTitlesListView(manga: manga, viewModel: viewModel, newOtherTitleName: $newOtherTitleName, newOtherTitleOwnedVolumes: $newOtherTitleOwnedVolumes, newOtherTitleNotes: $newOtherTitleNotes, editingOtherTitle: $editingOtherTitle, editedOtherTitleName: $editedOtherTitleName, editedOtherTitleOwnedVolumes: $editedOtherTitleOwnedVolumes, editedOtherTitleNotes: $editedOtherTitleNotes)
                
                // メモ
                MemoView(notes: $notes)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $image)
            }
            .navigationBarTitle("\(title)", displayMode: .inline)
            .navigationBarItems(trailing: Button("保存") {
                saveChanges()
            })
            .padding()
        }
        .padding(.bottom, 50)
        .alert(item: $currentAlert) { alertType in
            switch alertType {
            case .saveSuccess:
                return Alert(title: Text("保存しました"))
            case .saveFailure:
                return Alert(title: Text("保存に失敗しました"))
            case .duplicateVolume:
                return Alert(
                    title: Text("エラー"),
                    message: Text("同じ巻数が既に存在します。"),
                    dismissButton: .default(Text("OK"))
                )
            case .titleError:
                return Alert(
                    title: Text("エラー"),
                    message: Text("タイトルを入力してください。"),
                    dismissButton: .default(Text("OK"))
                )
            case .authorNameError:
                return Alert(
                    title: Text("エラー"),
                    message: Text("著者名を入力してください。"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func calculatedOwnedVolumes() -> Int {
        let missingVolumeCount = (manga.missingVolumes as? Set<MissingVolume>)?.count ?? 0
        let otherTitlesOwnedVolumesTotal = manga.otherTitlesArray.reduce(0) { total, otherTitle in
            total + Int(otherTitle.ownedVolumes)
        }
        let total = ownedVolumes + otherTitlesOwnedVolumesTotal - missingVolumeCount
        return max(total, 0)
    }

    private func saveChanges() {
        let imageData = image?.jpegData(compressionQuality: 1.0)
        let totalOwnedVolumes = calculatedOwnedVolumes()
        let updateSuccessful = viewModel.updateManga(
            manga,
            title: title,
            ownedVolumes: Int16(ownedVolumes),
            publicationStatus: publicationStatus.rawValue,
            notes: notes,
            favorite: isFavorite,
            image: imageData,
            publisher: publisher,
            totalOwnedVolumes: Int16(totalOwnedVolumes)
        )
        currentAlert = updateSuccessful ? .saveSuccess : .saveFailure
    }
}
