//
//  numberViewController.swift
//  CalCaboApp
//
//  Created by yamanaka on 2018/01/24.
//  Copyright © 2018年 yamanaka. All rights reserved.
//

import UIKit

class numberViewController: UIViewController {
    
    @IBOutlet weak var inputVal: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var okKey: UIButton!
    @IBOutlet weak var backSpaceKey: UIButton!
    @IBOutlet weak var key0: UIButton!
    @IBOutlet weak var key1: UIButton!
    @IBOutlet weak var key2: UIButton!
    @IBOutlet weak var key3: UIButton!
    @IBOutlet weak var key4: UIButton!
    @IBOutlet weak var key5: UIButton!
    @IBOutlet weak var key6: UIButton!
    @IBOutlet weak var key7: UIButton!
    @IBOutlet weak var key8: UIButton!
    @IBOutlet weak var key9: UIButton!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var calcVal: String! = ""
    var numLength: Int!
    
    @IBAction func actOkKey(_ sender: UIButton) {
        if calcVal == "" {
            let alertTargetCalc = UIAlertController(title: nil, message: "目標値を入力してください" , preferredStyle: .alert)
            let actOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertTargetCalc.addAction(actOk)
            self.present(alertTargetCalc, animated: true, completion: nil)
            
        }else{
            switch appDelegate.selectRow {
            case 0:
                appDelegate.targetCalVal = Int(calcVal)!
            case 1:
                appDelegate.targetCaboVal = Int(calcVal)!
            default:
                print("設定画面のテーブルindexにエラー",appDelegate.selectRow)
                
            }
            func comeHome (segue: UIStoryboardSegue) {
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func actBSK(_ sender: UIButton) {
        if calcVal.count != 0 {
            let bSVal = calcVal.prefix(calcVal.count - 1)
            calcVal = String(bSVal)
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey0(_ sender: UIButton) {
        if calcVal.count >= 1 && calcVal.count <= numLength {
            calcVal.append("0")
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey1(_ sender: UIButton) {
        if calcVal.count <= numLength {
            calcVal.append("1")
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey2(_ sender: UIButton) {
        if calcVal.count <= numLength {
            calcVal.append("2")
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey3(_ sender: UIButton) {
        if calcVal.count <= numLength {
            calcVal.append("3")
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey4(_ sender: UIButton) {
        if calcVal.count <= numLength {
            calcVal.append("4")
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey5(_ sender: UIButton) {
        if calcVal.count <= numLength {
            calcVal.append("5")
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey6(_ sender: UIButton) {
        if calcVal.count <= numLength {
            calcVal.append("6")
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey7(_ sender: UIButton) {
        if calcVal.count <= numLength {
            calcVal.append("7")
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey8(_ sender: UIButton) {
        if calcVal.count <= numLength {
            calcVal.append("8")
            inputVal.text = calcVal
        }
    }
    @IBAction func actKey9(_ sender: UIButton) {
        if calcVal.count <= numLength {
            calcVal.append("9")
            inputVal.text = calcVal
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タブバー非表示
        super.tabBarController?.tabBar.isHidden = true
        switch appDelegate.selectRow {
        case 0:
            unitLabel.text = "kcal"
            if appDelegate.targetCalVal != nil{
                calcVal = String(appDelegate.targetCalVal)
            }
            numLength = 3
        case 1:
            unitLabel.text = "g"
            if appDelegate.targetCaboVal != nil{
                calcVal = String(appDelegate.targetCaboVal)
            }
            numLength = 2
        default:
            unitLabel.text = ""
        }
        if calcVal == "0" {
            calcVal = ""
            inputVal.text = ""
        }else{
            inputVal.text = calcVal
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NBImage.png"), for: .topAttached, barMetrics: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
