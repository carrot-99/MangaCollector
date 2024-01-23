//  TermsAndPrivacyAgreementView.swift

import SwiftUI
import AppTrackingTransparency

struct TermsAndPrivacyAgreementView: View {
    @Binding var isShowingTerms: Bool
    @Binding var hasAgreedToTerms: Bool
    @State private var isShowingTermsView = false
    @State private var isShowingPrivacyPolicyView = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 20)
                    Text("本アプリでは、お客様の体験を向上させるために広告を表示します。詳細については、以下の利用規約とプライバシーポリシーをご確認ください。")
                        .font(.subheadline)
                        .padding(.horizontal)

                    HStack {
                        Spacer()
                        
                        Button("利用規約") {
                            isShowingTermsView = true
                        }
                        .sheet(isPresented: $isShowingTermsView) {
                            TermsView()
                        }

                        Spacer()

                        Button("プライバシーポリシー") {
                            isShowingPrivacyPolicyView = true
                        }
                        .sheet(isPresented: $isShowingPrivacyPolicyView) {
                            PrivacyPolicyView()
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }

            // 同意するボタン
            Button("NEXT") {
                UserDefaults.standard.set(true, forKey: "hasAgreedToTerms")
                self.hasAgreedToTerms = true
                self.isShowingTerms = false
                requestTrackingPermission()
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    func requestTrackingPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // トラッキング許可された
                print("Tracking authorized by the user")
            case .denied:
                // トラッキング拒否された
                print("Tracking denied by the user")
            case .notDetermined:
                // トラッキング許可がまだ求められていない
                print("Tracking permission not determined")
            case .restricted:
                // トラッキングが制限されている
                print("Tracking restricted")
            @unknown default:
                // 新しい未知の状態が将来追加されるかもしれない
                print("Unknown status")
            }
        }
    }
}
