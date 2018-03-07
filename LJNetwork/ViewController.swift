//
//  ViewController.swift
//  LJNetwork
//
//  Created by manajay on 2016/12/20.
//  Copyright © 2016年 manajay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let req = ApiDemoRequest();
        CommonClient().send(req, { (_, code, _, _) in
            toLog("code: \(code)")
        }) { (error) in
            toLog("error: \(error)")
        }
    }

}

