//  MissingVolumesView.swift

import SwiftUI

/// 不足巻の表示セクション
struct MissingVolumesView: View {
    let missingVolumes: [Int]
    var onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label("不足巻", systemImage: "exclamationmark.circle")
                    .font(.caption)
                    .foregroundColor(.gray)
                if !missingVolumes.isEmpty {
                    Text("\(missingVolumes.count)冊")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                }
                .accessibilityLabel("不足巻を編集")
            }
            .padding(.bottom, 1)

            Button(action: onEdit) {
                HStack {
                    if missingVolumes.isEmpty {
                        Text("なし（すべて揃っています）")
                            .foregroundColor(.gray)
                    } else {
                        Text(missingVolumes.volumeRangesDescription)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2))
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}
