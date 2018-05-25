//
//  addCategory.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

class addCategory: Util, UITableViewDelegate {

    @IBOutlet weak var titleCategory: UITextField!
    @IBOutlet weak var hexCategory: UITextField!
    
    //Classes to do communication with the base
    let modelTask:ModelTask = ModelTask()
    let modelCategory: ModelCategory = ModelCategory();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    @IBAction func save(_ sender: Any) {
        modelCategory.save(name: self.titleCategory.text!, color: self.hexCategory.text!)
        self.dismissSegue()
    }

}
