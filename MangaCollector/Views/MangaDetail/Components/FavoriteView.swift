//  FavoriteView.swift

import SwiftUI

struct FavoriteView: View {
    @Binding var isFavorite: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Label("お気に入り", systemImage: "star")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)

            Button(action: {
                isFavorite.toggle()
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
            }
            .frame(maxWidth: 80, minHeight: 50)
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2))
        }
        .padding(.trailing)
    }
}
