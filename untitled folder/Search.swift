//
//  Search.swift
//  ChnieseChess
//
//  Created by chenjames on 1/31/15.
//  Copyright (c) 2015 chenjames. All rights reserved.
//

import Foundation

struct HashItem {
    var depth:Byte=0, flag:Byte=0
    var  vl:Int=0
    var mv:Int=0, zobristLock:Int=0
    
}
struct SearchContanst {
    static let  HASH_ALPHA = 1
    static let  HASH_BETA = 2
    static let  HASH_PV = 3
    static let  LIMIT_DEPTH = 64
    static let  NULL_DEPTH = 2
    static let  RANDOM_MASK = 7
    static let  MAX_GEN_MOVES = PositionMark.MAX_GEN_MOVES
    static let  MATE_VALUE = PositionMark.MATE_VALUE
    static let  BAN_VALUE = PositionMark.BAN_VALUE
    static let  WIN_VALUE = PositionMark.WIN_VALUE
}




public class Search{
    
    private var hashMask:Int, mvResult:Int, allNodes:Int, allMillis:Int
    private var hashTable:[HashItem]
    public var pos:Position
    var historyTable = [Int](count: 4096, repeatedValue: 0)
    var mvKiller = [[Int]](count: SearchContanst.LIMIT_DEPTH, repeatedValue: Array(count: 2, repeatedValue: 0))
    
    init( pos:Position,  hashLevel:Int) {
        self.pos = pos;
        hashMask = (1 << hashLevel) - 1
        hashTable =  [HashItem]()
        for (var i = 0; i <= hashMask; i++) {
            hashTable.append(HashItem())
        }
        mvResult=0
        allNodes=0
        allMillis=0
    }
    
    private  func getHashItem()->HashItem {
        return hashTable[pos.zobristKey & hashMask]
    }
    
    private func probeHash( vlAlpha:Int, vlBeta:Int,  depth:Int,  inout mv:[Int]) ->Int {
        var hash = getHashItem()
        if (hash.zobristLock != pos.zobristLock) {
            mv[0] = 0;
            return -SearchContanst.MATE_VALUE;
        }
        mv[0] = hash.mv
        var mate = false
        if (hash.vl > SearchContanst.WIN_VALUE) {
            if (hash.vl <= SearchContanst.BAN_VALUE) {
                return -SearchContanst.MATE_VALUE;
            }
            hash.vl -= pos.distance;
            mate = true;
        } else if (hash.vl < -SearchContanst.WIN_VALUE) {
            if (hash.vl >= -SearchContanst.BAN_VALUE) {
                return -SearchContanst.MATE_VALUE;
            }
            hash.vl += pos.distance;
            mate = true;
        } else if (hash.vl == pos.drawValue()) {
            return -SearchContanst.MATE_VALUE;
        }
        if (Int(hash.depth) >= depth || mate) {
            if (Int(hash.flag) == SearchContanst.HASH_BETA) {
                return (hash.vl >= vlBeta ? hash.vl : -SearchContanst.MATE_VALUE);
            } else if (Int(hash.flag) == SearchContanst.HASH_ALPHA) {
                return (hash.vl <= vlAlpha ? hash.vl : -SearchContanst.MATE_VALUE);
            }
            return hash.vl;
        }
        return -SearchContanst.MATE_VALUE;
    }
    
    private func recordHash( flag:Int,  vl:Int,  depth:Int,  mv:Int) {
        var hash = getHashItem()
        if (Int(hash.depth) > depth) {
            
            return
        }
        
        hash.flag = Byte(flag)
        hash.depth = Byte(depth)
        
        if (vl > SearchContanst.WIN_VALUE) {
            if (mv == 0 && vl <= SearchContanst.BAN_VALUE) {
                
                return;
            }
            
            hash.vl = Int (vl + pos.distance)
            
        } else if (vl < -SearchContanst.WIN_VALUE) {
            if (mv == 0 && vl >= -SearchContanst.BAN_VALUE) {
                
                return;
                
            }
            hash.vl = Int (vl - pos.distance)
            
        } else if (vl == pos.drawValue() && mv == 0) {
            
            return;
            
        } else {
            hash.vl = Int(vl);
        }
        hash.mv = mv;
        hash.zobristLock = pos.zobristLock;
    }
    
    private class SortItem {
        let PHASE_HASH = 0
        let PHASE_KILLER_1 = 1
        let PHASE_KILLER_2 = 2
        let PHASE_GEN_MOVES = 3
        let PHASE_REST = 4
        
