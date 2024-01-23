//  SettingsView.swift

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: TermsView()) {
                    Text("利用規約")
                }

                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("プライバシーポリシー")
                }
            }
        }
        .navigationBarTitle("設定", displayMode: .inline)
    }
}
