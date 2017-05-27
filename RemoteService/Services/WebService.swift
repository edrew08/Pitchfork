import Foundation

class WebService {
    let host: String
    let session = URLSession(configuration: .default)

    init(host: String) {
        self.host = host
    }

    func urlComponents(forPath path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.path = path
        return components
    }

    func remoteResource(data: Data?, response: URLResponse?, error: Error?) -> RemoteResource {
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        return RemoteResource(statusCode: statusCode, data: data)
    }

    func dataTask(path: String, completion: @escaping (RemoteResource) -> Void) -> URLSessionDataTask {
        guard let url = urlComponents(forPath: path).url else {
            fatalError("Could not form URL for path: \(path)")
        }

        let urlRequest = URLRequest(url: url)

        let dataTask = session.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            guard let remoteResource = self?.remoteResource(data: data, response: response, error: error) else {
                completion(RemoteResource(statusCode: nil, data: nil))
                return
            }

            completion(remoteResource)
        })

        return dataTask
    }
}
