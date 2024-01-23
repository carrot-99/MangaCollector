// AuthorsListView.swift

import SwiftUI

struct AuthorsListView: View {
    var manga: Manga
    var authors: [Author]
    @ObservedObject var viewModel: MangaListViewModel
    @State private var showingAddAuthorDialog = false
    @State private var showingEditAuthorDialog = false
    @State private var selectedAuthor: Author?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label("著者", systemImage: "person")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Button(action: {
                    showingAddAuthorDialog = true
                }) {
                    Image(systemName: "plus")
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(authors, id: \.self) { author in
                        HStack {
                            Text(author.name ?? "")
                            Button(action: {
                                selectedAuthor = author
                                showingEditAuthorDialog = true
                            }) {
                                Image(systemName: "pencil")
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2))
                        
                        if author != authors.last {
                            Text(" / ")
                        }
                    }
                }
            }
            .frame(minHeight: 50)
        }
        .padding()
        .halfSheet(isPresented: $showingAddAuthorDialog) {
            AddAuthorDialog(showingDialog: $showingAddAuthorDialog) { name in
                addAuthor(authorName: name)
            }
        }
        .halfSheet(isPresented: $showingEditAuthorDialog) {
            if let selectedAuthor = selectedAuthor {
                EditAuthorDialog(
                    showingDialog: $showingEditAuthorDialog,
                    author: .constant(selectedAuthor),
                    onEdit: { author, newName in
                        updateAuthor(author: author, newName: newName)
                    },
                    onDelete: { author in
                        deleteAuthor(author: author)
                    }
                )
            }
        }
    }
    
    private func addAuthor(authorName: String) {
        viewModel.addAuthor(to: manga, name: authorName)
        showingAddAuthorDialog = false
    }
    
    private func updateAuthor(author: Author, newName: String) {
        viewModel.updateAuthor(author: author, newName: newName)
        showingAddAuthorDialog = false
    }
    
    private func deleteAuthor(author: Author) {
        viewModel.deleteAuthor(author: author)
        showingAddAuthorDialog = false
    }
}
