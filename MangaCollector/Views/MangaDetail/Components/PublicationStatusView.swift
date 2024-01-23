//  PublicationStatusView.swift

import SwiftUI

struct PublicationStatusView: View {
    @Binding var publicationStatus: PublicationStatus

    var body: some View {
        VStack(alignment: .leading) {
            Label("連載状況", systemImage: "book.circle")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            
            Picker("連載状況", selection: $publicationStatus) {
                ForEach(PublicationStatus.allCases) { status in
                    Text(status.description).tag(status)
                }
            }
            .padding()
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2))
        }
    }
}
