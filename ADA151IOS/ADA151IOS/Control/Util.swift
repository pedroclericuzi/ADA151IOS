//
//  Util.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import CoreData
//This class
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

    //method to call other storyboard
//    @objc func otherScreen(screen:String){
//        let story = UIStoryboard(name: screen, bundle: nil);
//        let myView = story.instantiateViewController(withIdentifier: screen) as? UIViewController;
//        self.present(myView!, animated:true , completion: nil);
//    }
    
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
    //Get the name of color and set the hex
    func colorNameToHex(color:String) -> String {
        let arrColor = self.listColor();
        var strReturn:String!;
        for search in arrColor{
            //print(search);
            if(search.key==color){
                strReturn = search.value;
            }
        }
        return strReturn;
    }
    //List that contains the colors and yours hex used
    func listColor() -> DictionaryLiteral<String, String> {
        let arrColor = ["light green":"#C6DA02", "green":"#79A700",
                        "orange":"#F68B2C", "gold":"#E2B400",
                        "red":"#F5522D", "pink":"#F5522D"] as DictionaryLiteral<String,String>;
        return arrColor;
    }
    
    //generate a unique id for save with the tasks
    func generateID() -> String {
        let dateID = Date();
        let formatterID = DateFormatter();
        formatterID.dateFormat = "ddMMyyyyHHmmssa";
        let resultID = formatterID.string(from: dateID);
        return resultID;
    }
    
    //delete the user default with the user id
    func deleteUserDefault() {
        let prefs = UserDefaults.standard;
        prefs.removeObject(forKey: "idTask")
    }
}
