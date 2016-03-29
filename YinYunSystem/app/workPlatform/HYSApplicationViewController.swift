//
//  HYSApplicationViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/1/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class HYSApplicationViewController: UIViewController {
    
    
    @IBOutlet weak var conferenceRoom: UITextField!
    
    var selectRoom: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        conferenceRoom.text = ""

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        conferenceRoom.text = selectRoom
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
