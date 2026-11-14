// AuthorsListView.swift

import SwiftUI

struct AuthorsListView: View {
    @ObservedObject var manga: Manga
    @State private var newAuthorName: String = ""
    @State private var isEditing: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label("著者", systemImage: "person")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: toggleEditing) {
                    Image(systemName: isEditing ? "checkmark" : "pencil")
                }
            }

            if isEditing {
                // 著者名を追加
                HStack {
                    TextField("新しい著者名", text: $newAuthorName)
                        .submitLabel(.done)
                        .onSubmit(addAuthor)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addAuthor) {
                        Image(systemName: "plus")
                            .padding(5)
                            .background(Circle().fill(Color.blue))
                            .foregroundColor(.white)
                    }
                }

                // 著者名を編集
                ForEach(Array(manga.authorsArray.enumerated()), id: \.offset) { index, author in
                    HStack {
                        TextField("著者名を編集", text: Binding(
                            get: { author },
                            set: { manga.authorsArray[index] = $0 }
                        ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: { deleteAuthor(at: index) }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            } else {
                // 通常表示
                Text(manga.authorsArray.isEmpty ? "未登録" : manga.authorsText)
                    .font(.body)
                    .foregroundColor(manga.authorsArray.isEmpty ? .gray : .primary)
                    .lineLimit(2)
            }
        }
        .padding()
    }

    /// 編集完了時に、入力途中の名前の追加・空欄の削除をして保存する
    private func toggleEditing() {
        if isEditing {
            if !newAuthorName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                addAuthor()
            }
            let cleaned = manga.authorsArray
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            if cleaned != manga.authorsArray {
                manga.authorsArray = cleaned
            }
            saveContext()
        }
        isEditing.toggle()
    }

    private func addAuthor() {
        let name = newAuthorName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        manga.authorsArray.append(name)
        newAuthorName = ""
        saveContext()
    }

    private func deleteAuthor(at index: Int) {
        manga.authorsArray.remove(at: index)
        saveContext()
    }

    private func saveContext() {
        do {
            try manga.managedObjectContext?.save()
        } catch {
            print("Error saving authors: \(error.localizedDescription)")
        }
    }
}
