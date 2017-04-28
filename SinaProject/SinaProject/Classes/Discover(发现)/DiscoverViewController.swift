//
//  DiscoverViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/1/14.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        bgAlertView.setBgAlertViewInfo(imageName: "visitordiscover_image_message", alertTitle: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }

}
