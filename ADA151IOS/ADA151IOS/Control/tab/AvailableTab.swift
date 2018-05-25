//
//  AvailableTab.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import UserNotifications

var avIdTask:[String] = []
var avTitleTask:[String] = []
var avDeadlineTask:[String] = []
var avCategoryTask:[String] = []
var avColorTask:[String] = []
var indexAvailable = 0

class AvailableTab: Util, UITableViewDataSource, UITableViewDelegate {
    let idCell:String = "Cell";
    @IBOutlet weak var listAvailable: UITableView!
    
    //Classes to do communication with the base
    let modelTask:ModelTask = ModelTask()
    let modelCategory: ModelCategory = ModelCategory();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listAvailable.reloadData();
        // Do any additional setup after loading the view.
        let xib = UINib(nibName: "taskCell", bundle: nil)
        listAvailable.register(xib, forCellReuseIdentifier: idCell)
        listAvailable.dataSource = self
        listAvailable.delegate = self
        
        self.arrayTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("viewWillAppear done")
        self.listAvailable.reloadData();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("\(arrIdTask.count)")
        return avIdTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskCell = listAvailable.dequeueReusableCell(withIdentifier: idCell) as! TaskCell
        
        cell.labelTask.text = avTitleTask[indexPath.row]
        cell.labelDate.text = avDeadlineTask[indexPath.row]
        cell.viewCategory!.layer.cornerRadius = 12.5;
        cell.viewCategory!.clipsToBounds = true;
        cell.viewCategory!.backgroundColor = self.convertColor(string: avColorTask[indexPath.row])
        
        return cell
    }
    
    @IBAction func addTask(_ sender: Any) {
        //self.otherScreen(screen: "addTask");
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexAvailable = indexPath.row
        performSegue(withIdentifier: "segueAvailable", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers:[avIdTask[index.row]]) //Removing the current deadline's notification to this task
            self.moveToDone(index: index.row)
            self.modelTask.done(id: avIdTask[index.row])
            self.removeFromArrayAvailable(index: index.row)
        }
        done.backgroundColor = UIColor.green
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers:[avIdTask[index.row]])
            self.modelTask.deleteTask(id: avIdTask[index.row])
            self.removeFromArrayAvailable(index: index.row)
        }
        delete.backgroundColor = UIColor.red
        return [delete, done]
    }
    
    func removeFromArrayAvailable(index:Int) {
        avIdTask.remove(at: index);
        avTitleTask.remove(at: index);
        avDeadlineTask.remove(at: index);
        avColorTask.remove(at: index);
        avCategoryTask.remove(at: index);
        self.listAvailable.reloadData();
    }
    
    func moveToDone(index:Int) {
        doneIdTask.append(avIdTask[index])
        doneTitleTask.append(avTitleTask[index])
        doneDeadlineTask.append(avDeadlineTask[index])
        doneColorTask.append(avColorTask[index])
        doneCategoryTask.append(avCategoryTask[index])
    }
    
    func arrayTasks() {
        for currentTask in modelTask.getTask() {
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "'deadline: 'dd/MM/yyyy 'at' hh:mma";
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+2:00");
            //Status
            let statusTask:String = currentTask.value(forKey: "status") as! String;
            if (statusTask=="doing"){
                //id
                let idTask:String = currentTask.value(forKey: "id") as! String;
                avIdTask.append(idTask);
                //Title
                let myTask:String = currentTask.value(forKey: "title") as! String;
                avTitleTask.append(myTask);
                //Deadline
                let deadlineTask:Date = currentTask.value(forKey: "deadline")! as! Date;
                let finalDate = dateFormatter.string(from: deadlineTask);
                avDeadlineTask.append(finalDate);
                //Color
                let categoryColor:String = currentTask.value(forKey: "category")! as! String;
                avCategoryTask.append(categoryColor);
                //This for get all the categories to search the color of it
                for currentCategory in modelCategory.getAll() {
                    let categoriesToCompare:String = currentCategory.value(forKey: "category")! as! String;
                    if(categoriesToCompare==categoryColor){
                        let hexColor:String = currentCategory.value(forKey: "color")! as! String;
                        avColorTask.append(hexColor);
                    }
                }
            }
        }
    }
}
