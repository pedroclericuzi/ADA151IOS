//
//  DoneTab.swift
//  ADA151IOS
//
//  Created by Pedro Clericuzi on 23/05/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

class DoneTab: Util, UITableViewDataSource, UITableViewDelegate {
    let idCell:String = "CellDone";
    var arr:[String] = ["Teste 4", "Teste 5", "Teste 6"]
    var arrDate:[String] = ["05/05/1995", "05/05/1995", "05/05/1995"]
    var arrColor:[String] = ["#000000", "#79A700", "#E2B400"]
    @IBOutlet weak var listDone: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Reloading the datas
        self.listDone.reloadData();
        // Do any additional setup after loading the view.
        let xib = UINib(nibName: "taskCell", bundle: nil)
        listDone.register(xib, forCellReuseIdentifier: idCell)
        listDone.dataSource = self;
        listDone.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(arr.count)")
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskCell = listDone.dequeueReusableCell(withIdentifier: idCell) as! TaskCell
        
        cell.labelTask.text = arr[indexPath.row]
        cell.labelDate.text = arrDate[indexPath.row]
        cell.viewCategory!.layer.cornerRadius = 12.5;
        cell.viewCategory!.clipsToBounds = true;
        cell.viewCategory!.backgroundColor = self.convertColor(string: arrColor[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
