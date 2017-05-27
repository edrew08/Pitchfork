import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    var primaryImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    override func prepareForReuse() {
        primaryImage = nil
    }
}
