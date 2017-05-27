import UIKit
import RemoteService

class AlbumDataSource: NSObject, UICollectionViewDataSource {
    let albumList: AlbumList
    var commands = [IndexPath: Command]()
    var coverArt = [String: UIImage]()
    let service: Service

    init(albumList: AlbumList, service: Service) {
        self.albumList = albumList
        self.service = service
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .albumCell, for: indexPath) as! AlbumCollectionViewCell
        let album = albumList.albums[indexPath.row]

        if let image = coverArt[album.coverArtPath] {
            cell.primaryImage = image
        } else {
            let command = service.getCoverArt(for: album.coverArtPath) { [weak self] image in
                self?.coverArt[album.coverArtPath] = image
                DispatchQueue.main.async {
                    collectionView.reloadItems(at: [indexPath])
                }
            }
            command.execute()
        }
        return cell
    }
}

extension AlbumDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let coverArtPath = albumList.albums[indexPath.row].coverArtPath
            if coverArt[coverArtPath] == nil {
                let command = service.getCoverArt(for: coverArtPath, completion: { [weak self] image in
                    self?.coverArt[coverArtPath] = image
                })
                commands[indexPath] = command
                command.execute()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            commands[$0]?.cancel()
            commands[$0] = nil
        }
    }
}
