import UIKit

class PitchforkNavigationBar: UINavigationBar {
    override func awakeFromNib() {
        self.topItem?.titleView = titleView()
    }
}

class titleView: UIView {
    let imageView: UIImageView = {
        let image = UIImage(assetIdentifier: .pitchforkTitle)
        var imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(imageView)
        NSLayoutConstraint.activate(imageViewConstraints())
    }
    
    private func imageViewConstraints() -> [NSLayoutConstraint] {
        let width = imageView.widthAnchor.constraint(equalToConstant: 100)
        let height = imageView.heightAnchor.constraint(equalToConstant: 30)
        let centerX = imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerY = imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        return [width, height, centerX, centerY]
    }
}
