//  SettingsView.swift

import SwiftUI

struct SettingsView: View {
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        return "\(version) (\(build))"
    }

    var body: some View {
        List {
            Section {
                NavigationLink(destination: TermsView()) {
                    Label("利用規約", systemImage: "doc.text")
                }
                NavigationLink(destination: PrivacyPolicyView()) {
                    Label("プライバシーポリシー", systemImage: "hand.raised")
                }
            }

            Section {
                HStack {
                    Label("バージョン", systemImage: "info.circle")
                    Spacer()
                    Text(appVersion)
                        .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitle("設定", displayMode: .inline)
    }
}