        private var index:Int, moves:Int, phase:Int
        private var mvHash:Int, mvKiller1:Int, mvKiller2:Int
        private var mvs:[Int], vls:[Int]
        
        var singleReply = false
        var search :Search
        init( mvHash:Int,mSearch:Search) {
            self.index=0
            self.moves=0
            self.phase=0
            self.mvs = [Int](count: SearchContanst.MAX_GEN_MOVES, repeatedValue: 0)
            self.vls = [Int](count: SearchContanst.MAX_GEN_MOVES, repeatedValue: 0)
            
            self.search = mSearch
            if (!search.pos.inCheck()) {
                phase = PHASE_HASH
                self.mvHash = mvHash
                mvKiller1 = search.mvKiller[search.pos.distance][0]
                mvKiller2 = search.mvKiller[search.pos.distance][1]
                return
            }
            
            phase = PHASE_REST
            self.mvHash = 0
            self.mvKiller1 = 0
            self.mvKiller2 = 0
            
            moves = 0
            var mvsAll =  [Int](count: SearchContanst.MAX_GEN_MOVES, repeatedValue: 0)
            var numAll = search.pos.generateAllMoves(&mvsAll)
            for (var i = 0; i < numAll; i++) {
                var mv = mvsAll[i];
                if (!search.pos.makeMove(mv)) {
                    continue;
                }
                search.pos.undoMakeMove();
                mvs[moves] = mv;
                vls[moves] = mv == mvHash ? Int.max : search.historyTable[search.pos.historyIndex(mv)];
                moves++
            }
            Util.shellSort(&mvs, vls: &vls, from: 0, to: moves)
            
            singleReply = moves == 1
        }
        
        func next() -> Int {
            if (phase == PHASE_HASH) {
                phase = PHASE_KILLER_1
                if (mvHash > 0) {
                    return mvHash
                }
            }
            if (phase == PHASE_KILLER_1) {
                phase = PHASE_KILLER_2;
                if (mvKiller1 != mvHash && mvKiller1 > 0 && search.pos.legalMove(mvKiller1)) {
                    return mvKiller1
                }
            }
            if (phase == PHASE_KILLER_2) {
                phase = PHASE_GEN_MOVES;
                if (mvKiller2 != mvHash && mvKiller2 > 0 && search.pos.legalMove(mvKiller2)) {
                    return mvKiller2
                }
            }
            if (phase == PHASE_GEN_MOVES) {
                phase = PHASE_REST
                mvs = [Int](count: SearchContanst.MAX_GEN_MOVES, repeatedValue: 0)
                vls = [Int](count: SearchContanst.MAX_GEN_MOVES, repeatedValue: 0)
                moves = search.pos.generateAllMoves(&mvs)
                for (var i = 0; i < moves; i++) {
                    vls[i] = search.historyTable[search.pos.historyIndex(mvs[i])]
                }
                Util.shellSort(&mvs, vls: &vls, from: 0, to: moves)
                index = 0
            }
            while (index < moves) {
                var mv = mvs[index]
                index++
                if (mv != mvHash && mv != mvKiller1 && mv != mvKiller2) {
                    return mv
                }
            }
            return 0
        }
    }
    
    private func setBestMove( mv:Int,  depth:Int) {
        historyTable[pos.historyIndex(mv)] += depth * depth
        var killers = mvKiller[pos.distance]
        if (killers[0] != mv) {
            killers[1] = killers[0]
            killers[0] = mv
        }
    }
    
