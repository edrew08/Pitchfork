import UIKit
import WebKit
import RemoteService

class ReviewViewController: UIViewController {
    let service = RemoteService()
    var reviewPath: String!

    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        return webView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.color = UIColor.lightGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        return activityIndicator
    }()

    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRequest()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func loadRequest() {
        guard let request = service.urlRequest(for: reviewPath) else {
            return
        }

        activityIndicator.startAnimating()
        webView.load(request)
    }
}

extension ReviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        activityIndicator.stopAnimating()
    }
}
