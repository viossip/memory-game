//
//  GameViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

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
    
    func resetGame() {
        gameCnt.stopGame()
        if timer?.isValid == true {
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
        print("-----------------\( elapsedTime)")
        //  TODO: Save results
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
    
    
    @objc func buttonPressed(_ button: UIButton) {
        if let btnId = ButtonID(rawValue: button.restorationIdentifier!) {
            
            switch btnId {
            case .ButtonNew:
                if timer != nil{
                    timer?.invalidate()
                    initTime()
                }
                setupNewGame()
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
                    
                }
            case .ButtonEnd:
//                if let navController = self.navigationController {
//                    navController.popViewController(animated: true)
//                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
