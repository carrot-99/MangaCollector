//  MemoView.swift

import SwiftUI

struct MemoView: View {
    @Binding var notes: String
    @State var editingMemo: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label("メモ", systemImage: "note.text")
                    .font(.caption)
                    .foregroundColor(.gray)

                Button(action: {
                    editingMemo.toggle()
                }) {
                    Image(systemName: editingMemo ? "checkmark" : "pencil")
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
            }
        }
        .padding()
    }
}
