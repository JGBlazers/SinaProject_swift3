//
//  ShowPopoverVC.swift
//  SinaProject
//
//  Created by FCG on 2017/2/13.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ShowPopoverVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

// MARK: --------   表的数据源和代理方法  --------
extension ShowPopoverVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID : String = "CELL"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        
        return cell!
    }

}
