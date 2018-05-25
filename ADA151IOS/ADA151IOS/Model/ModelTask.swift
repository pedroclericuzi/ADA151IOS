//
//  ModelTask.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 24/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ModelTask: UIViewController {
    
    let utilControler:Util = Util();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveTask(title:String, mDate:Date, category:String, color:String) -> String {
        let context = utilControler.initCoreData();
        do {
            let objManagement = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context);
            let id:String = utilControler.generateID();
            objManagement.setValue(id, forKey: "id");
            objManagement.setValue(title, forKey: "title");
            objManagement.setValue(mDate, forKey: "deadline");
            objManagement.setValue(category, forKey: "category");
            objManagement.setValue(color, forKey: "color");
            objManagement.setValue("doing", forKey: "status");
            try context.save();
            return id
        } catch {
            print("Fatal error to register the taks")
            return "error"
        }
    }
    
    func editTask(id:String,titleTask:String,mDate:Date, category:String, color:String) {
        let context = utilControler.initCoreData();
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName:"Task");
        requisition.predicate = NSPredicate(format: "id == %@", id);
        var allTasks:[NSManagedObject]?;
        do{
            allTasks = try context.fetch(requisition) as? [NSManagedObject];
            for managedObject in allTasks!
            {
                let objManagement = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context);
                objManagement.setValue(id, forKey: "id");
                objManagement.setValue(titleTask, forKey: "title");
                objManagement.setValue(mDate, forKey: "deadline");
                objManagement.setValue(category, forKey: "category");
                objManagement.setValue(color, forKey: "color");
                objManagement.setValue("doing", forKey: "status");
                context.delete(managedObject);
                try context.save();
            }
        }catch let error as NSError{
            print("Ocurred a fatal error: \(error.description) ");
        }
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers:[id]) //Removing the current deadline's notification to this task
        utilControler.localNotification(deadline: mDate, title: titleTask, id: id) //creating a new notification
    }
    
    func getTask() -> [NSManagedObject] {
        let context = utilControler.initCoreData();
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName:"Task");
        let sort = NSSortDescriptor(key: "deadline", ascending: true);
        requisition.sortDescriptors = [sort];
        var allTasks:[NSManagedObject]?;
        do{
            allTasks = try context.fetch(requisition) as? [NSManagedObject];
        }catch let error as NSError{
            print("Ocurred a fatal error: \(error.description) ");
        }
        return allTasks!;
    }
    
    func getSpecificTask(id:String) -> [NSManagedObject] {
        let context = utilControler.initCoreData();
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName:"Task");
        let sort = NSSortDescriptor(key: "deadline", ascending: true); //order by deadline
        requisition.predicate = NSPredicate(format: "id == %@", id);
        requisition.sortDescriptors = [sort];
        var myTask:[NSManagedObject]?;
        do{
            myTask = try context.fetch(requisition) as? [NSManagedObject];
        }catch let error as NSError{
            print("Ocurred a fatal error: \(error.description) ");
        }
        return myTask!;
    }
    
    func deleteTask(id:String) {
        let context = utilControler.initCoreData();
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName:"Task");
        requisition.predicate = NSPredicate(format: "id == %@", id);
        var allTasks:[NSManagedObject]?;
        do{
            allTasks = try context.fetch(requisition) as? [NSManagedObject];
            for managedObject in allTasks!
            {
                //print(managedObject);
                context.delete(managedObject);
            }
            try context.save();
        }catch let error as NSError{
            print("Ocurred a fatal error: \(error.description) ");
        }
    }
    
    func done(id:String) {
        let context = utilControler.initCoreData();
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName:"Task");
        requisition.predicate = NSPredicate(format: "id == %@", id);
        var allTasks:[NSManagedObject]?;
        do{
            allTasks = try context.fetch(requisition) as? [NSManagedObject];
            for managedObject in allTasks!
            {
                let objManagement = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context);
                objManagement.setValue(id, forKey: "id");
                let title:String = managedObject.value(forKey: "title") as! String;
                objManagement.setValue(title, forKey: "title");
                let deadline:Date = managedObject.value(forKey: "deadline") as! Date;
                objManagement.setValue(deadline, forKey: "deadline");
                let category:String = managedObject.value(forKey: "category") as! String;
                objManagement.setValue(category, forKey: "category");
                let color:String = managedObject.value(forKey: "color") as! String;
                objManagement.setValue(color, forKey: "color");
                objManagement.setValue("done", forKey: "status");
                context.delete(managedObject);
                try context.save();
            }
        }catch let error as NSError{
            print("Ocurred a fatal error: \(error.description) ");
        }
    }
}
