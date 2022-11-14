#if canImport(UIKit)

import UIKit

#endif
import WebKit
open class aamarPay: UIViewController {
    let isSandbox:Bool
    let storeId:String
    var successUrl:String
    var failUrl:String
    var cancelUrl:String
    let signatureKey:String
    let transactionId:String
    var amount:String
    let customerName:String
    let customerEmail:String
    let customerNumber:String
    let desc:String
    private var paymentCompletation: ((String) -> Void)?
    private var webView : WKWebView?
    public required init(nibName nibNameOrNil: String?=nil, bundle nibBundleOrNil: Bundle?=nil, isSandbox:Bool = true,storeId:String, successUrl:String,failUrl:String,cancelUrl:String, signatureKey:String,transactionId:String,amount:String,customerName:String = "Unknown",customerEmail:String = "nomail@mail.com",description:String = "N/A", customerNumber:String ) {
        self.isSandbox = isSandbox
        self.storeId = storeId
        self.successUrl = successUrl
        self.failUrl = failUrl
        self.cancelUrl = cancelUrl
        self.signatureKey = signatureKey
        self.transactionId = transactionId
        self.amount = amount
        self.customerName = customerName
        self.customerEmail = customerEmail
        self.customerNumber = customerNumber
        self.desc = description
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    public required init?( coder: NSCoder){
        self.isSandbox = false
        self.storeId = ""
        self.successUrl = ""
        self.failUrl = ""
        self.cancelUrl = ""
        self.signatureKey = ""
        self.transactionId = ""
        self.amount = ""
        self.customerName = ""
        self.customerEmail = ""
        self.customerNumber = ""
        self.desc = ""
        super.init(coder: coder)
    }
    
    override open func viewDidLoad(){
        super.viewDidLoad()
        view?.addSubview(webView!)
        guard let url = URL(string: paymentUrl) else {
            return
        }
        webView!.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        webView!.load(URLRequest(url: url))
        
    }
    
    
    override open func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        webView!.frame = view.bounds
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            if(webView!.url!.absoluteString.contains(successUrl)||webView!.url!.absoluteString.contains(cancelUrl)||webView!.url!.absoluteString.contains(failUrl)){
                paymentCompletation!("Done")
                
                print("current url \(webView!.url?.absoluteString)")
               
            }
           }
       
    }
    public func pay(parent:UIViewController,completion: @escaping (String) -> Void){
      self.parsePaymentLink { Void in
          DispatchQueue.main.async {
              let mainstoryboard:UIStoryboard = UIStoryboard(name: "amarPay", bundle: nil)
              let paymentController = mainstoryboard.instantiateViewController(withIdentifier: "amarPay") as! aamarPay
              paymentController.paymentUrl = self.paymentUrl
              paymentController.successUrl = self.successUrl
              paymentController.failUrl = self.failUrl
              paymentController.cancelUrl = self.cancelUrl
              paymentController.webView = WKWebView()
              let paymentFrontController = UINavigationController.init(rootViewController: paymentController)
              paymentController.paymentCompletation = completion
              parent.present(paymentFrontController, animated: true, completion: nil)
          }
        }
    }
   private let _sandBoxUrl = "https://sandbox.aamarpay.com";
   private let _productionUrl = "https://secure.aamarpay.com";
   private var paymentUrl = ""
    
    func parsePaymentLink( completion: @escaping (String) -> Void) {
     let payLoad = [
         "store_id": "\(self.storeId)",
         "tran_id": self.transactionId,
         "success_url": self.successUrl,
         "fail_url": self.failUrl,
         "cancel_url": self.cancelUrl,
         "amount": self.amount,
         "currency": "BDT",
         "signature_key": self.signatureKey,
         "desc": self.desc,
         "cus_name": self.customerName,
         "cus_email": self.customerEmail,
         "cus_add1":  "Dhaka",
         "cus_add2": "Dhaka",
         "cus_city": "Dhaka",
         "cus_state": "Dhaka",
         "cus_postcode": "12",
         "cus_country": "Bangladesh",
         "cus_phone": self.customerNumber,
         "type": "json"
       ]
     var request = URLRequest(url: URL(string: "\(self.isSandbox ? self._sandBoxUrl : self._productionUrl)/index.php")!)
         request.httpMethod = "POST"
         request.httpBody = payLoad.percentEncoded()

              URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
                  do {
                      let jsonDecoder = JSONDecoder()
                      let responseModel = String(decoding: data!, as: UTF8.self)
                      let test  = responseModel.convertToDictionary()
                      self.paymentUrl = test!["payment_url"] as! String
                      print("Api call done \(self.paymentUrl) ")
                      completion("Success")
                  } catch {
                      completion("Failed")
                  }
              }).resume()
    }
}

extension Dictionary {
  func percentEncoded() -> Data? {
    return map { key, value in
      let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
      let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
      return escapedKey + "=" + escapedValue
    }
    .joined(separator: "&")
    .data(using: .utf8)
  }
}

extension CharacterSet {
  static let urlQueryValueAllowed: CharacterSet = {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="

    var allowed = CharacterSet.urlQueryAllowed
    allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
    return allowed
  }()
}
