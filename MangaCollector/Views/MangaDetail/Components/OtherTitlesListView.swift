//  OtherTitlesListView.swift

import SwiftUI

struct OtherTitlesListView: View {
    var manga: Manga
    @State var showingAddOtherTitleDialog: Bool = false
    @State var showingEditOtherTitleDialog: Bool = false
    @ObservedObject var viewModel: MangaListViewModel
    @Binding var newOtherTitleName: String
    @Binding var newOtherTitleOwnedVolumes: Int16
    @Binding var newOtherTitleNotes: String
    @Binding var editingOtherTitle: OtherTitle?
    @Binding var editedOtherTitleName: String
    @Binding var editedOtherTitleOwnedVolumes: Int16
    @Binding var editedOtherTitleNotes: String
    
    var body: some View {
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
                onSave: updateOtherTitle,
                onDelete: deleteOtherTitle
            )
        }
    }
    
    private func addOtherTitle() {
        viewModel.addOtherTitle(to: manga, title: newOtherTitleName, ownedVolumes: newOtherTitleOwnedVolumes, notes: newOtherTitleNotes)
        newOtherTitleName = ""
        newOtherTitleOwnedVolumes = 1
        newOtherTitleNotes = ""
        showingAddOtherTitleDialog = false
    }

    private func updateOtherTitle() {
        guard let editingOtherTitle = editingOtherTitle else { return }
        viewModel.updateOtherTitle(
            manga: manga,
            otherTitle: editingOtherTitle,
            newTitle: editedOtherTitleName,
            newOwnedVolumes: editedOtherTitleOwnedVolumes,
            newNotes: editedOtherTitleNotes
        )
        self.editingOtherTitle = nil
        self.showingEditOtherTitleDialog = false
    }
    
    private func deleteOtherTitle() {
        if let otherTitle = editingOtherTitle {
            viewModel.deleteOtherTitle(manga: manga, otherTitle: otherTitle)
        }
        self.editingOtherTitle = nil
        self.showingEditOtherTitleDialog = false
    }
}
