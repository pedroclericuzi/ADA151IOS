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
    @IBOutlet weak var colorTask: UIPickerView!
    @IBOutlet weak var categoryTask: UITextField!
    
    //Classes to do communication with the base
    let modelTask:ModelTask = ModelTask()
    let modelCategory: ModelCategory = ModelCategory();
    let modelColor: ModelColor = ModelColor();
    
    var generalColors:[String] = [];
    @IBOutlet weak var pickerColors: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        colorTask.dataSource = self;
        colorTask.delegate = self;
        
        self.deadlineTask.timeZone = TimeZone(secondsFromGMT: 2*60*60) //Fixing the datepicker to local time in Prague
        modelColor.colorInit()
        for currentColor in modelColor.getAll() {
            let myColor:String = currentColor.value(forKey: "name")! as! String;
            generalColors.append(myColor);
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
        let componentColor:Int = self.pickerColors.selectedRow(inComponent: 0);
        let valueTitleTask = self.titleTask.text!
        let valueDeadlineTask = self.timeFormat(deadline: self.deadlineTask.date)
        let valueColors = generalColors[componentColor]
        let valueCategory = self.categoryTask.text!
        let idRet:String = modelTask.saveTask(title: valueTitleTask, mDate: valueDeadlineTask, category:valueCategory, color: valueColors)
        self.newData(id: idRet, title: valueTitleTask, deadline: valueDeadlineTask, category:valueCategory, color: valueColors)
        self.modelCategory.save(name: valueCategory, color: valueColors)
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
    func newData(id:String, title:String, deadline:Date, category:String, color:String) {
        if id.elementsEqual("error") == false {
            avIdTask.append(id)
            avTitleTask.append(title)
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mma";
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+2:00");
            avDeadlineTask.append("deadline: \(dateFormatter.string(from: deadline))")
            avCategoryTask.append(category)
            avColorTask.append(color)
            
            for currentColor in modelColor.getAll() {
                let colorsToCompare:String = currentColor.value(forKey: "name")! as! String;
                if(colorsToCompare==color){
                    let hexColor:String = currentColor.value(forKey: "hex")! as! String;
                    avHexTask.append(hexColor);
                }
            }
            self.localNotification(deadline:deadline, title: title, id: id)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return generalColors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return generalColors[row]
    }
    
}
