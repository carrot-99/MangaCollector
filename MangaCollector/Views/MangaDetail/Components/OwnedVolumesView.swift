//  OwnedVolumesView.swift

import SwiftUI

struct OwnedVolumesView: View {
    @Binding var ownedVolumes: Int
    @State private var ownedVolumesText: String // キーボード入力用

    init(ownedVolumes: Binding<Int>) {
        self._ownedVolumes = ownedVolumes
        self._ownedVolumesText = State(initialValue: "\(ownedVolumes.wrappedValue)")
    }

    private var isInputValid: Bool {
        (Int(ownedVolumesText) ?? 0) > 0
    }

    var body: some View {
        VStack(alignment: .leading) {
            Label("最新巻", systemImage: "books.vertical")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)

            HStack(spacing: 4) {
                TextField("所持巻数", text: $ownedVolumesText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 40)
                    .onChange(of: ownedVolumesText) { newValue in
                        let filtered = String(newValue.filter(\.isNumber).prefix(4))
                        if filtered != newValue {
                            ownedVolumesText = filtered
                        }
                        if let number = Int(filtered), number > 0 {
                            ownedVolumes = number
                        }
                    }

                // 新刊購入時にすぐ増やせるよう ± ボタンを用意
                Stepper("最新巻", value: Binding(
                    get: { ownedVolumes },
                    set: { ownedVolumes = $0 }
                ), in: 1...9999)
                .labelsHidden()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(isInputValid ? Color.blue : Color.red, lineWidth: 2))
            .onChange(of: ownedVolumes) { newValue in
                if Int(ownedVolumesText) != newValue {
                    ownedVolumesText = "\(newValue)"
                }
            }

            if !isInputValid {
                Text("1以上の数字を入力してください")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}
