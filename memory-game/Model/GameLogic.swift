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
    
    fileprivate var cellsOpened:[Cell] = [Cell]()
    fileprivate var startTime:Date?
    
    static var defaultCellImages:[UIImage] = [
        UIImage(named: "mem1")!,
        UIImage(named: "mem2")!,
        UIImage(named: "mem3")!,
        UIImage(named: "mem4")!,
        UIImage(named: "mem5")!,
        UIImage(named: "mem6")!,
        UIImage(named: "mem7")!,
        UIImage(named: "mem8")!
    ];
    
    var numberOfCells: Int {
        get {
            return cells.count
        }
    }
    
    var elapsedTime : TimeInterval {
        get {
            guard startTime != nil else { return -1 }
            return Date().timeIntervalSince(startTime!)
        }
    }
    
    func newGame(_ cellsData:[UIImage]) {
        isPlaying = true
        cells = randomCells(cellsData)
        delegate?.gameLogicDidStart(self)
        startTime = Date.init()
    }
    
    func stopGame() {
        isPlaying = false
        cells.removeAll()
        cellsOpened.removeAll()
        startTime = nil
    }
    
    func pauseGame() {
        // TODO: Implement
    }
    
    func resumeGame() {
        // TODO: Implement
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
        delegate?.gameLogicDidEnd(self, elapsedTime: elapsedTime)
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
