//
//  addCategory.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

class addCategory: Util, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleCategory: UITextField!
    @IBOutlet weak var pickerColors: UIPickerView!
    
    //Classes to do communication with the base
    let modelCategory: ModelCategory = ModelCategory();
    let modelColor: ModelColor = ModelColor();
    var generalColors:[String] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerColors.dataSource = self;
        pickerColors.delegate = self;
        
        for currentColor in modelColor.getAll() {
            let myColor:String = currentColor.value(forKey: "name")! as! String;
            generalColors.append(myColor);
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    @IBAction func save(_ sender: Any) {
        let componentColor:Int = self.pickerColors.selectedRow(inComponent: 0);
        let valueColors = generalColors[componentColor]
        modelCategory.save(name: self.titleCategory.text!, color: valueColors)
        self.dismissSegue()
    }

}
