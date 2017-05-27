import UIKit

extension UICollectionView {
    enum CellIdentifier: String {
        case albumCell = "AlbumCollectionViewCell"
    }

    func register(nib: UINib?, forCellIdentifier identifier: CellIdentifier) {
        register(nib, forCellWithReuseIdentifier: identifier.rawValue)
    }

    func dequeueReusableCell(withReuseIdentifier identifier: CellIdentifier, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: identifier.rawValue, for: indexPath)
    }
}
