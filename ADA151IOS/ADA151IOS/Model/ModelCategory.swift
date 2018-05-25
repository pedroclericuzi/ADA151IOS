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
    
    func categoryInit() {
        let context = utilControler.initCoreData();
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName:"Category");
        do {
            let category = try context.fetch(requisition);
            if (category.count == 0) {
                let myCategories = ["light green":"#C6DA02", "green":"#79A700",
                                    "orange":"#F68B2C", "gold":"#E2B400", "red":"#F5522D", "pink":"#FF6E83"];
                
                for registerCategories in myCategories {
                    let objManagement = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context);
                    objManagement.setValue(registerCategories.key, forKey: "category");
                    objManagement.setValue(registerCategories.value, forKey: "color");
                    try context.save();
                }
            }
        } catch {
            print("Fatal error to register the categories");
        }
    }
    
    func getAll() -> [NSManagedObject] {
        let context = utilControler.initCoreData();
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName:"Category");
        let sort = NSSortDescriptor(key: "category", ascending: true); //ordering by category
        requisition.sortDescriptors = [sort];
        var allCategories:[NSManagedObject]?;
        do{
            allCategories = try context.fetch(requisition) as? [NSManagedObject];
        }catch let error as NSError{
            print("Ocurred a fatal error: \(error.description) ");
        }
        return allCategories!;
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
