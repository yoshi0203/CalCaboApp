//
//  configViewController.swift
//  CalCaboApp
//
//  Created by yamanaka on 2018/01/17.
//  Copyright © 2018年 yamanaka. All rights reserved.
//

import UIKit

class configViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var dayRstBtn: UIButton!
    @IBOutlet weak var weekRstBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let confUserDefaults = UserDefaults.standard
    let valList = ["カロリー(kcal)" , "糖質(g)"]
    
    var tapCellRow: Int!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "confCell", for: indexPath)
        let cellData = valList[(indexPath as NSIndexPath).row]
        var targetData :Int!
        
        switch indexPath.row {
        case 0:
            targetData = confUserDefaults.integer(forKey: "cal")
        case 1:
            targetData = confUserDefaults.integer(forKey: "cabo")
        default:
            targetData = 0
        }
        cell.textLabel?.text = cellData
        cell.detailTextLabel?.text = String(targetData)
        return cell
    }
    
    //セクションタイトル設定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "1日の目標値設定"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Makinas-Scrap-5", size: 20)
    }
    
    @IBAction func actDayRstBtn(_ sender: UIButton) {
        let alertWeekRst = UIAlertController(title: nil, message: "今日のカロリーと糖質の値を削除しますよろしいですか？", preferredStyle: .alert)
        let actOk = UIAlertAction(title: "OK",style: .default,handler:{(action) -> Void in
            self.appDelegate.dayRstFlg = true
            self.tabBarController?.selectedIndex = 0
        })
        let actCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertWeekRst.addAction(actOk)
        alertWeekRst.addAction(actCancel)
        self.present(alertWeekRst, animated: true, completion: nil)
        
    }
    
    @IBAction func actWeekRstBtn(_ sender: UIButton) {
        let alertWeekRst = UIAlertController(title: nil, message: "週間のカロリーと糖質の値を削除しますよろしいですか？", preferredStyle: .alert)
        let actOk = UIAlertAction(title: "OK",style: .default,handler:{(action) -> Void in
            self.appDelegate.weekRstFlg = true
            self.tabBarController?.selectedIndex = 0
        })
        let actCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertWeekRst.addAction(actOk)
        alertWeekRst.addAction(actCancel)
        self.present(alertWeekRst, animated: true, completion: nil)
        
        let iVC = InsertViewController()
        //初回入力された日の日付を消す
        iVC.insertUserDefalt.removeObject(forKey: "weekStartDate")
        iVC.insertUserDefalt.synchronize()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func swipeConf(){
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightAct))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    @objc func swipeRightAct(){
        self.tabBarController!.selectedIndex = 1
    }
    // segueの設定
    ////////////////////////////////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //toNumberViewSegueの場合
        if segue.identifier == "toNumberViewSegue" {
            //segueをインスタンス化
            let nVC:numberViewController = segue.destination as! numberViewController
            //テーブルビューのタップされている行数を取得する
            let aaa = self.tableView.indexPathForSelectedRow
            //セルの選択を消す
            tableView.deselectRow(at: aaa!, animated: true)
            //次画面の変数に値をセット
            appDelegate.selectRow = aaa!.row
            
            
            switch appDelegate.selectRow {
            //1行目の場合
            case 0:
                nVC.calcVal = confUserDefaults.string(forKey: "cal")
            //2行目の場合
            case 1:
                nVC.calcVal = confUserDefaults.string(forKey: "cabo")
            
            default:
                nVC.calcVal = "444"
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.tabBarController?.tabBar.isHidden == true {
            self.tabBarController?.tabBar.isHidden = false
        }
        tableView.reloadData()
        swipeConf()
    }
    
    @IBAction func returnToMe(segue: UIStoryboardSegue){
        switch appDelegate.selectRow {
        case 0:
            confUserDefaults.set(appDelegate.targetCalVal, forKey: "cal")
        case 1:
            confUserDefaults.set(appDelegate.targetCaboVal, forKey: "cabo")
        default:
            print("目標値入力から設定画面に戻るときにエラー出てるで")
        }
        confUserDefaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初期値は成人男性の平均を参考
        //column.rizapstore.jp/kiso/65.html
        if confUserDefaults.object(forKey: "cal") == nil{
            confUserDefaults.set(2500, forKey: "cal")
        }
        if confUserDefaults.object(forKey: "cabo") == nil{
            confUserDefaults.set(360, forKey: "cabo")
        }
        confUserDefaults.synchronize()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NBImage.png"), for: .topAttached, barMetrics: .default)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
