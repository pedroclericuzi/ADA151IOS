//
//  ModelCategory.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 24/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import CoreData
class ModelCategory: UIViewController {
    
    let utilControler:Util = Util();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func save(name:String, color:String) {
        let context = utilControler.initCoreData();
        do {
            let objManagement = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context);
            objManagement.setValue(name, forKey: "category");
            objManagement.setValue(color, forKey: "color");
            try context.save();
        } catch {
            print("Fatal error to register the taks");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
