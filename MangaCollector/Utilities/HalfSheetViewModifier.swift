//  HalfSheetViewModifier.swift

import SwiftUI

struct HalfSheetViewModifier<SheetView: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetView: SheetView

    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isPresented {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isPresented = false
                                }
                            }

                        VStack {
//                            Spacer()
                            sheetView
                                .transition(.move(edge: .bottom))
                                .edgesIgnoringSafeArea(.bottom)
                        }
                    }
                }
            )
            .animation(.easeInOut)
    }
}

extension View {
    func halfSheet<SheetView: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder sheetView: @escaping () -> SheetView
    ) -> some View {
        self.modifier(HalfSheetViewModifier(isPresented: isPresented, sheetView: sheetView()))
    }
}
