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
    
    @State private var showAlert = false
    @State private var saveSuccessful = false
    var manga: Manga

    init(manga: Manga, viewModel: MangaListViewModel) {
        self.manga = manga
        self.viewModel = viewModel
        _title = State(initialValue: manga.title ?? "")
        _ownedVolumes = State(initialValue: Int(manga.ownedVolumes))
        _publicationStatus = State(initialValue: PublicationStatus(rawValue: manga.publicationStatus) ?? .ongoing)
        _notes = State(initialValue: manga.notes ?? "")
    }

    var body: some View {
        ScrollView {
            VStack {
                // タイトル
                TitleView(
                    title: $title,
                    editingTitle: $editingTitle,
                    onSave: {
                        viewModel.updateManga(
                            manga,
                            title: title,
                            ownedVolumes: Int16(ownedVolumes),
                            publicationStatus: publicationStatus.rawValue,
                            notes: notes
                        )
                        editingTitle = false
                    }
                )
                
                // 連載状況、最新巻
                HStack {
                    PublicationStatusView(publicationStatus: $publicationStatus)
                    Spacer()
                    OwnedVolumesView(ownedVolumes: $ownedVolumes)
                }
                .padding()
                
                // 不足巻数リスト
                ListSectionView(
                    title: "不足巻数",
                    items: manga.missingVolumesArray,
                    onAdd: {
                        showingAddMissingVolumeDialog = true
                    },
                    onEdit: { volume in
                        self.editingVolume = volume
                        self.editedVolumeNumber = volume.volumeNumber
                        self.showingEditMissingVolumeDialog = true
                    }
                )
                .halfSheet(isPresented: $showingAddMissingVolumeDialog) {
                    AddMissingVolumeDialog(
                        showingDialog: $showingAddMissingVolumeDialog,
                        newVolumeNumber: $newMissingVolumeNumber,
                        maxVolumeNumber: Int16(ownedVolumes),
                        onAdd: addMissingVolume
                    )
                }
                .halfSheet(isPresented: $showingEditMissingVolumeDialog) {
                    EditMissingVolumeDialog(
                        showingDialog: $showingEditMissingVolumeDialog,
                        editedVolumeNumber: $editedVolumeNumber, 
                        maxVolumeNumber: Int16(ownedVolumes),
                        onSave: {
                            viewModel.updateMissingVolume(
                                manga: manga,
                                volume: editingVolume!,
                                newVolumeNumber: editedVolumeNumber
                            )
                            self.editingVolume = nil
                            self.showingEditMissingVolumeDialog = false
                        },
                        onDelete: {
                            if let volume = editingVolume {
                                viewModel.deleteMissingVolume(manga: manga, volume: volume)
                            }
                            self.editingVolume = nil
                            self.showingEditMissingVolumeDialog = false
                        }
                    )
                }
                
                // 外伝などリスト
                ListSectionView(
                    title: "外伝など",
                    items: manga.otherTitlesArray,
                    onAdd: {
                        showingAddOtherTitleDialog = true
                    },
                    onEdit: { otherTitle in
                        self.editingOtherTitle = otherTitle
                        self.editedOtherTitleName = otherTitle.title ?? ""
                        self.editedOtherTitleOwnedVolumes = otherTitle.ownedVolumes
                        self.editedOtherTitleNotes = otherTitle.notes ?? ""
                        self.showingEditOtherTitleDialog = true
                    }
                )
                .halfSheet(isPresented: $showingAddOtherTitleDialog) {
                    AddOtherTitleDialog(
                        showingDialog: $showingAddOtherTitleDialog,
                        newOtherTitleName: $newOtherTitleName,
                        newOtherTitleOwnedVolumes: $newOtherTitleOwnedVolumes,
                        onAdd: addOtherTitle
                    )
                }
                .halfSheet(isPresented: $showingEditOtherTitleDialog) {
                    EditOtherTitleDialog(
                        showingDialog: $showingEditOtherTitleDialog,
                        editedOtherTitleName: $editedOtherTitleName,
                        editedOtherTitleOwnedVolumes: $editedOtherTitleOwnedVolumes,
                        onSave: {
                            viewModel.updateOtherTitle(
                                manga: manga,
                                otherTitle: editingOtherTitle!,
                                newTitle: editedOtherTitleName,
                                newOwnedVolumes: editedOtherTitleOwnedVolumes,
                                newNotes: editedOtherTitleNotes
                            )
                            self.editingOtherTitle = nil
                            self.showingEditOtherTitleDialog = false
                        },
                        onDelete: {
                            if let otherTitle = editingOtherTitle {
                                viewModel.deleteOtherTitle(manga: manga, otherTitle: otherTitle)
                            }
                            self.editingOtherTitle = nil
                            self.showingEditOtherTitleDialog = false
                        }
                    )
                }
                
                // メモ
                VStack(alignment: .leading) {
                    HStack {
                        Label("メモ", systemImage: "note.text")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()

                        Button(action: {
                            editingMemo.toggle()
                        }) {
                            Image(systemName: editingMemo ? "checkmark.circle" : "pencil.circle")
                        }
                    }
                    .padding(.bottom, 1)
                    
                    if editingMemo {
                        TextEditor(text: $notes)
                            .frame(minHeight: 200)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2))
                    } else {
                        Text(notes)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2))
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("保存") {
                saveChanges()
            })
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text(saveSuccessful ? "保存しました" : "保存に失敗しました"))
            }
            .alert(isPresented: $viewModel.duplicateVolumeAlert) {
                Alert(
                    title: Text("エラー"),
                    message: Text("同じ巻数が既に存在します。"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding(.bottom, 50)
        .background(Color.black)
    }
    
    private func calculatedOwnedVolumes() -> Int {
        let missingVolumeCount = (manga.missingVolumes as? Set<MissingVolume>)?.count ?? 0
        let otherTitlesOwnedVolumesTotal = manga.otherTitlesArray.reduce(0) { total, otherTitle in
            total + Int(otherTitle.ownedVolumes)
        }
        let total = ownedVolumes + otherTitlesOwnedVolumesTotal - missingVolumeCount
        return total > 0 ? total : 0
    }
    
    // 不足巻数の追加ボタンのアクション
    private func addMissingVolume() {
        viewModel.addMissingVolume(to: manga, volumeNumber: newMissingVolumeNumber)
        newMissingVolumeNumber = 0
        showingAddMissingVolumeDialog = false
    }
    
    // 外伝などの追加ボタンのアクション
    private func addOtherTitle() {
        viewModel.addOtherTitle(to: manga, title: newOtherTitleName, ownedVolumes: newOtherTitleOwnedVolumes, notes: newOtherTitleNotes)
        newOtherTitleName = ""
        newOtherTitleOwnedVolumes = 0
        newOtherTitleNotes = ""
        showingAddOtherTitleDialog = false
    }
    
    // 外伝などの更新ボタンのアクション
    private func updateOtherTitle() {
        guard let editingOtherTitle = editingOtherTitle else { return }
        viewModel.updateOtherTitle(manga: manga, otherTitle: editingOtherTitle, newTitle: editedOtherTitleName, newOwnedVolumes: editedOtherTitleOwnedVolumes, newNotes: editedOtherTitleNotes)
        self.editingOtherTitle = nil
    }

    // coreDataへの保存
    private func saveChanges() {
        manga.updateTotalOwnedVolumes()
        viewModel.updateManga(manga, title: title, ownedVolumes: Int16(ownedVolumes), publicationStatus: publicationStatus.rawValue, notes: notes)
        saveSuccessful = true
        showAlert = true
    }
}
