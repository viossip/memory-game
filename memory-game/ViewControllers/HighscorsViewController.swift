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
    
    @IBOutlet weak var table1: UITableView!
    
    @IBOutlet weak var table2: UITableView!
    
    var someInts : [Highscores] = []
//    var database = MainViewController()
    
//    public override  NumberOfSections (UITableView tableView)
//{
//    return 1;
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        table1.delegate = self
        table1.dataSource = self
        table2.delegate = self
        table2.dataSource = self
        let entityName = "User_High_score"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context1 = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName )
        //request.predicate = NSPredicate(format: "age = %@", "12")

        request.returnsObjectsAsFaults = false

        do {


            let result = try context1.fetch(request)
            if result.count>0
            {
                for data in result as! [NSManagedObject]
                {
                    let name =  data.value(forKey: "name")
                    let id = data.value(forKey: "id")
                    let level = data.value(forKey: "level")
                    let score = data.value(forKey: "score")
                    let time = data.value(forKey: "time")
                    var tempClass = Highscores(insertInto :context1,id:id as! String,name:name as! String,myLevel:level as! String ,score:score as! String,time:time as! String,entityName:entityName)
                    someInts.append(tempClass)
                    someInts = someInts.sorted(by: { $0.score < $1.score })
                    
                    
                    
                   
                

                }
            }

        } catch {

            print("Failed")
        }


        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =     UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:"cell")
        
        
        if (tableView.tag == 1){
            for text in someInts{
                cell.textLabel?.text = text.name
            }
        }
        if (tableView.tag == 2){
            for score in someInts {
                cell.textLabel?.text = score.score
            }
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func returnBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
