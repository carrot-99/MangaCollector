//  OtherTitle.swift

import Foundation

extension OtherTitle {
    public override var description: String {
        return "\(title ?? "Unknown Title") - \(ownedVolumes)巻"
    }
}
