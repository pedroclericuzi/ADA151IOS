//
//  editTask.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 24/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

class editTask: Util, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleEdit: UITextField!
    @IBOutlet weak var deadlineEdit: UIDatePicker!
    @IBOutlet weak var categoryEdit: UIPickerView!
    
    //Classes to do communication with the base
    let modelTask:ModelTask = ModelTask()
    let modelCategory: ModelCategory = ModelCategory();
    
    var arrCategories:[String] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for currentCategory in self.modelCategory.getAll() {
            let myCategory:String = currentCategory.value(forKey: "category")! as! String;
            arrCategories.append(myCategory);
        }
        
        // Do any additional setup after loading the view.
        for currentTask in self.modelTask.getSpecificTask(id: arrIdTask[myIndex]) {
            self.titleEdit.text = currentTask.value(forKey: "title")! as? String
            let deadlineFromCore = currentTask.value(forKey: "deadline")! as! Date
            self.deadlineEdit.timeZone = TimeZone(abbreviation: "GMT+2:00") //Setting the time zone from czech republic
            self.deadlineEdit.date = deadlineFromCore
            let myCategory = currentTask.value(forKey: "category")! as! String
            categoryEdit.selectRow(arrCategories.index(of: myCategory)!, inComponent: 0, animated: false);
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCategories.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCategories[row];
    }
    
    @IBAction func btSaveEdit(_ sender: Any) {
        let addTaskClass:addTask = addTask()
        let title:String = self.titleEdit.text!;
        let componentCategory:Int = self.categoryEdit.selectedRow(inComponent: 0);
        let yourCategory:String = arrCategories[componentCategory];
        self.replaceDataArray(id: arrIdTask[myIndex], title: title, deadline: addTaskClass.timeFormat(deadline: self.deadlineEdit.date), category: yourCategory)
        modelTask.editTask(id: arrIdTask[myIndex],titleTask: title, mDate: addTaskClass.timeFormat(deadline: self.deadlineEdit.date), category: yourCategory);
        //self.dismissSegue()
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    //Method to add the new data in array
    func replaceDataArray(id:String, title:String, deadline:Date, category:String) {
        if id.elementsEqual("error") == false {
            arrIdTask[myIndex] = id
            arrTitleTask[myIndex] = title
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mma";
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+2:00");
            arrDeadlineTask[myIndex] = "deadline: \(dateFormatter.string(from: deadline))"
            arrCategoryTask[myIndex] = category
            
            let modelCategory: ModelCategory = ModelCategory()
            for currentCategory in modelCategory.getAll() {
                let categoriesToCompare:String = currentCategory.value(forKey: "category")! as! String
                if(categoriesToCompare==category){
                    let hexColor:String = currentCategory.value(forKey: "color")! as! String
                    arrColorTask[myIndex] = hexColor
                }
            }
        }
    }

}
