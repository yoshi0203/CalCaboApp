//
//  inputScreen.swift
//  CalCaboApp
//
//  Created by yamanaka on 2018/01/12.
//  Copyright © 2018年 yamanaka. All rights reserved.
//

import Foundation
import UIKit

class inputScreen: UIViewController {
    
    @IBOutlet weak var chkBox : UIButton!
    
    @IBAction func tapChkBox(_ sender: UIButton){
        print("ok")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
