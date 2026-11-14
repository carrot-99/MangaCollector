//  OtherTitlesListView.swift

import SwiftUI

struct OtherTitlesListView: View {
    @ObservedObject var manga: Manga
    @ObservedObject var viewModel: MangaListViewModel

    @State private var showingAddOtherTitleDialog = false
    @State private var showingEditOtherTitleDialog = false
    @State private var newOtherTitleName = ""
    @State private var newOtherTitleOwnedVolumes: Int16 = 1
    @State private var editingOtherTitle: OtherTitle?
    @State private var editedOtherTitleName = ""
    @State private var editedOtherTitleOwnedVolumes: Int16 = 1

    var body: some View {
        ListSectionView(
            title: "外伝など",
            items: manga.otherTitlesArray,
            onAdd: {
                newOtherTitleName = ""
                newOtherTitleOwnedVolumes = 1
                showingAddOtherTitleDialog = true
            },
            onEdit: { otherTitle in
                editingOtherTitle = otherTitle
                editedOtherTitleName = otherTitle.title ?? ""
                editedOtherTitleOwnedVolumes = max(otherTitle.ownedVolumes, 1)
                showingEditOtherTitleDialog = true
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
        let name = newOtherTitleName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        viewModel.addOtherTitle(to: manga, title: name, ownedVolumes: newOtherTitleOwnedVolumes, notes: "")
        showingAddOtherTitleDialog = false
    }

    private func updateOtherTitle() {
        let name = editedOtherTitleName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let otherTitle = editingOtherTitle, !name.isEmpty else { return }
        viewModel.updateOtherTitle(otherTitle, title: name, ownedVolumes: editedOtherTitleOwnedVolumes, notes: otherTitle.notes ?? "")
        editingOtherTitle = nil
        showingEditOtherTitleDialog = false
    }

    private func deleteOtherTitle() {
        if let otherTitle = editingOtherTitle {
            viewModel.deleteOtherTitle(otherTitle)
        }
        editingOtherTitle = nil
        showingEditOtherTitleDialog = false
    }
}
