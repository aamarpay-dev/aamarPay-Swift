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
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)

        
    }
    
    
    override open func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
         webView.observe(\.url, options: .new, changeHandler: {
                (currentWebView, _) in
                //      Here you go the new path
            print("current url \(currentWebView.url)")
            })
    }
    
   
    
    public func pay(){
        print("current hit \(webView.url)")
    }
}
