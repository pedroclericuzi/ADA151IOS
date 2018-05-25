//
//  addTask.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import UserNotifications

class addTask: Util, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var titleTask: UITextField!
    @IBOutlet weak var deadlineTask: UIDatePicker!
    @IBOutlet weak var categoriesTask: UIPickerView!
    
    //Classes to do communication with the base
    let modelTask:ModelTask = ModelTask()
    let modelCategory: ModelCategory = ModelCategory();
    
    var generalCategories:[String] = [];
    @IBOutlet weak var pickerCategories: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerCategories.dataSource = self;
        pickerCategories.delegate = self;
        
        self.deadlineTask.timeZone = TimeZone(secondsFromGMT: 2*60*60) //Fixing the datepicker to local time in Prague
        modelCategory.categoryInit()
        for currentCategory in modelCategory.getAll() {
            let myCategory:String = currentCategory.value(forKey: "category")! as! String;
            generalCategories.append(myCategory);
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btSaveTask(_ sender: Any) {
        let componentCategory:Int = self.pickerCategories.selectedRow(inComponent: 0);
        let valueTitleTask = self.titleTask.text!
        let valueDeadlineTask = self.timeFormat(deadline: self.deadlineTask.date)
        let valueCategories = generalCategories[componentCategory]
        let idRet:String = modelTask.saveTask(title: valueTitleTask, mDate: valueDeadlineTask, category: valueCategories)
        self.newData(id: idRet, title: valueTitleTask, deadline: valueDeadlineTask, category: valueCategories)
        self.dismissSegue()
    }
    
    //Formatting the hour from text picker
    func timeFormat (deadline:Date) -> Date{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mma";
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+2:00");
        let finalDate = dateFormatter.string(from: deadline);
        let dateObj = dateFormatter.date(from: finalDate)
        return dateObj!
    }
    
    //Method to add the new data in array
    func newData(id:String, title:String, deadline:Date, category:String) {
        if id.elementsEqual("error") == false {
            arrIdTask.append(id)
            arrTitleTask.append(title)
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mma";
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+2:00");
            arrDeadlineTask.append("deadline: \(dateFormatter.string(from: deadline))")
            arrCategoryTask.append(category)
            
            let modelCategory: ModelCategory = ModelCategory();
            for currentCategory in modelCategory.getAll() {
                let categoriesToCompare:String = currentCategory.value(forKey: "category")! as! String;
                if(categoriesToCompare==category){
                    let hexColor:String = currentCategory.value(forKey: "color")! as! String;
                    arrColorTask.append(hexColor);
                }
            }
            self.localNotification(deadline:deadline, title: title, id: id)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return generalCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return generalCategories[row]
    }
    
}
