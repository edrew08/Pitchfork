import UIKit

class TopAlbumsLayout: UICollectionViewLayout {
    fileprivate let rowHeight: CGFloat = 300
    fileprivate let borderInset: CGFloat = 12
    fileprivate let numberOfItemsInRow = 3
    fileprivate let horizontalDistributionRatio: CGFloat = 0.57

    lazy var dynamicAnimator: UIDynamicAnimator = {
        return UIDynamicAnimator(collectionViewLayout: self)
    }()

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        updateDynamicAnimatorItems(forBoundsChange: newBounds)
        return false
    }

    override func prepare() {
        guard dynamicAnimator.behaviors.isEmpty else {
            return
        }

        let contentSize = self.contentSize
        let rect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        let layoutAttributes: [UICollectionViewLayoutAttributes] = indexPathsOfItems(in: rect).flatMap { indexPath in
            let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttribute.frame = frame(at: indexPath)
            return layoutAttribute
        }

        for item in layoutAttributes {
            let springBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
            springBehavior.damping = 0
            springBehavior.frequency = 1
            dynamicAnimator.addBehavior(springBehavior)

            let resistanceBehavior = UIDynamicItemBehavior(items: [item])
            resistanceBehavior.resistance = 5
            dynamicAnimator.addBehavior(resistanceBehavior)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return dynamicAnimator.items(in: rect).map { $0 as! UICollectionViewLayoutAttributes }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return dynamicAnimator.layoutAttributesForCell(at: indexPath)
    }
}

extension TopAlbumsLayout {
    fileprivate var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }

    var contentSize: CGSize {
        var height = ceil(CGFloat(numberOfItems) / CGFloat(numberOfItemsInRow)) * rowHeight
        height = height - borderInset
        let width = collectionView?.bounds.width ?? 0
        if numberOfItems % (numberOfItemsInRow * 2) == 4 {
            height = height - (rowHeight - (rowHeight * horizontalDistributionRatio))
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: width, height: height)
        }
    }

    func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        let itemsInRect = Int(ceil(rect.height / rowHeight) * CGFloat(numberOfItemsInRow))
        let startingItemIndex = Int(floor(rect.minY / rowHeight) * CGFloat(numberOfItemsInRow)).clamp(min: 0, max: numberOfItems)
        let endingItemIndex = min(numberOfItems, startingItemIndex + itemsInRect)
        let indexPaths = (startingItemIndex..<endingItemIndex).map { IndexPath(item: $0, section: 0) }
        return indexPaths
    }
}

extension TopAlbumsLayout {
    func updateDynamicAnimatorItems(forBoundsChange newBounds: CGRect) {
        guard let scrollView = collectionView,
            let touchLocation = collectionView?.panGestureRecognizer.location(in: collectionView) else {
                return
        }

        let delta = newBounds.origin.y - scrollView.bounds.origin.y

        for behavior in dynamicAnimator.behaviors {
            guard let attachmentBehavior = behavior as? UIAttachmentBehavior,
                let item = attachmentBehavior.items.first else {
                    continue
            }

            let yDistance = abs(touchLocation.y - attachmentBehavior.anchorPoint.y)
            let xDistance = abs(touchLocation.x - attachmentBehavior.anchorPoint.x)
            let resitance: CGFloat = (xDistance + yDistance) / 1500
            var center = item.center
            center.y += delta < 0 ? max(delta, delta * resitance) : min(delta, delta * resitance)
            item.center = center
            dynamicAnimator.updateItem(usingCurrentState: item)
        }
    }
}

extension TopAlbumsLayout {
    func frame(at indexPath: IndexPath) -> CGRect {
        let rowIndex = Int(floor(CGFloat(indexPath.item) / CGFloat(numberOfItemsInRow)))

        switch indexPath.row % (numberOfItemsInRow * 2) {
        case 0:
            return primary(rowIndex, flipHorizontal: false)
        case 1:
            return secondary(rowIndex, flipHorizontal: false)
        case 2:
            return tertiary(rowIndex, flipHorizontal: false)
        case 3:
            return secondary(rowIndex, flipHorizontal: true)
        case 4:
            return tertiary(rowIndex, flipHorizontal: true)
        case 5:
            return primary(rowIndex, flipHorizontal: true)
        default:
            fatalError("no frame for item at indexPath: \(indexPath)")
        }
    }

    func primary(_ rowIndex: Int, flipHorizontal: Bool) -> CGRect {
        var xPosition: CGFloat = 0
        var width = horizontalDistributionRatio * contentSize.width
        let yPosition = CGFloat(rowIndex) * rowHeight
        let height = rowHeight - borderInset

        if flipHorizontal {
            xPosition = contentSize.width - width + borderInset
            width = width - borderInset
        }

        return CGRect(x: xPosition, y: yPosition, width: width, height: height)
    }

    func secondary(_ rowIndex: Int, flipHorizontal: Bool) -> CGRect {
        let leftColumnWidth = horizontalDistributionRatio * contentSize.width
        var xPosition = leftColumnWidth + borderInset
        let width = contentSize.width - leftColumnWidth
        let yPosition = CGFloat(rowIndex) * rowHeight
        let height = (rowHeight * horizontalDistributionRatio) - borderInset

        if flipHorizontal {
            xPosition = 0
        }

        return CGRect(x: xPosition, y: yPosition, width: width, height: height)
    }

    func tertiary(_ rowIndex: Int, flipHorizontal: Bool) -> CGRect {
        let leftColumnWidth = horizontalDistributionRatio * contentSize.width
        var xPosition = leftColumnWidth + borderInset
        let width = contentSize.width - leftColumnWidth
        let yPosition = (CGFloat(rowIndex) * rowHeight) + (rowHeight * horizontalDistributionRatio)
        let height = rowHeight - (rowHeight * horizontalDistributionRatio) - borderInset

        if flipHorizontal {
            xPosition = 0
        }

        return CGRect(x: xPosition, y: yPosition, width: width, height: height)
    }
}

extension Comparable {
    func clamp(min minValue: Self, max maxValue: Self) -> Self {
        var result = max(minValue, self)
        result = min(maxValue, result)
        return result
    }
}
