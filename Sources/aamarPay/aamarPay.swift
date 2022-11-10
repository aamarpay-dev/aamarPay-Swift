#if canImport(UIKit)

import UIKit

#endif
import WebKit
open class aamarPay: UIViewController {
   let webView = WKWebView()
    public static let screen = UIStoryboard(name: "aamarPay", bundle: Bundle.module).instantiateInitialViewController()!

    override open func viewDidLoad(){
        super.viewDidLoad()
        view?.addSubview(webView)
        
        guard let url = URL(string: "https://google.com") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override open func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    public func pay(){
        print("Payment hit")
    }
}
