//  ContentView.swift

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel: MangaListViewModel
    @State private var isShowingTerms = true
    @AppStorage(UserDefaultsKey.hasAgreedToTerms) private var hasAgreedToTerms = false

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: MangaListViewModel(context: context))
    }

    var body: some View {
        if hasAgreedToTerms {
            ZStack(alignment: .bottom) {
                NavigationView {
                    MainView(viewModel: viewModel)
                }
                .navigationViewStyle(StackNavigationViewStyle())

//                AdMobBannerView()
//                    .frame(width: UIScreen.main.bounds.width, height: 40)
            }
        } else {
            TermsAndPrivacyAgreementView(isShowingTerms: $isShowingTerms, hasAgreedToTerms: $hasAgreedToTerms)
        }
    }
}
