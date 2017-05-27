import Foundation

protocol Parser {
    associatedtype Object
    static func decode(data: Data?) -> Object
}
