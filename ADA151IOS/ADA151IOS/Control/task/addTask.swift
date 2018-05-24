//
//  addTask.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

class addTask: Util, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var titleTask: UITextField!
    @IBOutlet weak var deadlineTask: UIDatePicker!
    @IBOutlet weak var categoriesTask: UIPickerView!
    
    //Classes to do communication with the base
    let modelTask:ModelTask = ModelTask()
    let modelCategory: ModelCategory = ModelCategory();
    
    var arrCategories:[String] = [];
    @IBOutlet weak var pickerCategories: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerCategories.dataSource = self;
        pickerCategories.delegate = self;
        
        self.deadlineTask.timeZone = TimeZone(secondsFromGMT: 2*60*60) //Fixing the datepicker to local time in Prague
        modelCategory.categoryInit()
        for currentCategory in modelCategory.getAll() {
            let myCategory:String = currentCategory.value(forKey: "category")! as! String;
            arrCategories.append(myCategory);
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
        let valueDeadlineTask = self.deadlineTask.date
        let valueCategories = arrCategories[componentCategory]
        modelTask.saveTask(title: valueTitleTask, mDate: valueDeadlineTask, category: valueCategories)
        //let availableClass:AvailableTab = AvailableTab();
        //availableClass.Teste()
        arrIdTask.append("teste")
        arrTitleTask.append(valueTitleTask)
        arrDeadlineTask.append("\(valueDeadlineTask)")
        arrColorTask.append(valueCategories)
        self.dismissSegue()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCategories[row]
    }
    
}
