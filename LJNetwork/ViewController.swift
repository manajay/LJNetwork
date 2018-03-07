//
//  ViewController.swift
//  LJNetwork
//
//  Created by manajay on 2016/12/20.
//  Copyright © 2016年 manajay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var responseLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendReq() {
        self.responseLbl.text = "发起请求"
        let req = ApiDemoRequest();
        CommonClient().send(req, { (_, code, _, _) in
            toLog("code: \(code)")
            self.responseLbl.text = "结束请求, 结果\(code)"
        }) { (error) in
            toLog("error: \(error)")
        }
    }

}