    private func searchQuiesc( vlAlpha_:Int,  vlBeta:Int) ->Int {
        var vlAlpha = vlAlpha_
        allNodes++
        var vl = pos.mateValue()
        if (vl >= vlBeta) {
            return vl
        }
        var vlRep = pos.repStatus()
        if (vlRep > 0) {
            return pos.repValue(vlRep)
        }
        if (pos.distance == SearchContanst.LIMIT_DEPTH) {
            return pos.evaluate()
        }
        var vlBest = -SearchContanst.MATE_VALUE
        var genMoves=0
        var mvs = [Int](count: SearchContanst.MAX_GEN_MOVES, repeatedValue: 0)
        if (pos.inCheck()) {
            genMoves = pos.generateAllMoves(&mvs);
            var vls = [Int](count: SearchContanst.MAX_GEN_MOVES, repeatedValue: 0)
            for (var i = 0; i < genMoves; i++) {
                vls[i] = historyTable[pos.historyIndex(mvs[i])]
            }
            Util.shellSort(&mvs, vls: &vls, from: 0, to: genMoves)
        } else {
            vl = pos.evaluate()
            if (vl > vlBest) {
                if (vl >= vlBeta) {
                    return vl
                }
                vlBest = vl
                vlAlpha = max(vl, vlAlpha)
            }
            var vls = [Int](count: SearchContanst.MAX_GEN_MOVES, repeatedValue: 0)
            genMoves = pos.generateMoves(&mvs, vls: &vls,option:false)
            Util.shellSort(&mvs, vls: &vls, from: 0, to: genMoves)
            for (var i = 0; i < genMoves; i++) {
                if (vls[i] < 10 || (vls[i] < 20 && Position.HOME_HALF(Position.DST(mvs[i]), sd: pos.sdPlayer))) {
                    genMoves = i
                    break
                }
            }
        }
        for (var i = 0; i < genMoves; i++) {
            if (!pos.makeMove(mvs[i])) {
                continue;
            }
            vl = -searchQuiesc(-vlBeta, vlBeta: -vlAlpha)
            pos.undoMakeMove()
            if (vl > vlBest) {
                if (vl >= vlBeta) {
                    return vl
                }
                vlBest = vl
                vlAlpha = max(vl, vlAlpha)
            }
        }
        return vlBest == -SearchContanst.MATE_VALUE ? pos.mateValue() : vlBest;
    }
    
    private func searchNoNull(vlAlpha:Int,  vlBeta:Int, depth:Int) ->Int {
        return searchFull(vlAlpha, vlBeta: vlBeta, depth: depth, noNull: true)
    }
    
    private func searchFull(vlAlpha:Int, vlBeta:Int, depth:Int) ->Int{
        return searchFull(vlAlpha, vlBeta: vlBeta, depth: depth, noNull: false)
    }
    
    private func searchFull( vlAlpha_:Int , vlBeta:Int,  depth:Int,  noNull:Bool) ->Int{
        var vlAlpha = vlAlpha_
        var vl=0
        
        if (depth <= 0) {
            return searchQuiesc(vlAlpha, vlBeta: vlBeta)
        }
        allNodes++
        
        vl = pos.mateValue()
        if (vl >= vlBeta) {
            return vl
        }
        var vlRep = pos.repStatus()
        if (vlRep > 0) {
            return pos.repValue(vlRep)
        }
        var mvHash =  [Int](count: 1, repeatedValue: 0)
        vl = probeHash(vlAlpha, vlBeta: vlBeta, depth: depth, mv: &mvHash)
        if (vl > -SearchContanst.MATE_VALUE) {
            return vl
        }
        if (pos.distance == SearchContanst.LIMIT_DEPTH) {
            return pos.evaluate()
        }
        if (!noNull && !pos.inCheck() && pos.nullOkay()) {
            pos.nullMove()
            vl = -searchNoNull(-vlBeta, vlBeta: 1 - vlBeta, depth: depth - SearchContanst.NULL_DEPTH - 1)
            pos.undoNullMove()
            
            if (vl >= vlBeta && (pos.nullSafe() || searchNoNull(vlAlpha, vlBeta: vlBeta, depth: depth - SearchContanst.NULL_DEPTH) >= vlBeta)) {
                return vl
            }
        }
        var hashFlag = SearchContanst.HASH_ALPHA
        var vlBest = -SearchContanst.MATE_VALUE
        var mvBest = 0
        var sort =  SortItem(mvHash: mvHash[0],mSearch: self)
        
        var mv = sort.next()
        
        while (mv > 0) {
            if (!pos.makeMove(mv)) {
                mv = sort.next()
                continue
            }
            var newDepth = pos.inCheck() || sort.singleReply ? depth : depth - 1;
            if (vlBest == -SearchContanst.MATE_VALUE) {
                vl = -searchFull(-vlBeta, vlBeta: -vlAlpha, depth: newDepth);
            } else {
                vl = -searchFull(-vlAlpha - 1, vlBeta: -vlAlpha, depth: newDepth);
                if (vl > vlAlpha && vl < vlBeta) {
                    vl = -searchFull(-vlBeta, vlBeta: -vlAlpha, depth: newDepth);
                }
            }
            pos.undoMakeMove()
            if (vl > vlBest) {
                vlBest = vl;
                if (vl >= vlBeta) {
                    hashFlag = SearchContanst.HASH_BETA
                    mvBest = mv
                    break;
                }
                if (vl > vlAlpha) {
                    vlAlpha = vl
                    hashFlag = SearchContanst.HASH_PV
                    mvBest = mv
                }
            }
            mv = sort.next()
        }
        
        if (vlBest == -SearchContanst.MATE_VALUE) {
            return pos.mateValue();
        }
        recordHash(hashFlag, vl: vlBest, depth: depth, mv: mvBest);
        if (mvBest > 0) {
            setBestMove(mvBest, depth: depth);
        }
        return vlBest;
    }
    
