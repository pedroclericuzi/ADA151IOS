//
//  DoneTab.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

var doneIdTask:[String] = []
var doneTitleTask:[String] = []
var doneDeadlineTask:[String] = []
var doneCategoryTask:[String] = []
var doneColorTask:[String] = []
var doneHexTask:[String] = []
var indexDone = 0

class DoneTab: Util, UITableViewDataSource, UITableViewDelegate {
    let idCell:String = "CellDone";
    @IBOutlet weak var listDone: UITableView!
    //Classes to do communication with the base
    let modelTask:ModelTask = ModelTask()
    let modelCategory: ModelCategory = ModelCategory();
    let modelColor: ModelColor = ModelColor();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Reloading the datas
        self.listDone.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDone), name: .UIApplicationWillEnterForeground, object: nil)
        // Do any additional setup after loading the view.
        let xib = UINib(nibName: "taskCell", bundle: nil)
        listDone.register(xib, forCellReuseIdentifier: idCell)
        listDone.dataSource = self
        listDone.delegate = self
        
        self.doneArrayTasks()
    }
    
    @objc func reloadDone(){
        print("teste")
        self.listDone.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear done")
        self.listDone.reloadData();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear done \(doneIdTask.count)")
        self.listDone.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneIdTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskCell = listDone.dequeueReusableCell(withIdentifier: idCell) as! TaskCell
        
        cell.labelTask.text = doneTitleTask[indexPath.row]
        cell.labelDate.text = doneDeadlineTask[indexPath.row]
        cell.viewColor!.layer.cornerRadius = 12.5;
        cell.viewColor!.clipsToBounds = true;
        cell.viewColor!.backgroundColor = self.convertColor(string: doneHexTask[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.modelTask.deleteTask(id: doneIdTask[index.row])
            self.removeFromArrayDone(index: index.row)
        }
        delete.backgroundColor = UIColor.red
        return [delete]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexDone = indexPath.row
        performSegue(withIdentifier: "segueDone", sender: self)
    }
    //clean this position in array
    func removeFromArrayDone(index:Int) {
        doneIdTask.remove(at: index);
        doneTitleTask.remove(at: index);
        doneDeadlineTask.remove(at: index);
        doneHexTask.remove(at: index);
        doneColorTask.remove(at: index);
        self.listDone.reloadData();
    }
    //create each position in global array
    func doneArrayTasks() {
        for currentTask in modelTask.getTask() {
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "'deadline: 'dd/MM/yyyy 'at' hh:mma";
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+2:00");
            //Status
            let statusTask:String = currentTask.value(forKey: "status") as! String;
            if (statusTask=="done"){
                //id
                let idTask:String = currentTask.value(forKey: "id") as! String;
                doneIdTask.append(idTask);
                //Title
                let myTask:String = currentTask.value(forKey: "title") as! String;
                doneTitleTask.append(myTask);
                //Deadline
                let deadlineTask:Date = currentTask.value(forKey: "deadline")! as! Date;
                let finalDate = dateFormatter.string(from: deadlineTask);
                doneDeadlineTask.append(finalDate);
                //Category
                let categoryTask:String = currentTask.value(forKey: "category") as! String;
                doneCategoryTask.append(categoryTask);
                //Color
                let colorName:String = currentTask.value(forKey: "color")! as! String;
                doneColorTask.append(colorName);
                //This for get all the color to search the color of it
                for currentColor in modelColor.getAll() {
                    let colorsToCompare:String = currentColor.value(forKey: "name")! as! String;
                    if(colorsToCompare==colorName){
                        let hexColor:String = currentColor.value(forKey: "hex")! as! String;
                        doneHexTask.append(hexColor);
                    }
                }
            }
        }
    }
}
