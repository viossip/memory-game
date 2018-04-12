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
    
    
    var level = Level.Easy
    var gameCnt = GameLogic()
    var timer:Timer?
    let TileMargin = CGFloat(5.0)
    
    var NumberOfRows = 3
    var NumberOfColumns = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            }
        }
        
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
        let cellsData:[UIImage] = GameLogic.defaultCellImages
        gameCnt.newGame(cellsData)
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
        //  TODO: Implement
        //playBtn.setTitle(NSLocalizedString("Play", comment: "play"), for: UIControlState())
    }
    
    func resumeGame() {
        gameCnt.resumeGame()
        //  TODO: Implement
        //playBtn.setTitle(NSLocalizedString("Play", comment: "play"), for: UIControlState())
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
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
        if item.opened { return }
        gameCnt.didSelectCell(item.cell)
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = collectionView.frame.width / 4.0 - 15.0
        return CGSize(width: itemWidth, height: itemWidth)
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
        
        //  TODO: Save results
    }
    
    
    @objc func buttonPressed(_ button: UIButton) {
        if let btnId = ButtonID(rawValue: button.restorationIdentifier!) {
            
            switch btnId {
            case .ButtonNew:
                setupNewGame()
                playBtn.setTitle(NSLocalizedString("Pause", comment: "pause"), for: UIControlState())
            case .ButtonEnd:
                dismiss(animated: true, completion: nil)
            case .ButtonStart:
                if gameCnt.isPlaying {
                    pauseGame()
                    playBtn.setTitle(NSLocalizedString("Play", comment: "play"), for: UIControlState())
                } else {
                    resumeGame()
                    playBtn.setTitle(NSLocalizedString("Pause", comment: "pause"), for: UIControlState())
                }
            }
        }
    }
}
