//
//  ViewController.swift
//  LJNetwork
//
//  Created by manajay on 2016/12/20.
//  Copyright © 2016年 manajay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var expressList: UITableView!
    var express: Express?
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sendReq()
    }
    
    private func setupUI(){
        expressList.register(ExpressCell.self, forCellReuseIdentifier: "ExpressCell")
    }
}

extension ViewController {
    
    fileprivate func sendReq() {
        let req = ApiDemoRequest(type: Kuaidi.yuantong, postid: "887787795079291153");
        Client.share.send(req) {[weak self] (message) in
            switch message {
            case .Failure(let error):
                    toLog("error: \(error)")
            case .Sucess(let express, let status):
                    toLog("code: \(status?.code ?? 0), express: \(express.debugDescription)")
                    self?.express = express
                    self?.expressList.reloadData()
            }
        }
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return express?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expressCell = tableView.dequeueReusableCell(withIdentifier: "ExpressCell", for: indexPath) as! ExpressCell
        if indexPath.row < express!.data.count {
            let node = express?.data[indexPath.row]
            expressCell.nodeLbl.text = node?.context
            expressCell.nodeLbl.frame = CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: expressCell.bounds.size.height)
        }
        return expressCell
    }
}

extension ViewController : UITableViewDelegate {
}
