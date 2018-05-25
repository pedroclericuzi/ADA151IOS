//
//  SettingsClass.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import UserNotifications
class SettingsClass: Util {
    
    @IBOutlet weak var mySwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.switchOnOff()
        } else {
            self.mySwitch.setOn( pushStatusLowOS(), animated: false)
        }
        //call the screen when back to app again
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func willEnterForeground(){
        if #available(iOS 10.0, *) {
            self.switchOnOff()
        } else {
            self.mySwitch.setOn( pushStatusLowOS(), animated: false)
           
        }
    }
    
    func switchOnOff(){
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .authorized {
                // Notification permission was previously authorized
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "isOnOff")
                    self.mySwitch.setOn(true, animated: false)
                    print("isOnOff: \(UserDefaults.standard.bool(forKey: "isOnOff"))")
                }
            } else {
                // Notification permission was previously denied or notDetermined
                DispatchQueue.main.async {
                    UserDefaults.standard.set(false, forKey: "isOnOff")
                    self.mySwitch.setOn(false, animated: false)
                    print("isOnOff: \(UserDefaults.standard.bool(forKey: "isOnOff"))")
                }
                current.removeAllPendingNotificationRequests()
            }
        })
    }
    
    func pushStatusLowOS() -> Bool {
        guard let currentSettings = UIApplication.shared.currentUserNotificationSettings?.types else { return false }
        return currentSettings.rawValue != 0
    }
    
    @IBAction func myNotifications(_ sender: UISwitch) {
        let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
        UIApplication.shared.open(settingsUrl)
    }
    
    @IBAction func cencel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
