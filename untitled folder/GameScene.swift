//
//  GameScene.swift
//  ChnieseChess
//
//  Created by chenjames on 1/30/15.
//  Copyright (c) 2015 chenjames. All rights reserved.
//

import SpriteKit

class GameScene: SKScene , DrawChessProtocol{
    
    
    func playChessSound(){
    
    }
    
    
    func drawChessBoard(left:Int,top:Int,witdh:Int,Height:Int){
        let location = CGPoint(x: left, y:top)
        println("chessBorad:positon:\(left),\(top);Size:(\(witdh),\(Height))")
        let sprite = SKSpriteNode(imageNamed:"board")
        
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        sprite.size.height = CGFloat(Height)
        sprite.size.width = CGFloat(witdh)
        sprite.position = location
        self.addChild(sprite)
    }
    
    func loadChessRes(){
        
    }
    
    func drawChess(name:String,x:Int ,y:Int){
        
        let location = CGPoint(x: x, y: y)
        
        let sprite = SKSpriteNode(imageNamed:name)
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
         sprite.anchorPoint = CGPoint(x: 1, y: 0)
        sprite.size.height = CGFloat(chessModel!.squareSize)
        sprite.size.width = CGFloat(chessModel!.squareSize)
        sprite.position = location
        self.addChild(sprite)
       
        
    }
    var i=0
    func updateFrame(){
        dispatch_async(dispatch_get_main_queue(), {
            self.removeAllChildren()
            self.chessModel!.drawChess()
        })
       
        i++
    }
    var chessModel:ChessModel?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
      
         chessModel = ChessModel(width: Int(self.frame.size.width), height: Int(frame.size.height), drawProtocol: self)
        chessModel!.start()
        updateFrame()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            chessModel!.pointerPressed(location.x,y:location.y)
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
  
    
    func setupMsgLabel(isWon won: Bool) {
        var msg: String = won ? "Yow Won!" : "You Lose :["
        
        var msgLabel = SKLabelNode(fontNamed: "Chalkduster")
        msgLabel.text = msg
        msgLabel.fontSize = 40
        msgLabel.fontColor = SKColor.blackColor()
        msgLabel.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(msgLabel)
    }
    
   
    
    
}
