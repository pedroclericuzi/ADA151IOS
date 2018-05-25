//
//  detailsTask.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 24/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

class detailsTask: Util {

    @IBOutlet weak var tilte: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var color: UILabel!
    
    let modelTask:ModelTask = ModelTask()
    let modelColor: ModelColor = ModelColor();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tilte.text = avTitleTask[indexAvailable]
        let deadlineSplit = avDeadlineTask[indexAvailable].components(separatedBy: " ")
        deadline.text = ("\(deadlineSplit[1])")
        category.text = avCategoryTask[indexAvailable]
        color.text = avColorTask[indexAvailable]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btDelete(_ sender: Any) {
        modelTask.deleteTask(id: avIdTask[indexAvailable])
        avIdTask.remove(at: indexAvailable);
        avTitleTask.remove(at: indexAvailable);
        avDeadlineTask.remove(at: indexAvailable);
        avHexTask.remove(at: indexAvailable);
        avColorTask.remove(at: indexAvailable);
        self.dismissSegue()
    }
}
