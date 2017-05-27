import UIKit
import RemoteService

class TopAlbumsViewController: UIViewController, SegueHandler {
    var dataSource: AlbumDataSource!
    let service = RemoteService()

    enum SegueIdentifier: String {
        case reviewSegue = "reviewSegue"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .reviewSegue:
            if let destinationViewController = segue.destination as? UINavigationController,
                let reviewViewController = destinationViewController.topViewController as? ReviewViewController,
                let indexPath = sender as? IndexPath {
                reviewViewController.reviewPath = dataSource.albumList.albums[indexPath.row].reviewPath
            }
        }
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.backgroundColor = UIColor.black
            let albumCellNib = UINib(nibName: "AlbumCollectionViewCell", bundle: nil)
            collectionView.register(nib: albumCellNib, forCellIdentifier: .albumCell)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
        service.getAlbumList { [weak self] albumList in
            let dataSource = AlbumDataSource(albumList: albumList, service: RemoteService())
            self?.collectionView.dataSource = dataSource
            self?.collectionView.prefetchDataSource = dataSource
            self?.dataSource = dataSource
            self?.collectionView.reloadData()
        }
    }
}

extension TopAlbumsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: .reviewSegue, sender: indexPath)
    }
}
