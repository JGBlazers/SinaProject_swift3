//
//  MessageViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/1/14.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgAlertView.setBgAlertViewInfo(imageName: "visitordiscover_image_message", alertTitle: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
