//  PublisherView.swift

import SwiftUI

struct PublisherView: View {
    @Binding var publisher: String

    var body: some View {
        VStack(alignment: .leading) {
            Label("出版社", systemImage: "building.2")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)

            Picker("出版社", selection: $publisher) {
                ForEach(publishers, id: \.self) { publisher in
                    Text(publisher).tag(publisher)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2))
        }
        .padding()
    }
}
