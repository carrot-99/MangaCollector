//  ImageView.swift

import SwiftUI

struct ImageView: View {
    @Binding var image: UIImage?
    @Binding var showingImagePicker: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label("画像", systemImage: "photo")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Button(image == nil ? "画像を選択" : "変更") {
                    showingImagePicker = true
                }
                .font(.caption)
                if image != nil {
                    Button("削除", role: .destructive) {
                        image = nil
                    }
                    .font(.caption)
                    .padding(.leading, 8)
                }
            }
            .padding(.bottom, 1)

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture { showingImagePicker = true }
            } else {
                Button(action: { showingImagePicker = true }) {
                    VStack(spacing: 6) {
                        Image(systemName: "photo.badge.plus")
                            .font(.title)
                        Text("タップして表紙画像を追加")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, dash: [6])))
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}
