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
    @IBOutlet weak var colorEdit: UIPickerView!
    @IBOutlet weak var categoryEdit: UITextField!
    
    //Classes to do communication with the base
    let modelTask:ModelTask = ModelTask()
    let modelCategory: ModelCategory = ModelCategory();
    let modelColor: ModelColor = ModelColor();
    
    var arrColors:[String] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for currentColor in self.modelColor.getAll() {
            let myColor:String = currentColor.value(forKey: "name")! as! String;
            arrColors.append(myColor);
        }
        
        // Do any additional setup after loading the view.
        for currentTask in self.modelTask.getSpecificTask(id: avIdTask[indexAvailable]) {
            self.titleEdit.text = currentTask.value(forKey: "title")! as? String
            let deadlineFromCore = currentTask.value(forKey: "deadline")! as! Date
            self.deadlineEdit.timeZone = TimeZone(abbreviation: "GMT+2:00") //Setting the time zone from czech republic
            self.deadlineEdit.date = deadlineFromCore
            self.categoryEdit.text = currentTask.value(forKey: "category")! as? String
            let myColor = currentTask.value(forKey: "color")! as! String
            colorEdit.selectRow(arrColors.index(of: myColor)!, inComponent: 0, animated: false);
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
        return arrColors.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrColors[row];
    }
    
    @IBAction func btSaveEdit(_ sender: Any) {
        let addTaskClass:addTask = addTask()
        let title:String = self.titleEdit.text!;
        let componentColor:Int = self.colorEdit.selectedRow(inComponent: 0);
        let category:String = self.categoryEdit.text!;
        let yourColor:String = arrColors[componentColor];
        self.replaceDataArray(id: avIdTask[indexAvailable], title: title, deadline: addTaskClass.timeFormat(deadline: self.deadlineEdit.date), category:category, color: yourColor)
        
        modelTask.editTask(id: avIdTask[indexAvailable],titleTask: title, mDate: addTaskClass.timeFormat(deadline: self.deadlineEdit.date),category:category, color: yourColor);
        //self.dismissSegue()
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    //Method to add the new data in array
    func replaceDataArray(id:String, title:String, deadline:Date, category:String, color:String) {
        if id.elementsEqual("error") == false {
            avIdTask[indexAvailable] = id
            avTitleTask[indexAvailable] = title
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mma";
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+2:00");
            avDeadlineTask[indexAvailable] = "deadline: \(dateFormatter.string(from: deadline))"
            avCategoryTask[indexAvailable] = category
            avColorTask[indexAvailable] = color
            
            for currentColor in modelColor.getAll() {
                let colorsToCompare:String = currentColor.value(forKey: "name")! as! String
                if(colorsToCompare==color){
                    let hexColor:String = currentColor.value(forKey: "hex")! as! String
                    avHexTask[indexAvailable] = hexColor
                }
            }
        }
    }

}