    private func searchRoot( depth:Int) ->Int{
        var vlBest = -SearchContanst.MATE_VALUE
        var sort =  SortItem(mvHash: mvResult,mSearch:self)
        var mv=sort.next()
        
        
        while (mv > 0) {
            if (!pos.makeMove(mv)) {
                mv = sort.next()
                continue
            }
            var newDepth = pos.inCheck() ? depth : depth - 1;
            var vl=0
            if (vlBest == -SearchContanst.MATE_VALUE) {
                vl = -searchNoNull(-SearchContanst.MATE_VALUE, vlBeta: SearchContanst.MATE_VALUE, depth: newDepth);
            } else {
                vl = -searchFull(-vlBest - 1, vlBeta: -vlBest, depth: newDepth);
                if (vl > vlBest) {
                    vl = -searchNoNull(-SearchContanst.MATE_VALUE, vlBeta: -vlBest, depth: newDepth);
                }
            }
            pos.undoMakeMove()
            
            if (vl > vlBest) {
                vlBest = vl
                mvResult = mv
                if (vlBest > -SearchContanst.WIN_VALUE && vlBest < SearchContanst.WIN_VALUE) {
                    vlBest += (Int(arc4random()) & SearchContanst.RANDOM_MASK) -
                        (Int(arc4random()) & SearchContanst.RANDOM_MASK);
                    vlBest = (vlBest == pos.drawValue() ? vlBest - 1 : vlBest);
                }
            }
         mv = sort.next()
        }
        
        setBestMove(mvResult, depth: depth)
        return vlBest
    }
    
    public func searchUnique( vlBeta:Int, depth:Int) ->Bool{
        var sort =  SortItem(mvHash: mvResult,mSearch:self)
        sort.next()
        var mv = sort.next()
        while (mv > 0) {
            if (!pos.makeMove(mv)) {
                mv = sort.next()
                continue
            }
            var vl = -searchFull(-vlBeta, vlBeta: 1 - vlBeta, depth: pos.inCheck() ? depth : depth - 1)
            pos.undoMakeMove()
            if (vl >= vlBeta) {
                return false
            }
        }
        return true
    }
    
    public func searchMain( millis :Int) ->Int{
        return searchMain(SearchContanst.LIMIT_DEPTH, millis: millis)
    }
    
    public  func searchMain( depth:Int,  millis:Int) ->Int {
        mvResult = pos.bookMove();
        if (mvResult > 0) {
            pos.makeMove(mvResult);
            if (pos.repStatus(3) == 0) {
                pos.undoMakeMove();
                return mvResult;
            }
            pos.undoMakeMove();
        }
        for (var i = 0; i <= hashMask; i++) {
            var hash = self.hashTable[i]
            hash.depth = 0
            hash.flag = 0
            hash.vl = 0;
            hash.mv = 0
            hash.zobristLock = 0
        }
        for (var i = 0; i < SearchContanst.LIMIT_DEPTH; i++) {
            mvKiller[i][0] = 0
            mvKiller[i][1] = 0
        }
        for (var i = 0; i < 4096; i++) {
            historyTable[i] = 0
        }
        mvResult = 0
        allNodes = 0
        pos.distance = 0
        var dat = NSDate(timeIntervalSinceNow: 0)
        var t = Int(dat.timeIntervalSince1970*1000)
        
        for (var i = 1; i <= depth; i++) {
            var vl = searchRoot(i);
            dat=NSDate(timeIntervalSinceNow: 0)
            allMillis = Int(dat.timeIntervalSince1970*1000) - t
            if (allMillis > millis) {
                break;
            }
            if (vl > SearchContanst.WIN_VALUE || vl < -SearchContanst.WIN_VALUE) {
                break;
            }
            if (searchUnique(1 - SearchContanst.WIN_VALUE, depth: i)) {
                break;
            }
        }
        return mvResult
    }
    
    public func getKNPS() ->Int{
        return allNodes / allMillis
    }
    
    
}
