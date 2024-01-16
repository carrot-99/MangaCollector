//  OwnedVolumesView.swift

import SwiftUI

struct OwnedVolumesView: View {
    @Binding var ownedVolumes: Int

    var body: some View {
        VStack(alignment: .leading) {
            Label("最新巻", systemImage: "books.vertical")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            
            Picker("所持巻数", selection: $ownedVolumes) {
                ForEach(0..<300) { volume in
                    Text("\(volume)巻").tag(volume)
                }
            }
            .padding()
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2))
        }
    }
}
