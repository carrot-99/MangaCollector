//  OwnedVolumesView.swift

import SwiftUI

struct OwnedVolumesView: View {
    @Binding var ownedVolumes: Int
    @State private var ownedVolumesText: String // キーボード入力用

    init(ownedVolumes: Binding<Int>) {
        self._ownedVolumes = ownedVolumes
        self._ownedVolumesText = State(initialValue: "\(ownedVolumes.wrappedValue)")
    }

    var body: some View {
        VStack(alignment: .leading) {
            Label("最新巻", systemImage: "books.vertical")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            
            TextField("所持巻数", text: $ownedVolumesText)
                .keyboardType(.numberPad) // 数字専用キーボードを使用
                .onChange(of: ownedVolumesText) { newValue in
                    // 入力値をフィルタリングして数値のみ許可
                    ownedVolumesText = newValue.filter { $0.isNumber }
                    
                    // 有効な数値の場合のみ`ownedVolumes`に反映
                    if let validNumber = Int(ownedVolumesText), validNumber > 0 {
                        ownedVolumes = validNumber
                    }
                }
                .padding()
                .padding(.vertical, 7)
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2))
            
            if ownedVolumesText.isEmpty || (Int(ownedVolumesText) ?? 0) <= 0 {
                Text("巻数は1以上の自然数で入力してください")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}
