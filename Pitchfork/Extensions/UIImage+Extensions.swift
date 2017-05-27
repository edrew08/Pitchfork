import UIKit

extension UIImage {
    enum AssetIdentifier: String {
        case pitchforkTitle = "pitchfork_title"
    }

    convenience init(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)!
    }
}
