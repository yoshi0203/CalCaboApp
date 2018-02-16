//
//  InsertViewController.swift
//  CalCaboApp
//
//  Created by yamanaka on 2018/01/17.
//  Copyright © 2018年 yamanaka. All rights reserved.
//

import UIKit
import CoreData

class InsertViewController: UIViewController , UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var chkBox: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var calText: UITextField!
    @IBOutlet weak var caboText: UITextField!
    @IBOutlet weak var registListView: UITableView!
    
    var tapChkFlg = Bool(true)
    var fetchedArray: [NSManagedObject] = []
    
    let imgChk = UIImage(named: "check")
    let imgNonChk = UIImage(named: "noncheck")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let insertUserDefalt = UserDefaults.standard
    
    //チェックボックス
    @IBAction func tapChkBox(_ sender: UIButton) {
        if tapChkFlg == false {
            tapChkFlg = true
            chkBox.setImage(imgChk, for: .normal)
        }else{
            tapChkFlg = false
            chkBox.setImage(imgNonChk, for: .normal)
        }
    }
    @IBAction func tapSubmit(_ sender: UIButton) {
        if nameText.text == ""{
            nameText.text = "無題"
        }
        if calText.text == "" {
            calText.text = "0"
        }
        if caboText.text == "" {
            caboText.text = "0"
        }
        
        appDelegate.cal = Int(calText.text!)!
        appDelegate.cabo = Int(caboText.text!)!
        
        if tapChkFlg == true {
            addData(name: nameText.text!, cal: Int(calText.text!)!, cabo: Int(caboText.text!)!)
        }
                
        weekStartChk()
        insertUserDefalt.set(Date(), forKey: "lastInsertDate")
        insertUserDefalt.synchronize()
        
        self.view.endEditing(true)
        self.tabBarController?.selectedIndex = 0
    }
    func weekStartChk(){
        if insertUserDefalt.object(forKey: "weekStartDate") == nil {
            insertUserDefalt.set(Date(), forKey: "weekStartDate")
            insertUserDefalt.synchronize()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath)
        let cellData = fetchedArray[indexPath.row] as! FoodData
        let cellImage = cell.viewWithTag(1) as! UIImageView
        cellImage.image = UIImage(named: "eatIcon")
        let cellLabel2 = cell.viewWithTag(2) as! UILabel
        cellLabel2.text = cellData.name
        let strCal = String(cellData.calorie)
        let strCabo = String(cellData.carbohydrate)
        let cellLabel3 = cell.viewWithTag(3) as! UILabel
        cellLabel3.text = (strCal + "kcal " + strCabo + "g")
        return cell
    }
    
    // セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tapRegistList = fetchedArray[indexPath.row] as! FoodData
        nameText.text = tapRegistList.name
        calText.text = String(tapRegistList.calorie)
        caboText.text = String(tapRegistList.carbohydrate)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath ){
        if editingStyle == .delete {
            deleteData(row: indexPath.row)
            fetchData()
            registListView.reloadData()
        }
    }

    @available(iOS 11, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "削除") {
            (action, sourceView, completionHandler) in completionHandler(true)
            self.deleteData(row: indexPath.row)
            self.fetchData()
            self.registListView.reloadData()
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.contentView.backgroundColor = UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameText.resignFirstResponder()
        calText.resignFirstResponder()
        caboText.resignFirstResponder()
    }
    
    func swipeConf(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeftAct))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightAct))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func swipeLeftAct(){
        self.tabBarController!.selectedIndex = 2
    }
    
    @objc func swipeRightAct(){
        self.tabBarController!.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        registListView.reloadData()
        swipeConf()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NBImage.png"), for: .topAttached, barMetrics: .default)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchData(){
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FoodData")
        
        do{
            fetchedArray = try context.fetch(fetchRequest)
        }catch let error as NSError {
            print(error)
        }
    }
    
    func addData(name: String, cal: Int, cabo: Int){
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FoodData", in: context)!
        
        let foodData = NSManagedObject(entity: entity, insertInto: context)
        
        foodData.setValue(name, forKey: "name")
        foodData.setValue(cal, forKey: "calorie")
        foodData.setValue(cabo, forKey: "carbohydrate")
        
        do{
            try context.save()
        }catch let error as NSError{
            print(error)
        }
    }
    
    func deleteData(row: Int){
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FoodData")
        
        do{
            fetchedArray = try context.fetch(fetchRequest)
        }catch let error as NSError{
            print(error)
        }
        
        let delFoodData = fetchedArray[row] as! FoodData
        
        context.delete(delFoodData)
        
        do{
            try context.save()
        }catch let error as NSError{
            print(error)
        }
    }
    
}
