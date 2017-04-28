//
//  AFNRequestTool.swift
//  AFNTestOfSwift
//
//  Created by FCG on 2017/2/15.
//  Copyright © 2017年 FCG. All rights reserved.
//

import AFNetworking

/// 用来区分发送请求的方式   在swift中，枚举不但支持整形、还支持字符串类型等

/** 方式1
enum sengRequestType : Int {
    case GET    = 0
    case POST   = 1
}
*/
/** 方式3
enum sengRequestType : String {
    case GET    = "0"
    case POST   = "1"
}
*/

/// 方式3
enum sengRequestType {
    case GET
    case POST
}

class AFNRequestTool: AFHTTPSessionManager {
    
    
    static let shareInstance : AFNRequestTool = {
        
        let tools = AFNRequestTool()
        /// 配置请求的返回数据接收的类型
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
    
}

// MARK: --------   封装网络请求方式1  --------
extension AFNRequestTool {
    
    // 外界主要调用这个接口，用来发请求
    func sendRequest(requestType : sengRequestType, urlStringType: URLStringType, parameters : [String : Any], finished : @escaping (_ result : Any?, _ error : Error?) -> ()) {
        
        let urlString = AFNetRequestURLTool.shareInstance.getUrlString(urlStringType: urlStringType)
        startRequest(requestType: requestType, urlStr: urlString, parameters: parameters) { (result, error) in
            
            finished(result, error)
        }
    }
    
    // 图片上传方法
    func upLoadImageRequest(urlStringType: URLStringType, parameters : [String : Any], images : [UIImage?]?, finished : @escaping (_ result : Any?, _ error : Error?) -> ()) {
        
        let urlString = AFNetRequestURLTool.shareInstance.getUrlString(urlStringType: urlStringType)
        
        print("\n-----------------Request Begin-----------------------\n\n urlString == \(urlString)\n params == \n\(parameters)\n-----------------Request End-----------------------\n\n")
        
        post(urlString, parameters: parameters, constructingBodyWith: { (fmData) in
            
            var index = 0
            if images != nil {
                
                for image in images! {
                    
                    if image != nil, let imageData = UIImageJPEGRepresentation(image!, 0.5) {
                        
//                        let imageData = UIImageJPEGRepresentation(image!, 0.5)
                        fmData.appendPart(withFileData: imageData, name: "pic", fileName: "ganggege\(index).png", mimeType: "image/png")
                        index += 1
                    }
                }
            }
            
        }, progress: nil, success: { (task : URLSessionDataTask, result) in
            
            print("\n-----------------Response Begin(Success)-----------------------\n\n\(urlString)\n\(result)\n-----------------Response End(Success)-----------------------\n\n")
            finished(result, nil)
        }) { (task : URLSessionDataTask?, error) in
            print("\n-----------------Response Begin(Faild)-----------------------\n\n\(urlString)\n\(error)\n-----------------Response End(Faild)-----------------------\n\n")
            finished(nil, error)
        }
    }
    
    // 开发发请求
    func startRequest(requestType : sengRequestType, urlStr : String, parameters : [String : Any], finished : @escaping (_ result : Any?, _ error : Error?) -> ()) {
        
        print("\n-----------------Request Begin-----------------------\n\n urlString == \(urlStr)\n params == \n\(parameters)\n-----------------Request End-----------------------\n\n")
        
        // 按照下方注释的方式，重复代码太多，可进行简化
        
        // 1、定义成功的回调闭包
        let succeseCallBack = { (task : URLSessionDataTask, result : Any) in
            print("\n-----------------Response Begin(Success)-----------------------\n\n\(urlStr)\n\(result)\n-----------------Response End(Success)-----------------------\n\n")
            finished(result, nil)
        };
        
        // 2、定义失败的回调闭包
        let faildCallBack = { (task : URLSessionDataTask?, error : Error) in
            print("\n-----------------Response Begin(Faild)-----------------------\n\n\(urlStr)\n\(error)\n-----------------Response End(Faild)-----------------------\n\n")
            finished(nil, error)
        }
        
        // 3、发送请求
        if requestType == .GET {
            
            /// progress进度想要就打开这个闭包
            get(urlStr, parameters: parameters, progress: nil, success: succeseCallBack, failure: faildCallBack)
        } else {
            /// progress进度想要就打开这个闭包
            post(urlStr, parameters: parameters, progress: nil, success: succeseCallBack, failure: faildCallBack)
        }
        
        
        
        
        
        /*
        if requestType == .GET {
            
            /// progress进度想要就打开这个闭包
            get(urlStr, parameters: parameters, progress: nil, success: { (task : URLSessionDataTask, result : Any) in
                
                finished(result, nil)
            }, failure: { (task : URLSessionDataTask?, error : Error) in
                finished(nil, error)
            })
        } else {
            /// progress进度想要就打开这个闭包
            post(urlStr, parameters: parameters, progress: nil, success: { (task : URLSessionDataTask, result : Any) in
                finished(result, nil)
            }, failure: { (task : URLSessionDataTask?, error : Error) in
                finished(nil, error)
            })
        }
         */
    }
}

// MARK: --------   封装网络请求2  --------
extension AFNRequestTool {
    
    // MARK: --------   发送get请求  --------
    func sendGetRequest(urlStr : String, parameters : [String : Any], finished : @escaping (_ result : Any?, _ error : Error?) -> ()) {
        
        /// progress进度想要就打开这个闭包
        get(urlStr, parameters: parameters, progress: nil, success: { (task : URLSessionDataTask, result : Any) in
            finished(result, nil)
        }, failure: { (task : URLSessionDataTask?, error : Error) in
            finished(nil, error)
        })
    }
    
    // MARK: --------   发送Post请求  --------
    func sendPostRequest(urlStr : String, parameters : [String : Any], finished : @escaping (_ result : Any?, _ error : Error?) -> ()) {
        
        /// progress进度想要就打开这个闭包
        post(urlStr, parameters: parameters, progress: nil, success: { (task : URLSessionDataTask, result : Any) in
            finished(result, nil)
        }, failure: { (task : URLSessionDataTask?, error : Error) in
            finished(nil, error)
        })
    }
}
