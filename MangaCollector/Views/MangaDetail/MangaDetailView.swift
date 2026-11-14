//  MangaDetailView.swift

import SwiftUI

struct MangaDetailView: View {
    @ObservedObject var viewModel: MangaListViewModel
    @ObservedObject var manga: Manga
    @Environment(\.presentationMode) private var presentationMode

    @State private var title: String
    @State private var editingTitle = false
    @State private var ownedVolumes: Int
    @State private var publicationStatus: PublicationStatus
    @State private var notes: String
    @State private var isFavorite: Bool
    @State private var image: UIImage?
    @State private var imageChanged = false
    @State private var publisher: String
    @State private var missingVolumes: [Int]

    @State private var showingImagePicker = false
    @State private var showingMissingVolumesSelection = false
    @State private var showingDiscardConfirmation = false
    @State private var currentAlert: AlertType?

    init(manga: Manga, viewModel: MangaListViewModel) {
        self.manga = manga
        self.viewModel = viewModel
        _title = State(initialValue: manga.title ?? "")
        _ownedVolumes = State(initialValue: Int(manga.ownedVolumes))
        _publicationStatus = State(initialValue: manga.status)
        _notes = State(initialValue: manga.notes ?? "")
        _isFavorite = State(initialValue: manga.favorite)
        _image = State(initialValue: manga.image.flatMap(UIImage.init(data:)))
        _publisher = State(initialValue: manga.publisher ?? defaultPublisher)
        _missingVolumes = State(initialValue: manga.missingVolumeNumbers)
    }

    /// 最新巻以下の不足巻のみ（最新巻を減らした場合の不整合を防ぐ）
    private var validMissingVolumes: [Int] {
        missingVolumes.filter { $0 >= 1 && $0 <= ownedVolumes }
    }

    private var totalOwnedVolumes: Int {
        Manga.totalOwnedVolumes(latestVolume: ownedVolumes, missingVolumes: validMissingVolumes, otherTitles: manga.otherTitlesArray)
    }

    private var hasChanges: Bool {
        title != (manga.title ?? "")
            || ownedVolumes != Int(manga.ownedVolumes)
            || publicationStatus != manga.status
            || notes != (manga.notes ?? "")
            || isFavorite != manga.favorite
            || imageChanged
            || publisher != (manga.publisher ?? defaultPublisher)
            || validMissingVolumes != manga.missingVolumeNumbers
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && ownedVolumes >= 1
    }

    var body: some View {
        ScrollView {
            VStack {
                // タイトル、お気に入り
                HStack {
                    TitleView(title: $title, editingTitle: $editingTitle, currentAlert: $currentAlert)
                    Spacer()
                    FavoriteView(isFavorite: $isFavorite)
                }

                // 著者リスト
                AuthorsListView(manga: manga)

                // 連載状況、最新巻
                HStack(alignment: .top) {
                    PublicationStatusView(publicationStatus: $publicationStatus)
                    Spacer()
                    OwnedVolumesView(ownedVolumes: $ownedVolumes)
                }
                .padding()

                // 総所有巻数
                HStack {
                    Label("総所有巻数", systemImage: "sum")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(totalOwnedVolumes)巻")
                        .font(.headline)
                }
                .padding(.horizontal, 32)

                // 出版社
                PublisherView(publisher: $publisher)

                // 不足巻
                MissingVolumesView(missingVolumes: validMissingVolumes) {
                    showingMissingVolumesSelection = true
                }

                // 外伝など
                OtherTitlesListView(manga: manga, viewModel: viewModel)

                // 画像
                ImageView(image: $image, showingImagePicker: $showingImagePicker)

                // メモ
                MemoView(notes: $notes)
            }
            .padding()
        }
        .padding(.bottom, 50)
        .navigationBarTitle(title, displayMode: .inline)
        .navigationBarBackButtonHidden(hasChanges)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if hasChanges {
                    Button(action: { showingDiscardConfirmation = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("戻る")
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") { saveChanges() }
                    .font(.body.bold())
                    .disabled(!hasChanges || !canSave)
            }
        }
        .confirmationDialog("変更が保存されていません", isPresented: $showingDiscardConfirmation, titleVisibility: .visible) {
            Button("保存して戻る") {
                if saveChanges(showsAlert: false) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .disabled(!canSave)
            Button("変更を破棄", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
            Button("キャンセル", role: .cancel) {}
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $image)
        }
        .sheet(isPresented: $showingMissingVolumesSelection) {
            MissingVolumesSelectionView(
                ownedVolumes: ownedVolumes,
                selectedVolumes: $missingVolumes
            )
        }
        .onChange(of: image) { _ in
            imageChanged = true
        }
        .alert(item: $currentAlert) { alertType in
            switch alertType {
            case .saveSuccess:
                return Alert(title: Text("保存しました"))
            case .saveFailure:
                return Alert(title: Text("保存に失敗しました"))
            case .titleError:
                return Alert(
                    title: Text("エラー"),
                    message: Text("タイトルを入力してください。"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    @discardableResult
    private func saveChanges(showsAlert: Bool = true) -> Bool {
        guard canSave else {
            currentAlert = .titleError
            return false
        }
        let imageData = imageChanged ? image?.compressedJPEGData() : manga.image
        let draft = MangaDraft(
            title: title,
            authors: manga.authorsArray,
            ownedVolumes: ownedVolumes,
            publicationStatus: publicationStatus,
            notes: notes,
            favorite: isFavorite,
            image: imageData,
            publisher: publisher,
            missingVolumes: validMissingVolumes
        )
        let success = viewModel.updateManga(manga, with: draft)
        if success {
            editingTitle = false
            imageChanged = false
            title = manga.title ?? title
            missingVolumes = manga.missingVolumeNumbers
            if showsAlert {
                currentAlert = .saveSuccess
            }
        } else {
            currentAlert = .saveFailure
        }
        return success
    }
}
