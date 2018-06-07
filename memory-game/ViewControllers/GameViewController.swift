//
//  GameViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit
import CoreData

enum Level: Int {
    case Easy = 3 , Medium = 4, Hard = 5
}

enum ButtonID: String {
    case ButtonEnd = "endGame"
    case ButtonNew = "newGame"
    case ButtonStart = "startGame"
}

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GameLogicDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var clicksLbl: UILabel!
    @IBOutlet weak var newGameBtn: UIButton!
    
    var nameStr = "";
    var level = Level.Easy
    var gameCnt = GameLogic()
    var initGame = true
    var notPaused = true
    
    var timer:Timer?
    var seconds = 0
    var minutes = 0
    var timerStr = "Time: "
    var clicksStr = "Clicks: "
    var clicks = 1
    
    var NumberOfRows = 3
    var NumberOfColumns = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            }
        }
        newGameBtn?.isEnabled = false
        gameCnt.delegate = self
        resetGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if gameCnt.isPlaying {
            resetGame()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupNewGame() {
        let cellsData:[UIImage] = Array(GameLogic.defaultCellImages.prefix(level.rawValue*2))
        gameCnt.newGame(cellsData)
        clicks = 1
        clicksLbl?.text = clicksStr + String(clicks)
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        notPaused = true
    }
    
    func resetGame(){
        gameCnt.stopGame()
        if timer?.isValid == true{
            timer?.invalidate()
            timer = nil
        }
        collectionView.isUserInteractionEnabled = false
        collectionView.reloadData()
        
        playBtn.setTitle(NSLocalizedString("Play", comment: "play"), for: UIControlState())
    }
    
    func pauseGame() {
        gameCnt.pauseGame()
        timer?.invalidate()
    }
    
    func resumeGame() {
        gameCnt.resumeGame()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // save the results to core data
    func saveResults(name:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
//        var HighScore : NSEntityDescription!
//        var temp : NSManagedObjectContext!
////        let highgScore =
//        var newUser: Highscores!
//       let newUser = NSEntityDescription.entity(forEntityName: "User_High_score", in: context)
//       let finalScore = Highscores(entity: newUser!,insertInto: context)
//       finalScore.name = name
//       finalScore.level =  String(self.level.rawValue)
//       finalScore
        let entityName = "User_High_score"
        let uuid = UUID().uuidString
        let newUser = NSEntityDescription.insertNewObject(forEntityName: entityName , into: context)
        newUser.setValue(name, forKey: "name")
        newUser.setValue(self.level.rawValue, forKey: "level")
        newUser.setValue(uuid, forKey: "id")
        newUser.setValue(self.clicks, forKey: "score")
        
        do
        {
            try context.save()
            print ("SAVED")
        } catch{
            print("Failed saving")
        }
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName )
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        do {
            
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
                
            {
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "id") as! String)
                
            }
            
        } catch {
            
            print("Failed")
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4 * level.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! CellViewController
        item.openCell(false, animted: false)
        guard let cell = gameCnt.cellAtIndex(indexPath.item) else { return item }
        item.cell = cell
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! CellViewController
        if item.opened || !notPaused { return }
        gameCnt.didSelectCell(item.cell)
        self.clicksLbl.text! = clicksStr + String(clicks)
        clicks += 1
        collectionView.deselectItem(at: indexPath, animated:true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = collectionView.frame.width / CGFloat(Level.Medium.rawValue) - 12.0
        let itemHeight: CGFloat = collectionView.frame.width / CGFloat(level.rawValue) - 12.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func gameLogicDidStart(_ game: GameLogic) {
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
    }
    
    func gameLogic(_ game: GameLogic, openCells cells: [Cell]) {
        for cell in cells {
            guard let index = gameCnt.indexOfCell(cell) else { continue }
            let itemCell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CellViewController
            itemCell.openCell(true, animted: true)
        }
    }
    
    func gameLogic(_ game: GameLogic, closeCells cells: [Cell]) {
        for cell in cells {
            guard let index = gameCnt.indexOfCell(cell) else { continue }
            let itemCell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CellViewController
            itemCell.openCell(false, animted: true)
        }
    }
    
    
    func gameLogicDidEnd(_ game: GameLogic, elapsedTime: TimeInterval) {
        timer?.invalidate()
        playBtn.setTitle(NSLocalizedString("Play", comment: "play"), for: UIControlState())
        
        let endGameAlert = UIAlertController(
            title: NSLocalizedString("You Win!", comment: "title"),
            message: String(format: "%@ \(Int(elapsedTime)) seconds and \(clicks) clicks", NSLocalizedString("You finished the game in", comment: "message")),
            preferredStyle: .alert)
        
        let saveScore = UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default) { [weak self] (_) in
            let nameTxt = endGameAlert.textFields![0] as UITextField
           // print(nameTxt)
            self?.saveResults(name: nameTxt.text!)
            self?.resetGame()
        }
        saveScore.isEnabled = false
        endGameAlert.addAction(saveScore)
        
        endGameAlert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Your name: \(self.nameStr)?", comment: "your name")
            NotificationCenter.default.addObserver( forName: NSNotification.Name.UITextFieldTextDidChange,
                                                    object: textField,
                                                    queue: OperationQueue.main) {
                                                        (notification) in
                                                        saveScore.isEnabled = textField.text != ""
            }
        }
        
        let cancelSaving = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "dismiss"), style: .cancel) { [weak self] (action) in
            self?.resetGame()
        }
        endGameAlert.addAction(cancelSaving)
        self.present(endGameAlert, animated: true) { }
        playBtn.isEnabled = false
    }
    
    @objc func updateTimer(){
        seconds += 1
        
        if seconds == 60 {
            minutes += 1
            seconds = 0;
        }
        self.timeLbl.text! = timerStr + String(minutes) + " : " + String(seconds)
    }
    
    func initTime(){
        seconds = 0
        minutes = 0
    }
    
    @IBAction func endGamePressed(_ sender: Any) {
        
        if gameCnt.isPlaying {
            if self.notPaused{
                pauseGame()
                playBtn.setTitle(NSLocalizedString("Play", comment: "play"), for: UIControlState())
                notPaused = false
            }
        }
        
        let exitGameAlert = UIAlertController(
            title: NSLocalizedString("Exit", comment: "title"),
            message: String(format: "Are you sure?"),
            preferredStyle: .alert)
        
        let exitOk = UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        exitGameAlert.addAction(exitOk)
        
        let cancelExit = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel"), style: .cancel) { [weak self] (action) in
            if self!.notPaused {
                self?.resumeGame()
                self?.playBtn.setTitle(NSLocalizedString("Pause", comment: "pause"), for: UIControlState())
                self?.notPaused = true
            }
        }
        exitGameAlert.addAction(cancelExit)
        self.present(exitGameAlert, animated: true) { }
        //dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonPressed(_ button: UIButton) {
        if let btnId = ButtonID(rawValue: button.restorationIdentifier!) {
            
            switch btnId {
            case .ButtonNew:
                if timer != nil{
                    timer?.invalidate()
                    initTime()
                }
                setupNewGame()
                playBtn.isEnabled = true
                playBtn.setTitle(NSLocalizedString("Pause", comment: "pause"), for: UIControlState())
            case .ButtonStart:
                if(initGame){
                    newGameBtn?.isEnabled = true
                    setupNewGame()
                    initGame = false
                    playBtn.setTitle(NSLocalizedString("Pause", comment: "pause"), for: UIControlState())
                    return
                }
                if gameCnt.isPlaying {
                    if self.notPaused{
                        pauseGame()
                        playBtn.setTitle(NSLocalizedString("Play", comment: "play"), for: UIControlState())
                        notPaused = false
                    }
                    else{
                        resumeGame()
                        playBtn.setTitle(NSLocalizedString("Pause", comment: "pause"), for: UIControlState())
                        notPaused = true
                    }
                } else {
                    initTime()
                    timer = nil
                }
            case .ButtonEnd:
                break
            }
        }
    }
}
