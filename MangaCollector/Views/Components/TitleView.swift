//  TitleView.swift

import SwiftUI

struct TitleView: View {
    @Binding var title: String
    @Binding var editingTitle: Bool
    var onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            if editingTitle {
                // MARK: - 編集モード
                Label("タイトル（編集中）", systemImage: "book.closed")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 1)
                
                HStack {
                    TextField("タイトル", text: $title)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        onSave()
                        editingTitle = false
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 10)
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2))
            } else {
                // MARK: - 表示モード
                Label("タイトル", systemImage: "book.closed")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 1)
                
                HStack {
                    Text(title)
                        .font(.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        editingTitle = true
                    }) {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 10)
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2))
            }
        }
        .padding(.horizontal)
    }
}
