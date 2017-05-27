import Foundation

struct RemoteResource {
    let statusCode: Int?
    let data: Data?

    var isStatusCodeValid: Bool {
        guard let statusCode = statusCode else {
            return false
        }
        return statusCode >= 200 && statusCode < 300
    }
}
