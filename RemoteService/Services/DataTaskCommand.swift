import Foundation

public protocol Command {
    func execute()
    func cancel()
}

class DataTaskCommand: Command {
    let dataTask: URLSessionDataTask

    init(dataTask: URLSessionDataTask) {
        self.dataTask = dataTask
    }

    func execute() {
        dataTask.resume()
    }

    func cancel() {
        dataTask.cancel()
    }
}
