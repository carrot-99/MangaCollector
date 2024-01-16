//  TransparentModalBackground.swift

import Foundation
import SwiftUI

struct TransparentModalBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.clear)
            .edgesIgnoringSafeArea(.all)
    }
}
