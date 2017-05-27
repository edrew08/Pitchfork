import UIKit

class ImageParser: Parser {
    static func decode(data: Data?) -> UIImage? {
        guard let data = data else {
            return nil
        }

        return UIImage(data: data)
    }
}
