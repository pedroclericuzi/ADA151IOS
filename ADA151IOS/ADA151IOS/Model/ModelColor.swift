//
//  ModelColor.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 25/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import CoreData

class ModelColor: UIViewController {
    
    let utilControler:Util = Util();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func colorInit() {
        let context = utilControler.initCoreData();
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName:"Color");
        do {
            let category = try context.fetch(requisition);
            if (category.count == 0) {
                let myCategories = ["light green":"#C6DA02", "green":"#79A700",
                                    "orange":"#F68B2C", "gold":"#E2B400", "red":"#F5522D", "pink":"#FF6E83"];
                
                for registerCategories in myCategories {
                    let objManagement = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context);
                    objManagement.setValue(registerCategories.key, forKey: "name");
                    objManagement.setValue(registerCategories.value, forKey: "hex");
                    try context.save();
                }
            }
        } catch {
            print("Fatal error to register the categories");
        }
    }
    
    func getAll() -> [NSManagedObject] {
        let context = utilControler.initCoreData();
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName:"Color");
        let sort = NSSortDescriptor(key: "name", ascending: true); //ordering by category
        requisition.sortDescriptors = [sort];
        var allCategories:[NSManagedObject]?;
        do{
            allCategories = try context.fetch(requisition) as? [NSManagedObject];
        }catch let error as NSError{
            print("Ocurred a fatal error: \(error.description) ");
        }
        return allCategories!;
    }

}
