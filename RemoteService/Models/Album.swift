import Foundation

public struct AlbumList: Decodable {
    public let albums: [Album]

    public struct Album: Decodable {
        public let artist: String
        public let title: String
        public let coverArtPath: String
        public let reviewPath: String

        enum CodingKeys: String, CodingKey {
            case artist = "artist"
            case title = "title"
            case coverArtPath = "coverArt"
            case reviewPath = "review"
        }
    }
}
