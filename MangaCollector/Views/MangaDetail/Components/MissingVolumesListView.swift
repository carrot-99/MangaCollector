//  MissingVolumesListView.swift

import SwiftUI

struct MissingVolumesListView: View {
    var manga: Manga
    @State var showingAddMissingVolumeDialog: Bool = false
    @State var showingEditMissingVolumeDialog: Bool = false
    @Binding var newMissingVolumeNumber: Int16
    @Binding private var editingVolume: MissingVolume?
    @Binding var editedVolumeNumber: Int16
    @ObservedObject var viewModel: MangaListViewModel
    @Binding var ownedVolumes: Int
    
    init(
        manga: Manga,
        newMissingVolumeNumber: Binding<Int16>,
        editingVolume: Binding<MissingVolume?>,
        editedVolumeNumber: Binding<Int16>,
        viewModel: MangaListViewModel,
        ownedVolumes: Binding<Int>)
    {
        self.manga = manga
        self._newMissingVolumeNumber = newMissingVolumeNumber
        self._editingVolume = editingVolume
        self._editedVolumeNumber = editedVolumeNumber
        self.viewModel = viewModel
        self._ownedVolumes = ownedVolumes
    }

    var body: some View {
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
                onSave: updateMissingVolume,
                onDelete: deleteMissingVolume
            )
        }
    }
    
    private func addMissingVolume() {
        viewModel.addMissingVolume(to: manga, volumeNumber: newMissingVolumeNumber)
        newMissingVolumeNumber = 0
        showingAddMissingVolumeDialog = false
    }
    
    private func updateMissingVolume() {
        viewModel.updateMissingVolume(
            manga: manga,
            volume: editingVolume!,
            newVolumeNumber: editedVolumeNumber
        )
        showingEditMissingVolumeDialog = false
    }
    
    private func deleteMissingVolume() {
        if let volume = editingVolume {
            viewModel.deleteMissingVolume(manga: manga, volume: volume)
        }
        showingEditMissingVolumeDialog = false
    }
}
