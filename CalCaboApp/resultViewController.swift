//
//  resultViewController.swift
//  CalCaboApp
//
//  Created by yamanaka on 2018/02/13.
//  Copyright © 2018年 yamanaka. All rights reserved.
//

import UIKit

class resultViewController: UIViewController {
    
    
    
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var caboLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var avgCalLabel: UILabel!
    @IBOutlet weak var avgCaboLabel: UILabel!
    
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        calLabel.text = appDelegate.resultCal
        caboLabel.text = appDelegate.resultCabo
        let avgCal = Int(calLabel.text!)! / 7
        let avgCabo = Int(caboLabel.text!)! / 7
        avgCalLabel.text = String(avgCal)
        avgCaboLabel.text = String(avgCabo)
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
