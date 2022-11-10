#if canImport(UIKit)

import UIKit

#endif
import WebKit
public class aamarPay: UIViewController {
   let webView = WKWebView()
   
    override public func viewDidLoad(){
        super.viewDidLoad()
        view?.addSubview(webView)
        
        guard let url = URL(string: "https://google.com") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override public func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}
