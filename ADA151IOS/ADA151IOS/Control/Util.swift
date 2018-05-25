//
//  Util.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class Util: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initCoreData() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let context = appDelegate.persistentContainer.viewContext;
        return context;
    }
    
    func dismissSegue (){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: {self.presentedViewController?.viewWillAppear(true)})
    }
    
    func dismissKeyboard() {
        view.endEditing(true);
    }
    //Convert the color's hex in an UIColor
    func convertColor(string:String) -> UIColor {
        var chars = Array(string.hasPrefix("#") ? string.characters.dropFirst() : string.characters)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        switch chars.count {
        case 3:
            chars = [chars[0], chars[0], chars[1], chars[1], chars[2], chars[2]]
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            alpha = 0
        }
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha);
    }
    
    //generate a unique id for save with the tasks
    func generateID() -> String {
        let dateID = Date();
        let formatterID = DateFormatter();
        formatterID.dateFormat = "ddMMyyyyHHmmssa";
        let resultID = formatterID.string(from: dateID);
        return resultID;
    }
    
    func localNotification (deadline:Date, title: String, id:String){
        let calendar = Calendar.current
        let comp2 = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp2, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "\(title)'s deadline"
        content.subtitle = "Did you finished?"
        content.body = "Then, mark as done!"
        
        let request = UNNotificationRequest(
            identifier: "identifier",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("\(error)")
            }
        })
    }
    
    
}
