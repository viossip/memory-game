//
//  HighscorsViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit
import CoreData

class HighscorsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    enum ButtonID: String {
        case ButtonEasy = "easy"
        case ButtonHard = "hard"
        case ButtonMedium = "medium"
    }
    
    @IBOutlet weak var table1: UITableView!
    
    var someInts : [Highscores] = []
    var displayByLevel = 3
    var recordsToDisplay : [Highscores] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        table1.delegate = self
        table1.dataSource = self
        
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            }
        }
        
        let entityName = "User_High_score"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context1 = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName )

        request.returnsObjectsAsFaults = false

        do {
            let result = try context1.fetch(request)
            if result.count > 0
            {
                for data in result as! [NSManagedObject]
                {
                    let name =  data.value(forKey: "name")
                    let id = data.value(forKey: "id")
                    let level = data.value(forKey: "level")
                    let score = data.value(forKey: "score")
                    let time = data.value(forKey: "time")
                    
                    let tempClass = Highscores(insertInto :context1,id:id as! String,name:name as! String,myLevel:level as! String ,score:score as! String,time:time as! String,entityName:entityName)
                    someInts.append(tempClass)
                    if tempClass.myLevel == String(displayByLevel){
                        recordsToDisplay.append(tempClass)
                    }
                }
                recordsToDisplay = recordsToDisplay.sorted(by: { $0.score < $1.score })
            }
            
        } catch {
            print("Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recordsToDisplay.count < 10{
            return recordsToDisplay.count
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:"cell")
        
        let formatted = String(format: "%@ : %@",recordsToDisplay[indexPath.row].name, recordsToDisplay[indexPath.row].score)
        cell.textLabel?.text = formatted

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func returnBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func buttonPressed(_ button: UIButton) {
            
        if let btnId = ButtonID(rawValue: button.restorationIdentifier!) {
            recordsToDisplay.removeAll()
            
            switch btnId {
            case .ButtonEasy:
                self.displayByLevel = 3
            case .ButtonMedium:
                self.displayByLevel = 4
            case .ButtonHard:
                self.displayByLevel = 5
            }
            
            for element in someInts {
                if element.myLevel == String(displayByLevel){
                    recordsToDisplay.append(element)
                }
            }
            recordsToDisplay = recordsToDisplay.sorted(by: { $0.score < $1.score })
            table1.reloadData()
        }
    }
}
