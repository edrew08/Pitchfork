import Foundation

class AlbumsParser: Parser {
    static func decode(data: Data?) -> AlbumList? {
        guard let data = data else {
            return nil
        }
        
        return try? JSONDecoder().decode(AlbumList.self, from: data)
    }
}
