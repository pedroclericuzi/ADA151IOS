//
//  AvailableTab.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

var arrIdTask:[String] = []
var arrTitleTask:[String] = []
var arrDeadlineTask:[String] = []
var arrCategoryTask:[String] = []
var arrColorTask:[String] = []
var myIndex = 0

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
        return arrIdTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskCell = listAvailable.dequeueReusableCell(withIdentifier: idCell) as! TaskCell
        
        cell.labelTask.text = arrTitleTask[indexPath.row]
        cell.labelDate.text = arrDeadlineTask[indexPath.row]
        cell.viewCategory!.layer.cornerRadius = 12.5;
        cell.viewCategory!.clipsToBounds = true;
        cell.viewCategory!.backgroundColor = self.convertColor(string: arrColorTask[indexPath.row])
        
        return cell
    }
    
    @IBAction func addTask(_ sender: Any) {
        //self.otherScreen(screen: "addTask");
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segueAvailable", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in
            self.modelTask.done(id: arrIdTask[index.row]);
            self.removeFromArrayAvailable(index: index.row);
        }
        let myColorGreen:String=self.colorNameToHex(color: "green");
        done.backgroundColor = self.convertColor(string: myColorGreen);
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.modelTask.deleteTask(id: arrIdTask[index.row]);
            self.removeFromArrayAvailable(index: index.row);
        }
        delete.backgroundColor = UIColor.red;
        return [delete, done]
        
    }
    
    func removeFromArrayAvailable(index:Int) {
        arrIdTask.remove(at: index);
        arrTitleTask.remove(at: index);
        arrDeadlineTask.remove(at: index);
        arrColorTask.remove(at: index);
        arrCategoryTask.remove(at: index);
        self.listAvailable.reloadData();
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
                arrIdTask.append(idTask);
                //Title
                let myTask:String = currentTask.value(forKey: "title") as! String;
                arrTitleTask.append(myTask);
                //Deadline
                let deadlineTask:Date = currentTask.value(forKey: "deadline")! as! Date;
                let finalDate = dateFormatter.string(from: deadlineTask);
                arrDeadlineTask.append(finalDate);
                //Color
                let categoryColor:String = currentTask.value(forKey: "category")! as! String;
                arrCategoryTask.append(categoryColor);
                //This for get all the categories to search the color of it
                for currentCategory in modelCategory.getAll() {
                    let categoriesToCompare:String = currentCategory.value(forKey: "category")! as! String;
                    if(categoriesToCompare==categoryColor){
                        let hexColor:String = currentCategory.value(forKey: "color")! as! String;
                        arrColorTask.append(hexColor);
                    }
                }
            }
        }
    }
}
