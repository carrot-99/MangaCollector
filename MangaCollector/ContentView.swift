//  ContentView.swift

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var viewModel: MangaListViewModel
    
    init(context: NSManagedObjectContext) {
        viewModel = MangaListViewModel(context: context)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                MangaListView(viewModel: viewModel)
            }
            
            AdMobBannerView()
                .frame(width: UIScreen.main.bounds.width, height: 40)
        }
    }
}
