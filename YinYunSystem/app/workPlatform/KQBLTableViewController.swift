//
//  KQBLTableViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/16.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQBLTableViewController: UITableViewController {
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!

    var httpRequest: HttpRequest!
    var bLArray: [KQBL]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.color = UIColor.blueColor()
        spinner.startAnimating()
        
        bLArray = [KQBL]()
        
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        
        
        let bodyStr = "page=1&rows=1000"
        do {
            
            try httpRequest.Post2(GetService + "/KaoQinMask/JBuLuList", str: bodyStr)
        } catch {
            
        }

    }

}

private typealias TableViewDataSource = KQBLTableViewController

extension TableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bLArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KQBLCell", forIndexPath: indexPath) as! KQBLTableViewCell
        cell.startTimeLabel.text = bLArray[indexPath.row].startTime
        
        cell.stateLabel.text = bLArray[indexPath.row].state
        
        cell.reasonLabel.text = bLArray[indexPath.row].content
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
}

private typealias Segues = KQBLTableViewController

extension Segues {
    
    @IBAction func unwindToBL(segue: UIStoryboardSegue) {
        if let _ = segue.sourceViewController as? KQNewBLTableViewController {
            let bodyStr = "page=1&rows=1000"
            do {
                try httpRequest.Post2(GetService + "/KaoQinMask/JBuLuList", str: bodyStr)
            } catch {
                
            }
        }
    }
}

private typealias Https = KQBLTableViewController

extension Https: HttpProtocol {
    
    func didResponse(result: NSDictionary) {
        
        bLArray.removeAll()
        
        if let data = result["rows"] {
            let json = JSON(data)
            
            for val in json {
                var bL = KQBL()
                bL.startTime = val.1["KQ_StartTime"].string!
                
                bL.content = val.1["KQ_Content"].string!
                bL.state = val.1["KQ_State"].string!
                bLArray.append(bL)
            }
            spinner.stopAnimating()
            self.tableView.reloadData()
            
        }
    }
}

