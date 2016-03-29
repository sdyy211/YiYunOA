import Foundation
//总地址
//let GetService = "http://172.16.8.109/Login/JDoLogin"
let GetService = "http://172.16.8.250:8085"
//let GetService = "http://172.16.8.109"
//普通网络请求协议
@objc protocol HttpProtocol{
    func didResponse(result:NSDictionary)
    optional func didResponseByNSData(result:NSData)
}

class HttpRequest: NSObject {
    var delegate:HttpProtocol?
    
      //MARK:尚未完成封装
    enum HttpRequestErrorType:ErrorType {
        case 服务器没有响应
    }
    
    //MARK:get网络请求
    func Get(url:String,parameters:[String:NSObject]) {
        //let par = ["a":"b"]
      request(.GET, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            guard let _ = response.response else{
                return
            }
            if(response.result.value != nil)
            {
                self.delegate?.didResponse(response.result.value as! NSDictionary)
            }
        }
    }
    
    //记录cookie
    func Post1(url:String, str: String){

        
        request(.POST, url, parameters: [:], encoding: ParameterEncoding.Custom({ (convertible, params) -> (NSMutableURLRequest, NSError?) in
            
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
            return (mutableRequest, nil)
        }), headers: nil).responseJSON { (response) -> Void in
            guard let _ = response.response else{
                return
            }
            
            let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(response.response?.allHeaderFields as! [String: String], forURL: (response.response?.URL)!)
            print(cookies)
            Manager.sharedInstance.session.configuration.HTTPCookieStorage?.setCookies(cookies, forURL: response.response?.URL, mainDocumentURL: nil)
            
            self.delegate?.didResponse(response.result.value as! NSDictionary)
        }
    }
    func Post(url:String, str: String) {
        
        //        request(.POST, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
        //            guard let _ = response.response else{
        //                return
        //            }
        //            self.delegate?.didResponse(response.result.value as! NSDictionary)
        //        }
        //        print(str)
        
        request(.POST, url, parameters: [:], encoding: ParameterEncoding.Custom({ (convertible, params) -> (NSMutableURLRequest, NSError?) in
            
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
            return (mutableRequest, nil)
        }), headers: nil).responseJSON { (response) -> Void in
            guard let _ = response.response else{
                return
            }
            if(response.result.value != nil)
            {
                self.delegate?.didResponse(response.result.value as! NSDictionary)
            }
            
        }
    }

    func Post2(url:String, str: String) throws {

        
        request(.POST, url, parameters: [:], encoding: ParameterEncoding.Custom({ (convertible, params) -> (NSMutableURLRequest, NSError?) in
            
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
//            print(str.dataUsingEncoding(NSUTF8StringEncoding))
            return (mutableRequest, nil)
        }), headers: nil).responseJSON { (response) -> Void in
                
                guard var _ = response.result.value else {

                    return
                }
            
            self.delegate?.didResponse(response.result.value as! NSDictionary)
        }
    }
    
    
    func getResponseByNSData(method:Method,url:String,parameters:[String:NSObject]){
        request(method, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            guard let _ = response.data else{
                return
            }
        self.delegate?.didResponseByNSData!(response.data!)
        }
    }
    
  


}