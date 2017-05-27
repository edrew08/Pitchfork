import Foundation

public protocol Service {
    func getCoverArt(for path: String, completion: @escaping (UIImage) -> ()) -> Command
    func getAlbumList(_ completion: @escaping (AlbumList) -> ())
    func urlRequest(for review: String) -> URLRequest?
}

public class RemoteService: Service {
    let webService = WebService(host: "cdn.albumoftheyear.org")

    public init() { }

    public func urlRequest(for reviewPath: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "pitchfork.com"
        urlComponents.path = "/reviews/albums\(reviewPath)"
        guard let url = urlComponents.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }

    public func getAlbumList(_ completion: @escaping (AlbumList) -> ()) {
        //This should be a real network call, but I'm not gonna host this JSON
        let url = URL(fileURLWithPath: Bundle(for: type(of: self)).path(forResource: "Albums", ofType: "json")!)
        let data = try! Data(contentsOf: url, options: [])
        if let albums = AlbumsParser.decode(data: data) {
            completion(albums)
        }
    }

    public func getCoverArt(for path: String, completion: @escaping (UIImage) -> ()) -> Command {
        let dataTask = webService.dataTask(path: "/album\(path)") { remoteResource in
            if let image = ImageParser.decode(data: remoteResource.data) {
                completion(image)
            }
        }
        return DataTaskCommand(dataTask: dataTask)
    }
}
