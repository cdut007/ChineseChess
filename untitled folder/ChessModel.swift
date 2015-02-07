//
//  ChessModel.swift
//  ChnieseChess
//
//  Created by chenjames on 2/1/15.
//  Copyright (c) 2015 chenjames. All rights reserved.
//

import Foundation
import  UIKit

protocol DrawChessProtocol {
    // protocoldefinition goes here
    func drawChessBoard(left:Int,top:Int,witdh:Int,Height:Int)
    
    func loadChessRes()
    
    func drawChess(chessName:String,x:Int,y:Int)
    
    func updateFrame()
    
    func playChessSound()
    
}


class ChessModel{
    
    
    struct ChessModel {
        static let PHASE_LOADING = 0
        static let PHASE_WAITING = 1
        static let PHASE_THINKING = 2
        static let PHASE_EXITTING = 3
        
        static let COMPUTER_BLACK = 0
        static let COMPUTER_RED = 1
        static let COMPUTER_NONE = 2
        
        static let RESP_HUMAN_SINGLE = -2
        static let RESP_HUMAN_BOTH = -1
        static let RESP_MOVE2 = 3
        static let RESP_CAPTURE2 = 5
        static let RESP_CHECK2 = 7
        static let  RS_DATA_LEN = 512
        static  let EMPTY=""
        static let  IMAGE_NAME = [EMPTY, EMPTY, EMPTY, EMPTY, EMPTY,
        EMPTY, EMPTY, EMPTY, "rk", "ra", "rb", "rn", "rr", "rc", "rp", EMPTY,
        "bk", "ba", "bb", "bn", "br", "bc", "bp", EMPTY, ]
    }
    
    
    private var widthBackground=30, heightBackground=30 //flat over bg screen
    
    
    
    var rsData = [Byte](count: ChessModel.RS_DATA_LEN, repeatedValue:0)
    
    var retractData = [Byte](count: ChessModel.RS_DATA_LEN, repeatedValue:0)
    
    private let pos =  Position()
    private var search:Search
    private  var message:String
    private var cursorX=0, cursorY=0
    private var sqSelected=0, mvLast=0
    // Assume FullScreenMode = false
    private var normalWidth:Int
    private var normalHeight:Int
    var drawChessProtocol:DrawChessProtocol
    var phase :Int;
    
    private var initFalg = false
     var squareSize=0
    private var width=0, height=0, left=0, right=0, top=0, bottom=0
   
    
    init(width:Int, height:Int,drawProtocol:DrawChessProtocol) {
        self.width = width
        self.height = height
        self.message = ""
        self.drawChessProtocol = drawProtocol
        search = Search(pos: pos,hashLevel:12)
        phase=ChessModel.PHASE_LOADING
        normalHeight = height
        normalWidth = width
        
    }
    
    var moveMode=0, level=0
    
     func  readBookData() {
        
        var rc4 =  Util.RC4(key: [Byte](count: 1, repeatedValue: 0))
        PositionMark.PreGen_zobristKeyPlayer = rc4.nextLong()
        rc4.nextLong() // Skip ZobristLock0
        PositionMark.PreGen_zobristLockPlayer = rc4.nextLong()
        for (var i = 0; i < 14; i++) {
            for (var j = 0; j < 256; j++) {
                PositionMark.PreGen_zobristKeyTable[i][j] = rc4.nextLong()
                rc4.nextLong(); // Skip ZobristLock0
                PositionMark.PreGen_zobristLockTable[i][j] = rc4.nextLong()
            }
        }
        
        let path = NSBundle.mainBundle().pathForResource("book", ofType: "dat")
        
        var data = NSData(contentsOfMappedFile: path!)
        
        if (data != nil) {
            var bytes:UnsafePointer<Void> = data!.bytes
             var offset = 0
            var intPtr = unsafeBitCast(bytes, UnsafePointer<Byte>.self)
            var cursor:UnsafePointer<Byte> = intPtr
            var data:[Byte]
             var count = PositionMark.bookSize
            while (PositionMark.bookSize < PositionMark.MAX_BOOK_SIZE) {
                data = [Byte](count: 4, repeatedValue: 0)
                cursor = getBytes(cursor, intByte:&data)
                PositionMark.bookLock[PositionMark.bookSize] = Util.readInt(data,offset:0) >> 1
               // offset+=4
                cursor = cursor.successor()
                cursor = getBytes(cursor, intByte:&data)
                data = [Byte](count: 2, repeatedValue: 0)
                PositionMark.bookMove[PositionMark.bookSize] =  Util.readShort(data,offset:0)
               // offset+=2
                cursor = cursor.successor()
                cursor = getBytes(cursor, intByte:&data)
                data = [Byte](count: 2, repeatedValue: 0)
                PositionMark.bookValue[PositionMark.bookSize] = Util.readShort(data,offset:0)
               // offset+=2
               PositionMark.bookSize++
                cursor = cursor.successor()
            }
           var total = PositionMark.bookSize
            
             println("count==\(count),total=\(total)")
        }
        
    }
    
