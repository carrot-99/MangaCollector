//  ContentView.swift

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var viewModel: MangaListViewModel
    @State private var isShowingTerms = true
    @State private var hasAgreedToTerms = UserDefaults.standard.bool(forKey: "hasAgreedToTerms")
    
    init(context: NSManagedObjectContext) {
        viewModel = MangaListViewModel(context: context)
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
