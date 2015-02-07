//
//  Util.swift
//  ChnieseChess
//
//  Created by chenjames on 1/30/15.
//  Copyright (c) 2015 chenjames. All rights reserved.
//

import Foundation
public class Util {
    
    class func MIN_MAX( min:Int,  mid:Int, max:Int) ->Int {
        
        return mid < min ? min : mid > max ? max : mid
    }
    
    
    struct PopCount {
        static let SHELL_STEP = [0, 1, 4, 13, 40, 121, 364, 1093]
        
        static let POP_COUNT_16_ARRAY: [Byte] = {
            var temporaryPop = [Byte]()
            
            for i in 0...65535 {
                var n = ((i >> 1) & 0x5555) + (i & 0x5555)
                n = ((n >> 2) & 0x3333) + (n & 0x3333)
                n = ((n >> 4) & 0x0f0f) + (n & 0x0f0f)
                temporaryPop[i] = Byte ((n >> 8) + (n & 0x00ff))
            }
            return temporaryPop
            }()
        
    }
    
    public class func POP_COUNT_16(data:Int) -> Int {
        return Int(PopCount.POP_COUNT_16_ARRAY[data])
    }
    
    public class func  readShort(data:[Byte],offset:Int) -> Int  {
        var a = Int(data[0])
        var b = Int(data[1])<<8
        return a | b
    }
    
    public class func readInt(data:[Byte],offset:Int) ->Int {
        var a = Int(data[0])
        var b = Int(data[1])<<8
        var c = Int(data[2])<<16
        var d = Int(data[3])<<24
        return a | b | c | d
        
    }
    
    public  class RC4 {
        var  state = [Int](count: 256, repeatedValue: 0)
        var  x=0, y=0
        
        func swap(i:Int, swapWithBefore:Int) ->Void{
            var t = state[i]
            state[i] = state[swapWithBefore]
            state[swapWithBefore] = t
            
        }
        
        init(key:[Byte]) {
            x = 0
            y = 0
            
            for var i=0;i<256;i++ {
                state[i]=i
            }
            
            var j = 0
            for i in 0...255{
                j = (j + state[i] + Int(key[i % key.count])) & 0xff
                swap(i,swapWithBefore: j)
            }
            
        }
        
        func  nextByte() -> Int{
            x = (x + 1) & 0xff
            y = (y + state[x]) & 0xff
            swap(x, swapWithBefore: y)
            var t = (state[x] + state[y]) & 0xff
            return state[t]
        }
        
        func nextLong() ->Int{
            
            var n0 = nextByte();
            var n1 = nextByte();
            var n2 = nextByte();
            var n3 = nextByte();
            return n0 + (n1 << 8) + (n2 << 16) + (n3 << 24)
        }
    }
    
    class func binarySearch(vl:Int, vls:[Int],from:Int, to:Int)->Int {
        var low = from
        var high = to - 1
        
        while (low <= high) {
            
            var mid = (low + high) / 2;
            
            if (vls[mid] < vl) {
                low = mid + 1
                
            } else if (vls[mid] > vl) {
                
                high = mid - 1
            } else {
                
                return mid;
            }
        }
        return -1;
    }
    
    
    
    public class func  shellSort(inout mvs:[Int], inout vls:[Int], from:Int, to:Int) {
        var stepLevel = 1
        var SHELL_STEP=PopCount.SHELL_STEP
        
        while (SHELL_STEP[stepLevel] < to - from) {
            stepLevel++
        }
        
        stepLevel--
        
        while (stepLevel > 0) {
            var step = SHELL_STEP[stepLevel]
            
            for  var i = from + step; i < to; i++ {
                var mvBest = mvs[i]
                var vlBest = vls[i]
                var j = i - step
                
                while (j >= from && vlBest > vls[j]) {
                    mvs[j + step] = mvs[j]
                    vls[j + step] = vls[j]
                    j -= step
                }
                
                mvs[j + step] = mvBest
                vls[j + step] = vlBest
            }
            stepLevel--
        }
        
    }
    
}
