//  MissingVolumesSelectionView.swift

import SwiftUI

/// 巻番号をタップして不足巻を選択するシート
struct MissingVolumesSelectionView: View {
    let ownedVolumes: Int
    @Binding var selectedVolumes: [Int]
    @Environment(\.dismiss) private var dismiss
    @State private var selection: Set<Int>

    private let columns = [GridItem(.adaptive(minimum: 56), spacing: 8)]

    init(ownedVolumes: Int, selectedVolumes: Binding<[Int]>) {
        self.ownedVolumes = ownedVolumes
        self._selectedVolumes = selectedVolumes
        self._selection = State(initialValue: Set(selectedVolumes.wrappedValue.filter { $0 >= 1 && $0 <= ownedVolumes }))
    }

    var body: some View {
        NavigationView {
            Group {
                if ownedVolumes < 1 {
                    EmptyStateView(
                        systemImage: "books.vertical",
                        title: "最新巻が設定されていません",
                        message: "先に最新巻を1以上に設定してください"
                    )
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("持っていない巻をタップしてください")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(1...ownedVolumes, id: \.self) { volume in
                                    volumeButton(volume)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle(selection.isEmpty ? "不足巻を選択" : "不足巻：\(selection.count)冊", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完了") {
                        selectedVolumes = selection.sorted()
                        dismiss()
                    }
                    .font(.body.bold())
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("選択をすべて解除", role: .destructive) {
                        selection.removeAll()
                    }
                    .disabled(selection.isEmpty)
                }
            }
        }
    }

    private func volumeButton(_ volume: Int) -> some View {
        let isSelected = selection.contains(volume)
        return Button {
            if isSelected {
                selection.remove(volume)
            } else {
                selection.insert(volume)
            }
        } label: {
            Text("\(volume)")
                .font(.body.monospacedDigit())
                .frame(maxWidth: .infinity, minHeight: 44)
                .foregroundColor(isSelected ? .white : .primary)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.orange : Color.secondary.opacity(0.12))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(volume)巻")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
