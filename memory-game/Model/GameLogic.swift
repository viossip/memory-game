//
//  GameLogic.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol GameLogicDelegate {
    func gameLogic(_ game: GameLogic, openCells cells: [Cell])
    func gameLogic(_ game: GameLogic, closeCells cells: [Cell])
    func gameLogicDidStart(_ game: GameLogic)
    func gameLogicDidEnd(_ game: GameLogic, elapsedTime: TimeInterval)
}

class  GameLogic{
    
    var delegate: GameLogicDelegate?
    var cells:[Cell] = [Cell]()
    var isPlaying: Bool = false
    var isPaused: Bool = false
    
    fileprivate var cellsOpened:[Cell] = [Cell]()
    fileprivate var startGameTime:Date?
    fileprivate var startPauseTime:Date?
    
    static var defaultCellImages:[UIImage] = [
        UIImage(named: "mem1")!, UIImage(named: "mem2")!, UIImage(named: "mem3")!,
        UIImage(named: "mem4")!, UIImage(named: "mem5")!, UIImage(named: "mem6")!,
        UIImage(named: "mem7")!, UIImage(named: "mem8")!, UIImage(named: "mem9")!,
        UIImage(named: "mem10")!
    ];
    
    var numberOfCells: Int {
        get {
            return cells.count
        }
    }
    
    var elapsedTime : TimeInterval {
        get {
            guard startGameTime != nil else { return -1 }
            return Date().timeIntervalSince(startGameTime!)
        }
    }
    
    var pausedTime : TimeInterval {
        get {
            guard startPauseTime != nil else { return -1 }
            return Date().timeIntervalSince(startPauseTime!)
        }
    }
    
    var totalPaused : TimeInterval = 0.0
    
    func newGame(_ cellsData:[UIImage]) {
        isPlaying = true
        isPaused = false; // TODO:
        cells = randomCells(cellsData)
        delegate?.gameLogicDidStart(self)
        startGameTime = Date.init()
    }
    
    func stopGame() {
        isPlaying = false
        cells.removeAll()
        cellsOpened.removeAll()
        startGameTime = nil
    }
    
    func pauseGame() {
        // TODO: Implement
        isPaused = true;
        startPauseTime = Date.init()
        
    }
    
    func resumeGame() {
        // TODO: Implement
        isPaused = false;
        totalPaused += pausedTime
    }
    
    func didSelectCell(_ cell: Cell?) {
        guard let cell = cell else { return }
        
        delegate?.gameLogic(self, openCells: [cell])
        
        if unpairedCellShown() {
            let unpaired = unpairedCell()!
            if cell.equals(unpaired) {
                cellsOpened.append(cell)
            } else {
                
                let unpairedCell = cellsOpened.removeLast()
                
                let delayTime = DispatchTime.now() + Double( Int64( 1 * Double(NSEC_PER_SEC ))) / Double( NSEC_PER_SEC )
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.delegate?.gameLogic(self, closeCells:[cell, unpairedCell])
                }
            }
        } else {
            cellsOpened.append(cell)
        }
        
        if cellsOpened.count == cells.count {
            finishGame()
        }
    }
    
    fileprivate func finishGame() {
        isPlaying = false
        //elapsedTime = elapsedTime - totalPaused
        delegate?.gameLogicDidEnd(self, elapsedTime: elapsedTime - totalPaused)
    }
    
    fileprivate func unpairedCell() -> Cell? {
        let unpairedCell = cellsOpened.last
        return unpairedCell
    }
    
    fileprivate func unpairedCellShown() -> Bool {
        return cellsOpened.count % 2 != 0
    }
    
    func cellAtIndex(_ index: Int) -> Cell? {
        if cells.count > index { return cells[index] }
        else { return nil }
    }
    
    func indexOfCell(_ cell: Cell) -> Int? {
        for index in 0...cells.count-1 {
            if cell === cells[index] {
                return index
            }
        }
        return nil
    }
    
    fileprivate func randomCells(_ cellsData:[UIImage]) -> [Cell] {
        var cells = [Cell]()
        for i in 0...cellsData.count - 1 {
            let cell = Cell.init(image: cellsData[i])
            cells.append(contentsOf: [cell, Cell.init( cell: cell ) ])
        }
        cells.shuffle()
        return cells
    }
}
