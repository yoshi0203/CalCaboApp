//
//  ViewController.swift
//  CalCaboApp
//
//  Created by yamanaka on 2018/01/11.
//  Copyright © 2018年 yamanaka. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var dayCalNum: UILabel!
    @IBOutlet weak var weekCalNum: UILabel!
    @IBOutlet weak var dayCabNum: UILabel!
    @IBOutlet weak var weekCabNum: UILabel!
    @IBOutlet weak var limitCalLab: UILabel!
    @IBOutlet weak var limitCaboLab: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var talkBackLabel: UILabel!
    @IBOutlet weak var talkWord: UILabel!
    @IBOutlet weak var kCalLabel: UILabel!
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var defaltTalkLabel: UILabel!
    @IBOutlet weak var randTalkLabel: UILabel!
    
    @IBOutlet weak var testbtn: UIButton!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let homeUserDefaults = UserDefaults.standard
    var swipeGR: UISwipeGestureRecognizer?
    var dayCal:Int = 0
    var dayCabo:Int = 0
    var weekCal:Int = 0
    var weekCabo:Int = 0
    
    var calChartData:[Double] = [0,0,0,0,0,0,0]
    var caboChartData:[Double] = [0,0,0,0,0,0,0]
    
    //画面切替直前に読み込まれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if appDelegate.dayRstFlg == true {
            appDelegate.dayRstFlg = false
            homeUserDefaults.set("default", forKey: "DCL")
            homeUserDefaults.set("default", forKey: "DCB")
            
            weekCal = weekCal - dayCal
            weekCabo = weekCabo - dayCabo
            weekCalNum.text = String(weekCal)
            weekCabNum.text = String(weekCabo)
            homeUserDefaults.set(weekCal, forKey: "WCL")
            homeUserDefaults.set(weekCabo, forKey: "WCB")
            homeUserDefaults.synchronize()
            
            dayCalNum.text = "0"
            dayCabNum.text = "0"
            dayCal = 0
            dayCabo = 0
            
        }
        
        if appDelegate.weekRstFlg == true {
            homeUserDefaults.set("defalut", forKey: "WCL")
            homeUserDefaults.set("default", forKey: "WCB")
            homeUserDefaults.synchronize()
            dayCalNum.text = "0"
            dayCabNum.text = "0"
            weekCalNum.text = "0"
            weekCabNum.text = "0"
            dayCal = 0
            dayCabo = 0
            weekCal = 0
            weekCabo = 0
            appDelegate.weekRstFlg = false
            
            for i in 0 ..< calChartData.count {
                calChartData[i] = Double(0)
                caboChartData[i] = Double(0)
            }
            homeUserDefaults.removeObject(forKey: "ChartData")
        }else{
        
            dayCal = dayCal + appDelegate.cal
            dayCabo = dayCabo + appDelegate.cabo
            
            weekCal = weekCal + appDelegate.cal
            weekCabo = weekCabo + appDelegate.cabo
            
            appDelegate.cal = 0
            appDelegate.cabo = 0
            dayCalNum.text = String(dayCal)
            dayCabNum.text = String(dayCabo)
            weekCalNum.text = String(weekCal)
            weekCabNum.text = String(weekCabo)
            homeUserDefaults.set(dayCal, forKey: "DCL")
            homeUserDefaults.set(dayCabo, forKey: "DCB")
            homeUserDefaults.set(weekCal, forKey: "WCL")
            homeUserDefaults.set(weekCabo, forKey: "WCB")
            homeUserDefaults.synchronize()
        }
        
        let cVC = configViewController()
        
        if cVC.confUserDefaults.string(forKey: "cal") != nil{
            limitCalLab.text = cVC.confUserDefaults.string(forKey: "cal")
            limitCaboLab.text = cVC.confUserDefaults.string(forKey: "cabo")
        } else {
            //アプリダウンロード後初回のみ設定
            limitCalLab.text = "2500"
            limitCaboLab.text = "360"
        }
        var toDay:Int = dateConf()
        //8日目だった場合
        if toDay >= 7 {
            //週の値をリセット
            appDelegate.resultCal = weekCalNum.text
            appDelegate.resultCabo = weekCabNum.text
            weekNumRst()
            resetUserDefault()
            dayZero()
            //リザルト画面表示
            let rVC = self.storyboard?.instantiateViewController(withIdentifier: "modal")
            rVC?.modalTransitionStyle = .coverVertical
            present(rVC!,animated: true, completion: nil)
            toDay = 0
        }
        
        setChart(LimitCal: Double(limitCalLab.text!)!,LimitCabo: Double(limitCaboLab.text!)!,ToDay: toDay)
        talkConf()
    }
    


    //グラフ設定用メソッド
    func setChart(LimitCal: Double,LimitCabo: Double , ToDay: Int){
        
        var entries = [[ChartDataEntry]]()
        var datasets = [LineChartDataSet]()
        var line = LineChartDataSet()
        
        if homeUserDefaults.object(forKey: "ChartData") != nil {
            var hUDChartData = homeUserDefaults.object(forKey: "ChartData") as! [[Double]]
            calChartData = hUDChartData[0]
            caboChartData = hUDChartData[1]
        }
        
        calChartData[ToDay] = Double(dayCal)
        caboChartData[ToDay] = Double(dayCabo)
        
        var chartData:[[Double]] = [calChartData,caboChartData]
        
        homeUserDefaults.set(chartData, forKey: "ChartData")
        homeUserDefaults.synchronize()
        
        for i in 0 ..< chartData.count {
            entries.append([ChartDataEntry]())
            for (j, d) in chartData[i].enumerated(){
                if i == 0 {
                    entries[i].append(ChartDataEntry(x: Double(j), y: d/LimitCal))
                }else{
                    entries[i].append(ChartDataEntry(x: Double(j), y: d/LimitCabo))
                }
            }
            if i == 0{
                line = LineChartDataSet(values: entries[i], label: "カロリー")
                line.setColor(UIColor(red: 67/255, green: 135/255, blue: 233/255, alpha: 1.0))
                line.setCircleColor(UIColor(red: 67/255, green: 135/255, blue: 233/255, alpha: 1.0))
                line.drawValuesEnabled = false
                line.drawCirclesEnabled = false
                line.lineWidth = 2.0
            }else{
                line = LineChartDataSet(values: entries[i], label: "糖質")
                line.setColor(UIColor(red: 142/255, green: 242/255, blue: 240/255, alpha: 1.0))
                line.setCircleColor(UIColor(red: 142/255, green: 242/255, blue: 240/255, alpha: 1.0))
                line.drawValuesEnabled = false
                line.drawCirclesEnabled = false
                line.lineWidth = 2.0
            }
            
            datasets.append(line)
            
        }
        lineChartView.data = LineChartData(dataSets: datasets as [IChartDataSet])
        
        lineChartView.backgroundColor = UIColor.white
        lineChartView.chartDescription?.text = ""
        lineChartView.extraLeftOffset = 10.0
        lineChartView.extraRightOffset = 10.0
        lineChartView.xAxis.labelPosition = .bottom
        
        lineChartView.leftAxis.axisMaximum = 2.0
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.leftAxis.labelCount = 4
        
        lineChartView.rightAxis.axisMaximum = 2.0
        lineChartView.rightAxis.axisMinimum = 0.0
        lineChartView.rightAxis.labelCount = 4
        
        let formatter = ChartStringFormatter()
        lineChartView.xAxis.valueFormatter = formatter
        lineChartView.xAxis.granularity = 1.0
        
        let formatter2 = ChartStringFormatter2()
        lineChartView.leftAxis.valueFormatter = formatter2
        lineChartView.rightAxis.valueFormatter = formatter2
        
        let limitLine = ChartLimitLine(limit: 1.0, label: "目標")
        lineChartView.rightAxis.addLimitLine(limitLine)
        
        //グラフのタップやズーム等を無効
        lineChartView.highlightPerTapEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.dragEnabled = false
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        
    }
    
    //日付を管理するメソッド
    func dateConf() -> Int {
        var calender = Calendar.current
        calender.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calender.locale = Locale(identifier: "ja")
        
        //今日の日を取得する
        var nowDay = calender.component(.day, from: Date())
        //setChart()に値を渡すため1スタート
        var difDay : Int = 1
        let iVC = InsertViewController()
        
        //初日のデータが保存されていたら
        if iVC.insertUserDefalt.object(forKey: "weekStartDate") != nil{
            //入力初日のDateを取得
            let firstTimeDate = iVC.insertUserDefalt.object(forKey: "weekStartDate") as! Date
            //入力初日の日を取得
            let firstDay = calender.component(.day, from: firstTimeDate)
            
            //入力初日と今日の日を比較
            if firstDay > nowDay {
                //月が変わってた時
                let range = calender.range(of: .day, in: .month, for: firstTimeDate)
                difDay = (range!.count + nowDay) - firstDay
                
            }else{
                //変わってない時
                difDay = nowDay - firstDay
            }
            dayLabel.text = "day " + String(difDay + 1)
            limitCalLab.isHidden = false
            limitCaboLab.isHidden = false
            talkBackLabel.isHidden = false
            talkWord.isHidden = false
            kCalLabel.isHidden = false
            gLabel.isHidden = false
            defaltTalkLabel.isHidden = true
        }else{
            dayZero()
        }
        
        if iVC.insertUserDefalt.object(forKey: "lastInsertDate") != nil {
            let lastInsertDate = iVC.insertUserDefalt.object(forKey: "lastInsertDate") as! Date
            var lastDay = calender.component(.day, from: lastInsertDate)
            
            if lastDay != nowDay {
                //最終入力から日付が変わってた
                dayNumRst()
            }
        }
        return difDay
    }
    
    func dayNumRst(){
        homeUserDefaults.set("default", forKey: "DCL")
        homeUserDefaults.set("default", forKey: "DCB")
        homeUserDefaults.synchronize()
        dayCalNum.text = "0"
        dayCabNum.text = "0"
        dayCal = 0
        dayCabo = 0
    }
    
    func weekNumRst(){
        homeUserDefaults.set("defalut", forKey: "WCL")
        homeUserDefaults.set("default", forKey: "WCB")
        homeUserDefaults.synchronize()
        dayCalNum.text = "0"
        dayCabNum.text = "0"
        weekCalNum.text = "0"
        weekCabNum.text = "0"
        dayCal = 0
        dayCabo = 0
        weekCal = 0
        weekCabo = 0
        appDelegate.weekRstFlg = false
        for i in 0 ..< calChartData.count {
            calChartData[i] = Double(0)
            caboChartData[i] = Double(0)
        }
        homeUserDefaults.removeObject(forKey: "ChartData")
    }
    
    func dayZero(){
        dayLabel.text = "day 0"
        limitCalLab.isHidden = true
        limitCaboLab.isHidden = true
        talkBackLabel.isHidden = true
        talkWord.isHidden = true
        kCalLabel.isHidden = true
        gLabel.isHidden = true
        defaltTalkLabel.isHidden = false
    }
    
    func resetUserDefault(){
        let iVC = InsertViewController()
        iVC.insertUserDefalt.removeObject(forKey: "lastInsertDate")
        iVC.insertUserDefalt.removeObject(forKey: "weekStartDate")
        
    }
    
    func swipeConf(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightAct))
        swipeRight.direction = .left
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipeRightAct(){
        self.tabBarController!.selectedIndex = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if homeUserDefaults.string(forKey: "DCL") != "default" {
            dayCal = homeUserDefaults.integer(forKey: "DCL")
            dayCalNum.text = homeUserDefaults.string(forKey: "DCL")
            homeUserDefaults.synchronize()
        }else{
            homeUserDefaults.set("default", forKey: "DCL")
            dayCalNum.text = "0"
            homeUserDefaults.synchronize()
        }
        
        if homeUserDefaults.string(forKey: "DCB") != "default" {
            dayCabo = homeUserDefaults.integer(forKey: "DCB")
            dayCabNum.text = homeUserDefaults.string(forKey: "DCB")
            homeUserDefaults.synchronize()
        }else{
            homeUserDefaults.set("default", forKey: "DCB")
            dayCalNum.text = "0"
            homeUserDefaults.synchronize()
        }

        
        if homeUserDefaults.string(forKey: "WCL") != "default" {
            weekCal = homeUserDefaults.integer(forKey: "WCL")
            weekCalNum.text = homeUserDefaults.string(forKey: "WCL")
            homeUserDefaults.synchronize()
        }else{
            homeUserDefaults.set("defalut", forKey: "WCL")
            weekCalNum.text = "0"
            homeUserDefaults.synchronize()
        }
        
        if homeUserDefaults.string(forKey: "WCB") != "default"{
            weekCabo = homeUserDefaults.integer(forKey: "WCB")
            weekCabNum.text = homeUserDefaults.string(forKey: "WCB")
            homeUserDefaults.synchronize()
        }else{
            homeUserDefaults.set("default", forKey: "WCB")
            weekCabNum.text = "0"
            homeUserDefaults.synchronize()
        }
        let cVC = configViewController()
        if cVC.confUserDefaults.object(forKey: "cal") != nil {
            limitCalLab.text = cVC.confUserDefaults.string(forKey: "cal")
            limitCaboLab.text = cVC.confUserDefaults.string(forKey: "cabo")
        }
        swipeConf()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NBImage.png"), for: .topAttached, barMetrics: .default)
        
        
    }
    func talkConf() {
        let rand = Int(arc4random_uniform(6))
        switch rand {
        case 1 :
            randTalkLabel.text = "食べなさすぎも良くありません！"
        case 2 :
            randTalkLabel.text = "栄養のバランスも重要です！"
        case 3 :
            randTalkLabel.text = "腹八分目で医者いらず！"
        case 4 :
            randTalkLabel.text = "ロカボにはブランパン！"
        case 5 :
            randTalkLabel.text = "満腹を感じるのは約20分経ってから！"
        default:
            randTalkLabel.text = "よくかんで食べましょう！"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

class ChartStringFormatter: NSObject, IAxisValueFormatter {
    let labels = ["Start","","","","","","Goal"]
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: labels[Int(value)])
    }
}
class ChartStringFormatter2: NSObject, IAxisValueFormatter {
    let labels = ["","","","","","",""]
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: labels[Int(value)])
    }
}