    func  getBytes(data:UnsafePointer<Byte>, inout intByte:[Byte]) -> UnsafePointer<Byte>{
        var count = intByte.count
      var cursor = data
        for index in 0 ..< count{
            intByte[index] = cursor.memory
             cursor = data.successor()
            
        }
    return cursor
    
    }
    
    
    func start(){
           readBookData()
            rsData = [Byte](count: ChessModel.RS_DATA_LEN,repeatedValue: 0)
            rsData[19] = 3;
            rsData[20] = 2;
            
        let  moveMode = Util.MIN_MAX(0, mid:Int(rsData[16]), max:2)
            let handicap = Util.MIN_MAX(0, mid: Int(rsData[17]), max: 3)
            let level = Util.MIN_MAX(0, mid: Int(rsData[18]), max: 2)
            let sound = Util.MIN_MAX(0, mid: Int(rsData[19]), max: 5)
            let music = Util.MIN_MAX(0, mid: Int(rsData[20]), max: 5)
        
            load(&rsData, handicap: handicap, moveMode: moveMode, level: level)
            
        
    }
    
    func load( inout rsData:[Byte],  handicap:Int,  moveMode:Int,  level:Int) {
        self.moveMode = moveMode
        self.level = level
        self.rsData = rsData
        cursorX = 7
        cursorY = 7
        sqSelected = 0
        mvLast = 0
        
        if (rsData[0] == 0) {
            pos.fromFen(PositionMark.STARTUP_FEN[handicap])
        } else {
            // Restore Record-Score Data
            pos.clearBoard()
            for (var sq = 0; sq < 256; sq++) {
                var pc = rsData[sq + 256]
                if (pc > 0) {
                    pos.addPiece(sq,pc:Int(pc))
                }
            }
            if (rsData[0] == 2) {
                pos.changeSide()
            }
            pos.setIrrev()
        }
        // Backup Retract Status
        arraycopy(&rsData, start:0, retractData: &retractData, copyStart:0, len:ChessModel.RS_DATA_LEN)
        // Call "responseMove()" if Computer Moves First
        phase = ChessModel.PHASE_LOADING
        if (pos.sdPlayer == 0 ? moveMode == ChessModel.COMPUTER_RED
            : moveMode == ChessModel.COMPUTER_BLACK) {
                moveThread(nil)
                
        }
    }
    
    
    func searchNextStep()
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if(!self.responseMove()){
                self.rsData[0] = 0
                self.phase = ChessModel.PHASE_EXITTING
            }
        })
        
    }
    
    func moveThread(sender : AnyObject?)
     {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            while (self.phase == ChessModel.PHASE_LOADING) {
                
                sleep(1)
                
            }
            self.responseMove()
        })
        
        
    }
    
    
    func drawChess() {
        if (phase == ChessModel.PHASE_LOADING) {
            // Wait 1 second for resizing
           
            if (!initFalg) {
                initFalg = true
                // "width" and "height" are Full-Screen values
                squareSize = min(width / 9, height / 10)
                
                var boardWidth = squareSize * 9
                var boardHeight = squareSize * 10
                //interface.
                
              
                left = (width - boardWidth) / 2;
                top = (height - boardHeight) / 2;
                right = left + boardWidth - 32;
                bottom = top + boardHeight - 32;
                
                drawChessProtocol.loadChessRes()
            }
            phase = ChessModel.PHASE_WAITING
        }
        var boardHeight = bottom - top + 32
  
        drawChessProtocol.drawChessBoard(left, top: top, witdh: right - left + 32, Height: boardHeight)
        
         //draw
        for (var x = 0; x < width; x += widthBackground) {
            for (var y = 0; y < height; y += heightBackground) {
               // canvas.drawBitmap(imgBackground, x, y, paint);
               // drawChessProtocol.drawChess()
            }
        }
        

        for (var sq = 0; sq < 256; sq++) {
            if (Position.IN_BOARD(sq)) {
                var pc = pos.squares[sq]
                if (pc > 0) {
                   drawSquare(ChessModel.IMAGE_NAME[Int(pc)],sq: sq)
                }
            }
        }
        var sqSrc = 0
        var sqDst = 0
        if (mvLast > 0) {
            sqSrc = Position.SRC(mvLast)
            sqDst = Position.DST(mvLast)
            drawSquare( (pos.squares[sqSrc] & 8) == 0 ? "selected"
                : "selected2", sq: sqSrc)
            drawSquare( (pos.squares[sqDst] & 8) == 0 ? "selected"
                : "selected2", sq: sqDst)
        } else if (sqSelected > 0) {
            drawSquare((pos.squares[sqSelected] & 8) == 0 ? "selected"
                : "selected2", sq: sqSelected)
        }
        var sq = Position.COORD_XY(cursorX + PositionMark.FILE_LEFT, y: cursorY
            + PositionMark.RANK_TOP)
        if (moveMode == ChessModel.COMPUTER_RED) {
            sq = Position.SQUARE_FLIP(sq)
        }
        if (sq == sqSrc || sq == sqDst || sq == sqSelected) {
            drawSquare( (pos.squares[sq] & 8) == 0 ? "cursor2"
                : "cursor", sq: sq)
        } else {
            drawSquare((pos.squares[sq] & 8) == 0 ? "cursor"
                : "cursor2", sq: sq)
        }
        if (phase == ChessModel.PHASE_THINKING) {
            var x=0, y=0
            if (moveMode == ChessModel.COMPUTER_RED) {
                x = (Position.FILE_X(sqDst) < 8 ? left : right)
                y = (Position.RANK_Y(sqDst) < 8 ? top : bottom)
            } else {
                x = (Position.FILE_X(sqDst) < 8 ? right : left)
                y = (Position.RANK_Y(sqDst) < 8 ? bottom : top)
            }
            
        } else if (phase == ChessModel.PHASE_EXITTING) {
            
        }
        
    }
    
    
 
    
    func pointerPressed( x:CGFloat, y:CGFloat) {
        
        if (phase == ChessModel.PHASE_THINKING) {
            return
        }
        cursorX = Util.MIN_MAX(0, mid:(Int(width-Int(x)) - left) / squareSize, max:8)
        cursorY = Util.MIN_MAX(0, mid:(Int(height-Int(y)) - top) / squareSize, max: 9)
        clickSquare()
        invalidate("thouth pressed")
        
    }
    
    private func clickSquare() {
        var sq = Position.COORD_XY(cursorX + PositionMark.FILE_LEFT, y: cursorY
            + PositionMark.RANK_TOP)
        if (moveMode == ChessModel.COMPUTER_RED) {
            sq = Position.SQUARE_FLIP(sq)
        }
        var pc = pos.squares[sq]
        if ((Int(pc) & Position.SIDE_TAG(pos.sdPlayer)) != 0) {
            
            mvLast = 0
            sqSelected = sq
        } else {
            if (sqSelected > 0 && addMove(Position.MOVE(sqSelected, sqDst: sq))) {
                 invalidate("eat chess")
                searchNextStep()
               
            }
        }
    }
    
    private func drawSquare(name:String,sq:Int) {
        
        
        var sqFlipped = (moveMode == ChessModel.COMPUTER_RED ? Position.SQUARE_FLIP(sq)
            : sq);
        var sqX = left + (Position.FILE_X(sqFlipped) - PositionMark.FILE_LEFT)
            * squareSize
        var sqY = top + (Position.RANK_Y(sqFlipped) - PositionMark.RANK_TOP)
            * squareSize
        
        //top/left to  reverse coorid  eg:  1,2->(W -1, H-2)
        drawChessProtocol.drawChess(name,x: width-sqX,y: height-sqY-squareSize)
        
    }
    
    /** Player Move Result */
    private func getResult() ->Bool{
        return getResult(moveMode == ChessModel.COMPUTER_NONE ? ChessModel.RESP_HUMAN_BOTH
            : ChessModel.RESP_HUMAN_SINGLE)
    }
    
    /** Computer Move Result */
    private func getResult( response:Int) ->Bool{
        println("Result")
        if (pos.isMate()) {
            message = (response < 0 ? "win！" : "lose！")
            return true
        }
        var vlRep = pos.repStatus(3)
        if (vlRep > 0) {
            vlRep = (response < 0 ? pos.repValue(vlRep) : -pos.repValue(vlRep))
            message = (vlRep > PositionMark.WIN_VALUE ? "want to kill king ?"
                : vlRep < -PositionMark.WIN_VALUE ? "win！"
                : "end！")
            return true;
        }
        if (pos.moveNum > 100) {
            message = "end！"
            return true
        }
        if (response != ChessModel.RESP_HUMAN_SINGLE) {
            if (response >= 0) {
            }
            // Backup Retract Status
            
            arraycopy(&rsData, start: 0, retractData: &retractData, copyStart: 0, len: ChessModel.RS_DATA_LEN)
            // Backup Record-Score Data
            rsData[0] = Byte (pos.sdPlayer + 1)
            arraycopy(&pos.squares, start: 0, retractData: &rsData, copyStart: 256, len: 256)
           
        }
        return false
    }
    
    
    func arraycopy(inout rsData:[Byte],start:Int,inout retractData:[Byte],copyStart:Int,len:Int){
          var begin = start
        for index in copyStart ..< len{
            retractData[index] = rsData[begin]
            begin++
        }
    
    }
    
    private func addMove( mv:Int) ->Bool{
        if (pos.legalMove(mv)) {
            if (pos.makeMove(mv)) {
                if (pos.captured()) {
                    pos.setIrrev()
                }
                sqSelected = 0
                mvLast = mv
                return true
            }
        }
        return false
    }
    
    func responseMove()->Bool {
        if (getResult()) {
            return false
        }
        if (moveMode == ChessModel.COMPUTER_NONE) {
            return true
        }
        phase = ChessModel.PHASE_THINKING
        invalidate("before thinking")
        
        mvLast = search.searchMain(1000 << (level << 1))
        pos.makeMove(mvLast)
        var response = pos.inCheck() ? ChessModel.RESP_CHECK2
            : pos.captured() ? ChessModel.RESP_CAPTURE2 : ChessModel.RESP_MOVE2
        if (pos.captured()) {
            pos.setIrrev()
        }
        phase = ChessModel.PHASE_WAITING
        invalidate("waiting ressponse")
        
        return !getResult(response)
    }
    
    func invalidate( fromwhere:String) {
        // TODO Auto-generated method stub
        drawChessProtocol.updateFrame()
        println(fromwhere)
        
    }
    
    func back() {
        if (phase == ChessModel.PHASE_WAITING) {
        } else {
            rsData[0] = 0
        }
    }
    
    func retract( handicap :Int) {
        // Restore Retract Status
        arraycopy(&retractData, start: 0, retractData: &rsData, copyStart: 0, len: ChessModel.RS_DATA_LEN)
        load(&rsData, handicap: handicap, moveMode: moveMode, level: level)
        invalidate("retract")
        
    }
    
    func about() {
     phase = ChessModel.PHASE_LOADING
    }
    
    
}