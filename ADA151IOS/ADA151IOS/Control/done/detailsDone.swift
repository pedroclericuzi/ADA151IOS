//
//  detailsDone.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 25/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

class detailsDone: Util {
    
    @IBOutlet weak var titleDoneDetails: UILabel!
    @IBOutlet weak var deadlineDoneDetails: UILabel!
    @IBOutlet weak var categoryDoneDetails: UILabel!
    @IBOutlet weak var colorDoneDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleDoneDetails.text = doneTitleTask[indexAvailable]
        let deadlineSplit = doneDeadlineTask[indexAvailable].components(separatedBy: " ")
        deadlineDoneDetails.text = ("\(deadlineSplit[1])")
        categoryDoneDetails.text = doneCategoryTask[indexAvailable]
        colorDoneDetails.text = doneColorTask[indexAvailable]
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btDelete(_ sender: Any) {
        let modelTask:ModelTask = ModelTask()
        modelTask.deleteTask(id: doneIdTask[indexDone])
        doneIdTask.remove(at: indexDone);
        doneTitleTask.remove(at: indexDone);
        doneDeadlineTask.remove(at: indexDone);
        doneHexTask.remove(at: indexDone);
        doneColorTask.remove(at: indexDone);
        self.dismissSegue()
    }
}
