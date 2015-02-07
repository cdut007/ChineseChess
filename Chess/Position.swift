//
//  Position.swift
//  ChnieseChess
//
//  Created by chenjames on 1/31/15.
//  Copyright (c) 2015 chenjames. All rights reserved.
//

import Foundation


extension String {
    func characterAtIndex(index: Int) -> Character? {
        var cur = 0
        for char in self {
            if cur == index {
                return char
            }
            cur++
        }
        return nil
    }
}

public struct PositionMark{
    
    static let MATE_VALUE = 10000
    static let BAN_VALUE = MATE_VALUE - 100
    static let WIN_VALUE = MATE_VALUE - 200
    public static let NULL_SAFE_MARGIN = 400
    public static let NULL_OKAY_MARGIN = 200
    public static let DRAW_VALUE = 20
    public static let ADVANCED_VALUE = 3
    
    public static let MAX_MOVE_NUM = 256
    public static let MAX_GEN_MOVES = 128
    public static let MAX_BOOK_SIZE = 16384
    
    public static let PIECE_KING = 0
    public static let PIECE_ADVISOR = 1
    public static let PIECE_BISHOP = 2
    public static let PIECE_KNIGHT = 3
    public static let PIECE_ROOK = 4
    public static let PIECE_CANNON = 5
    public static let PIECE_PAWN = 6
    
    public static let RANK_TOP = 3
    public static let RANK_BOTTOM = 12
    public static let FILE_LEFT = 3
    public static let FILE_RIGHT = 11
    
    public static let IN_BOARD :[Byte] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
        0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
        0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, ]
    
    public static let IN_FORT :[Byte] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, ]
    
    public static let LEGAL_SPAN :[Byte] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 2, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ]
    
    public static let KNIGHT_PIN :[Int] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -16, 0, -16, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
    
    public static let KING_DELTA = [ -16, -1, 1, 16 ]
    public static let ADVISOR_DELTA = [ -17, -15, 15, 17 ]
    public static let KNIGHT_DELTA = [ [ -33, -31 ], [ -18, 14 ],
    [-14, 18 ], [ 31, 33 ] ]
    public static let KNIGHT_CHECK_DELTA = [ [ -33, -18 ],
    [-31, -14 ], [14, 31 ], [ 18, 33 ] ]
    public static let  MVV_VALUE = [ 50, 10, 10, 30, 40, 30, 20, 0 ]
    
    public static let PIECE_VALUE :[[Int16]] = [
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 11, 13, 11, 9, 9, 9, 0,
    0, 0, 0, 0, 0, 0, 19, 24, 34, 42, 44, 42, 34, 24, 19, 0, 0,
    0, 0, 0, 0, 0, 19, 24, 32, 37, 37, 37, 32, 24, 19, 0, 0, 0,
    0, 0, 0, 0, 19, 23, 27, 29, 30, 29, 27, 23, 19, 0, 0, 0, 0,
    0, 0, 0, 14, 18, 20, 27, 29, 27, 20, 18, 14, 0, 0, 0, 0, 0,
    0, 0, 7, 0, 13, 0, 16, 0, 13, 0, 7, 0, 0, 0, 0, 0, 0, 0, 7,
    0, 7, 0, 15, 0, 7, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 15, 11, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    
        [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 20, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 18, 0, 0, 20, 23, 20, 0, 0, 18, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20,
    20, 0, 20, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
        
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 20, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 18, 0, 0, 20, 23, 20, 0, 0, 18, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20,
    20, 0, 20, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
        
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 90, 90, 90, 96, 90, 96, 90, 90,
    90, 0, 0, 0, 0, 0, 0, 0, 90, 96, 103, 97, 94, 97, 103, 96,
    90, 0, 0, 0, 0, 0, 0, 0, 92, 98, 99, 103, 99, 103, 99, 98,
    92, 0, 0, 0, 0, 0, 0, 0, 93, 108, 100, 107, 100, 107, 100,
    108, 93, 0, 0, 0, 0, 0, 0, 0, 90, 100, 99, 103, 104, 103,
    99, 100, 90, 0, 0, 0, 0, 0, 0, 0, 90, 98, 101, 102, 103,
    102, 101, 98, 90, 0, 0, 0, 0, 0, 0, 0, 92, 94, 98, 95, 98,
    95, 98, 94, 92, 0, 0, 0, 0, 0, 0, 0, 93, 92, 94, 95, 92,
    95, 94, 92, 93, 0, 0, 0, 0, 0, 0, 0, 85, 90, 92, 93, 78,
    93, 92, 90, 85, 0, 0, 0, 0, 0, 0, 0, 88, 85, 90, 88, 90,
    88, 90, 85, 88, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
        
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 206, 208, 207, 213, 214, 213,
    207, 208, 206, 0, 0, 0, 0, 0, 0, 0, 206, 212, 209, 216,
    233, 216, 209, 212, 206, 0, 0, 0, 0, 0, 0, 0, 206, 208,
    207, 214, 216, 214, 207, 208, 206, 0, 0, 0, 0, 0, 0, 0,
    206, 213, 213, 216, 216, 216, 213, 213, 206, 0, 0, 0, 0, 0,
    0, 0, 208, 211, 211, 214, 215, 214, 211, 211, 208, 0, 0, 0,
    0, 0, 0, 0, 208, 212, 212, 214, 215, 214, 212, 212, 208, 0,
    0, 0, 0, 0, 0, 0, 204, 209, 204, 212, 214, 212, 204, 209,
    204, 0, 0, 0, 0, 0, 0, 0, 198, 208, 204, 212, 212, 212,
    204, 208, 198, 0, 0, 0, 0, 0, 0, 0, 200, 208, 206, 212,
    200, 212, 206, 208, 200, 0, 0, 0, 0, 0, 0, 0, 194, 206,
    204, 212, 200, 212, 204, 206, 194, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0 ],
        
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 100, 96, 91, 90, 91, 96,
    100, 100, 0, 0, 0, 0, 0, 0, 0, 98, 98, 96, 92, 89, 92, 96,
    98, 98, 0, 0, 0, 0, 0, 0, 0, 97, 97, 96, 91, 92, 91, 96,
    97, 97, 0, 0, 0, 0, 0, 0, 0, 96, 99, 99, 98, 100, 98, 99,
    99, 96, 0, 0, 0, 0, 0, 0, 0, 96, 96, 96, 96, 100, 96, 96,
    96, 96, 0, 0, 0, 0, 0, 0, 0, 95, 96, 99, 96, 100, 96, 99,
    96, 95, 0, 0, 0, 0, 0, 0, 0, 96, 96, 96, 96, 96, 96, 96,
    96, 96, 0, 0, 0, 0, 0, 0, 0, 97, 96, 100, 99, 101, 99, 100,
    96, 97, 0, 0, 0, 0, 0, 0, 0, 96, 97, 98, 98, 98, 98, 98,
    97, 96, 0, 0, 0, 0, 0, 0, 0, 96, 96, 97, 99, 99, 99, 97,
    96, 96, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
        
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 11, 13, 11, 9, 9, 9, 0,
    0, 0, 0, 0, 0, 0, 19, 24, 34, 42, 44, 42, 34, 24, 19, 0, 0,
    0, 0, 0, 0, 0, 19, 24, 32, 37, 37, 37, 32, 24, 19, 0, 0, 0,
    0, 0, 0, 0, 19, 23, 27, 29, 30, 29, 27, 23, 19, 0, 0, 0, 0,
    0, 0, 0, 14, 18, 20, 27, 29, 27, 20, 18, 14, 0, 0, 0, 0, 0,
    0, 0, 7, 0, 13, 0, 16, 0, 13, 0, 7, 0, 0, 0, 0, 0, 0, 0, 7,
    0, 7, 0, 15, 0, 7, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 15, 11, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], ]
    
    public static let STARTUP_FEN = [
    "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR w - - 0 1",
    "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/R1BAKABNR w - - 0 1",
    "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/R1BAKAB1R w - - 0 1",
    "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/9/1C5C1/9/RN2K2NR w - - 0 1", ]
    
     public static let FEN_PIECE = "        KABNRCP kabnrcp ";
    
    public static var PreGen_zobristKeyPlayer=0
    public static var PreGen_zobristLockPlayer=0
    public static var PreGen_zobristKeyTable = [[Int]](count: 14, repeatedValue: (Array(count: 256, repeatedValue: 0)))
    public static var PreGen_zobristLockTable = [[Int]](count: 14, repeatedValue: (Array(count: 256, repeatedValue: 0)))

    
   // public static var random = new Random()
    
    public static var bookSize = 0
    public static var bookLock = [Int](count: MAX_BOOK_SIZE, repeatedValue: 0)
    public static var bookMove = [Int](count: MAX_BOOK_SIZE, repeatedValue: 0)
    public static var bookValue = [Int](count: MAX_BOOK_SIZE, repeatedValue: 0)
}



public class Position{
    
    
    class func IN_BOARD(sq:Int) ->Bool{
        return PositionMark.IN_BOARD[sq] != 0
    }
    
    class func  IN_FORT( sq:Int) ->Bool{
        return PositionMark.IN_FORT[sq] != 0
    }
    
    class func  RANK_Y( sq:Int) ->Int{
        return sq >> 4
    }
    
    class func  FILE_X( sq:Int)->Int {
        return sq & 15
    }
    
    class func  COORD_XY( x:Int,  y:Int)  ->Int{
        return x + (y << 4)
    }
    
     class func  SQUARE_FLIP(sq:Int) ->Int{
        return 254 - sq;
    }
    
    class func  FILE_FLIP( x:Int) ->Int{
        return 14 - x;
    }
    
    class func  RANK_FLIP( y:Int) ->Int{
        return 15 - y;
    }
    
    class func  MIRROR_SQUARE( sq:Int)->Int {
        return COORD_XY(FILE_FLIP(FILE_X(sq)), y:RANK_Y(sq))
    }
    
    class func  SQUARE_FORWARD( sq:Int,  sd:Int) ->Int {
        return sq - 16 + (sd << 5)
    }
    
    class func  KING_SPAN( sqSrc:Int,  sqDst:Int) ->Bool{
        return PositionMark.LEGAL_SPAN[sqDst - sqSrc + 256] == 1;
    }
    
    class func  ADVISOR_SPAN( sqSrc:Int,  sqDst:Int) ->Bool {
        return PositionMark.LEGAL_SPAN[sqDst - sqSrc + 256] == 2
    }
    
    class func  BISHOP_SPAN( sqSrc:Int,  sqDst:Int) ->Bool{
        return PositionMark.LEGAL_SPAN[sqDst - sqSrc + 256] == 3
    }
    
    class func  BISHOP_PIN( sqSrc:Int,  sqDst:Int) ->Int{
        return (sqSrc + sqDst) >> 1;
    }
    
    class func  KNIGHT_PIN( sqSrc:Int,  sqDst:Int)->Int {
        return sqSrc + Int(PositionMark.KNIGHT_PIN[sqDst - sqSrc + 256])
    }
    
    class func  HOME_HALF( sq:Int,  sd:Int) ->Bool{
        return (sq & 0x80) != (sd << 7);
    }
    
    class func  AWAY_HALF( sq:Int,  sd:Int) ->Bool{
        return (sq & 0x80) == (sd << 7);
    }
    
    class func  SAME_HALF( sqSrc:Int,  sqDst:Int) ->Bool{
        return ((sqSrc ^ sqDst) & 0x80) == 0;
    }
    
    class func  SAME_RANK( sqSrc:Int,  sqDst:Int) ->Bool{
        return ((sqSrc ^ sqDst) & 0xf0) == 0;
    }
    
    class func  SAME_FILE( sqSrc:Int,  sqDst:Int) ->Bool{
        return ((sqSrc ^ sqDst) & 0x0f) == 0;
    }
    
    class func  SIDE_TAG( sd:Int) ->Int{
        return 8 + (sd << 3);
    }
    
    class func  OPP_SIDE_TAG( sd:Int) ->Int{
        return 16 - (sd << 3);
    }
    
    class func  SRC( mv:Int) ->Int {
        return mv & 255;
    }
    
    class func  DST( mv:Int)->Int {
        return mv >> 8
    }
    
    class func  MOVE( sqSrc:Int,  sqDst:Int) ->Int{
        return sqSrc + (sqDst << 8)
    }
    
    class func  MIRROR_MOVE( mv:Int) ->Int{
        return MOVE(MIRROR_SQUARE(SRC(mv)), sqDst:MIRROR_SQUARE(DST(mv)))
    }
    
    class func  MVV_LVA(pc:Byte, lva:Int) ->Int {
        return PositionMark.MVV_VALUE[Int(pc) & 7] - lva
    }
    
   
    
    class func  CHAR_TO_PIECE( c:Character) ->Int{
        switch (c) {
        case "K":
        return PositionMark.PIECE_KING
        case "A":
        return PositionMark.PIECE_ADVISOR
        case "B","E":
        return PositionMark.PIECE_BISHOP
        case "H","N":
        return PositionMark.PIECE_KNIGHT
        case "R":
        return PositionMark.PIECE_ROOK
        case "C":
        return PositionMark.PIECE_CANNON
        case "P":
        return PositionMark.PIECE_PAWN
        default:
            return -1;
        }
    }
    
    
    public var sdPlayer:Int = 0
    public  var squares = [Byte](count: 256, repeatedValue: 0)
    
    var zobristKey:Int = 0
    public var zobristLock:Int=0
    var vlWhite:Int=0, vlBlack:Int=0
    public var moveNum:Int=0, distance:Int=0
    public var mvList = [Int](count: PositionMark.MAX_MOVE_NUM, repeatedValue:0)
    public var pcList = [Int](count: PositionMark.MAX_MOVE_NUM, repeatedValue:0)
    public var keyList = [Int](count: PositionMark.MAX_MOVE_NUM, repeatedValue:0)
    public var chkList = [Bool](count: PositionMark.MAX_MOVE_NUM, repeatedValue:false)
    
    func clearBoard() {
        sdPlayer = 0;
        for (var sq = 0; sq < 256; sq++) {
            squares[sq] = 0
        }
        zobristKey = 0
        zobristLock = 0
        vlWhite = 0
        vlBlack = 0
    }
    
    func setIrrev() {
        mvList[0] = 0
        pcList[0] = 0
        chkList[0] = checked()
        moveNum = 1
        distance = 0
    }
    
    func addPiece( sq:Int,  pc:Int,  del:Bool) {
        var pcAdjust=0
        squares[sq] = Byte(del ? 0 : pc)
        if (pc < 16) {
            pcAdjust = pc - 8
            
            if del{
             vlWhite-=Int(PositionMark.PIECE_VALUE[pcAdjust][sq])
            }else{
            vlWhite += Int(PositionMark.PIECE_VALUE[pcAdjust][sq])
            }
            
        } else {
            pcAdjust = pc - 16
            if del{
                vlWhite-=Int(PositionMark.PIECE_VALUE[pcAdjust][Position.SQUARE_FLIP(sq)])
            }else{
                vlWhite += Int(PositionMark.PIECE_VALUE[pcAdjust][Position.SQUARE_FLIP(sq)])
            }
            
            pcAdjust += 7
        }
        zobristKey ^= PositionMark.PreGen_zobristKeyTable[pcAdjust][sq]
        zobristLock ^= PositionMark.PreGen_zobristLockTable[pcAdjust][sq]
    }
    
    public func addPiece( sq:Int,  pc:Int) {
        addPiece(sq, pc:pc, del:false)
    }
    
    public func delPiece( sq:Int,  pc:Int) {
        addPiece(sq, pc: pc, del: true)
    }
    
    func movePiece() {
        var sqSrc = Position.SRC(mvList[moveNum])
        var sqDst = Position.DST(mvList[moveNum])
        pcList[moveNum] = Int(squares[sqDst])
        if (pcList[moveNum] > 0) {
            delPiece(sqDst, pc:pcList[moveNum])
        }
        var pc = squares[sqSrc]
        delPiece(sqSrc, pc:Int(pc))
        addPiece(sqDst, pc:Int(pc))
    }
    
    func undoMovePiece() {
        var sqSrc = Position.SRC(mvList[moveNum])
        var sqDst = Position.DST(mvList[moveNum])
        var pc = squares[sqDst]
        delPiece(sqDst, pc:Int(pc))
        addPiece(sqSrc, pc:Int(pc))
        if (pcList[moveNum] > 0) {
            addPiece(sqDst, pc:pcList[moveNum])
        }
    }
    
    func changeSide() {
        sdPlayer = 1 - sdPlayer;
        zobristKey ^= PositionMark.PreGen_zobristKeyPlayer
        zobristLock ^= PositionMark.PreGen_zobristLockPlayer
    }
    
    func makeMove( mv:Int) ->Bool{
        keyList[moveNum] = zobristKey;
        mvList[moveNum] = mv;
        movePiece();
        if (checked()) {
            undoMovePiece();
            return false;
        }
        changeSide();
        chkList[moveNum] = checked();
        moveNum++;
        distance++;
        return true;
    }
    
    func undoMakeMove() {
        moveNum--;
        distance--;
        changeSide();
        undoMovePiece();
    }
    
    func nullMove() {
        keyList[moveNum] = zobristKey
        changeSide()
        mvList[moveNum] = 0
        pcList[moveNum] = 0
        chkList[moveNum] = false
        moveNum++
        distance++
    }
    
    func undoNullMove() {
        moveNum--
        distance--
        changeSide()
    }
    
    class func getUniCodeValue(char:Character)->Int{
        
        var scalars = String(char).unicodeScalars
        var value=0
        for scalar in scalars{
            value = Int(scalar.value)
            return value
        }
        return value
        
    }
    
    class func getCharFromIntValue(uniCodeVal:Int)->Character{
        
        var scalar = UnicodeScalar(uniCodeVal)
        
        return String(scalar).characterAtIndex(0)!
    }
    
    func fromFen( fen:String) {
        clearBoard()
        var y = PositionMark.RANK_TOP
        var x = PositionMark.FILE_LEFT
        var index = 0
        if (index == countElements(fen)) {
            setIrrev()
            return
        }
        var c = fen.characterAtIndex(index)
        while (c != " ") {
            if (c == "/") {
                x = PositionMark.FILE_LEFT
                y++
                if (y > PositionMark.RANK_BOTTOM) {
                    break
                }
            } else if (c >= "1" && c <= "9") {
                for (var k = 0; k < (Position.getUniCodeValue(c!)  - Position.getUniCodeValue("0") ); k++) {
                    if (x >= PositionMark.FILE_RIGHT) {
                        break
                    }
                    x++
                }
            } else if (c >= "A" && c <= "Z") {
                if (x <= PositionMark.FILE_RIGHT) {
                    var pt = Position.CHAR_TO_PIECE(c!)
                    if (pt >= 0) {
                        addPiece(Position.COORD_XY(x, y: y), pc: pt + 8)
                    }
                    x++
                }
            } else if (c >= "a" && c <= "z") {
                if (x <= PositionMark.FILE_RIGHT) {
                    var value1 = Position.getUniCodeValue("A")
                    var value2 = Position.getUniCodeValue("a")
                    var pos = Position.getUniCodeValue(c!) + value1 - value2
                    var pt = Position.CHAR_TO_PIECE(Position.getCharFromIntValue(pos))
                    if (pt >= 0) {
                        addPiece(Position.COORD_XY(x, y: y), pc: pt + 16)
                    }
                    x++
                }
            }
            index++
            if (index == countElements(fen)) {
                setIrrev()
                return;
            }
            c = fen.characterAtIndex(index)
        }
        index++
        if (index == countElements(fen)) {
            setIrrev()
            return
        }
        if (sdPlayer == (fen.characterAtIndex(index) == "b" ? 0 : 1)) {
            changeSide()
        }
        setIrrev()
    }
    
   
    
    func toFen()->String {
        var fen = String()
        
        for (var y = PositionMark.RANK_TOP; y <= PositionMark.RANK_BOTTOM; y++) {
            var k = 0
            for (var x = PositionMark.FILE_LEFT; x <= PositionMark.FILE_RIGHT; x++) {
                var pc = squares[Position.COORD_XY(x, y: y)]
                if (pc > 0) {
                    if (k > 0) {
                        fen.append(Position.getCharFromIntValue(Position.getUniCodeValue("0") + k))
                        k = 0
                    }
                    fen.append(PositionMark.FEN_PIECE.characterAtIndex(Int(pc))!)
                } else {
                    k++
                }
            }
            if (k > 0) {
                fen.append(Position.getCharFromIntValue((Position.getUniCodeValue("0") + k)))
            }
            fen += "/"
        }
        let lastIndex = advance(fen.startIndex, countElements(fen)-1)
        fen.removeAtIndex(lastIndex)
        fen += " "
        fen += (sdPlayer == 0 ? "w" : "b")
        return fen
    }
    
    
    
    func generateAllMoves(inout mvs:[Int]) ->Int{
        var null=[Int]()
        return generateMoves(&mvs, vls: &null,option:true)
    }
    
    func generateMoves( inout mvs:[Int], inout vls:[Int],option:Bool)->Int {
        var moves = 0
        var pcSelfSide = Position.SIDE_TAG(sdPlayer)
        var pcOppSide = Position.OPP_SIDE_TAG(sdPlayer)
        for (var sqSrc = 0; sqSrc < 256; sqSrc++) {
            var pcSrc = squares[sqSrc]
            
            if ((Int(pcSrc) & pcSelfSide) == 0) {
                continue
            }
            switch (Int(pcSrc - pcSelfSide)) {
            case PositionMark.PIECE_KING:
                for (var i = 0; i < 4; i++) {
                    var sqDst = sqSrc + PositionMark.KING_DELTA[i]
                    if (!Position.IN_FORT(sqDst)) {
                        continue
                    }
                    var pcDst = squares[sqDst]
                    if (option) {
                        if ((Int(pcDst) & pcSelfSide) == 0) {
                            mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                            moves++
                        }
                    } else if ((Int(pcDst) & pcOppSide) != 0) {
                        mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                       
                        vls[moves] = Position.MVV_LVA(pcDst, lva:5)
                        moves++
                    }
                }
                break
                
            case PositionMark.PIECE_ADVISOR:
                for (var i = 0; i < 4; i++) {
                    var sqDst = sqSrc + PositionMark.ADVISOR_DELTA[i]
                    if (!Position.IN_FORT(sqDst)) {
                        continue
                    }
                    var pcDst = squares[sqDst]
                    if (option) {
                        if ((Int(pcDst) & pcSelfSide) == 0) {
                            mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                            moves++
                        }
                    } else if ((Int(pcDst) & pcOppSide) != 0) {
                        mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                        vls[moves] = Position.MVV_LVA(pcDst, lva:1)
                        moves++
                    }
                }
                break
                
            case PositionMark.PIECE_BISHOP:
                for (var i = 0; i < 4; i++) {
                    var sqDst = sqSrc + PositionMark.ADVISOR_DELTA[i]
                    if (!(Position.IN_BOARD(sqDst) && Position.HOME_HALF(sqDst, sd: sdPlayer) && squares[sqDst] == 0)) {
                        continue
                    }
                    sqDst += PositionMark.ADVISOR_DELTA[i]
                    var pcDst = squares[sqDst]
                    if (option) {
                        if ((Int(pcDst) & pcSelfSide) == 0) {
                            mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst);
                            moves++
                        }
                    } else if ((Int(pcDst) & pcOppSide) != 0) {
                        mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                        vls[moves] = Position.MVV_LVA(pcDst, lva: 1)
                        moves++
                    }
                }
                break
                
            case PositionMark.PIECE_KNIGHT:
                for (var i = 0; i < 4; i++) {
                    var sqDst = sqSrc + PositionMark.KING_DELTA[i];
                    if (squares[sqDst] > 0) {
                        continue;
                    }
                    for (var j = 0; j < 2; j++) {
                        sqDst = sqSrc + PositionMark.KNIGHT_DELTA[i][j]
                        if (!Position.IN_BOARD(sqDst)) {
                            continue;
                        }
                        var pcDst = squares[sqDst]
                        if (option) {
                            if ((Int(pcDst) & pcSelfSide) == 0) {
                                mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                                moves++
                            }
                        } else if ((Int(pcDst) & pcOppSide) != 0) {
                            mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                            vls[moves] = Position.MVV_LVA(pcDst, lva: 1)
                            moves++
                        }
                    }
                }
                break
                
            case PositionMark.PIECE_ROOK:
                for (var i = 0; i < 4; i++) {
                    var delta = PositionMark.KING_DELTA[i]
                    var sqDst = sqSrc + delta
                    while (Position.IN_BOARD(sqDst)) {
                        var pcDst = squares[sqDst]
                        if (pcDst == 0) {
                            if (option) {
                                mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                                moves++
                            }
                        } else {
                            if ((Int(pcDst) & pcOppSide) != 0) {
                                mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                                if (!option) {
                                    vls[moves] = Position.MVV_LVA(pcDst, lva: 4)
                                }
                                moves++
                            }
                            break;
                        }
                        sqDst += delta
                    }
                }
                break
                
            case PositionMark.PIECE_CANNON:
                for (var i = 0; i < 4; i++) {
                    var delta = PositionMark.KING_DELTA[i]
                    var sqDst = sqSrc + delta
                    while (Position.IN_BOARD(sqDst)) {
                        var pcDst = squares[sqDst]
                        if (pcDst == 0) {
                            if (option) {
                                mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                                moves++
                            }
                        } else {
                            break;
                        }
                        sqDst += delta
                    }
                    sqDst += delta
                    while (Position.IN_BOARD(sqDst)) {
                        var pcDst = squares[sqDst]
                        if (pcDst > 0) {
                            if ((Int(pcDst) & pcOppSide) != 0) {
                                mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                                if (!option) {
                                    vls[moves] = Position.MVV_LVA(pcDst, lva: 4)
                                }
                                moves++
                            }
                            break;
                        }
                        sqDst += delta
                    }
                }
                break
                
            case PositionMark.PIECE_PAWN:
                var sqDst = Position.SQUARE_FORWARD(sqSrc, sd: sdPlayer)
                if (Position.IN_BOARD(sqDst)) {
                    var pcDst = squares[sqDst]
                    if (option) {
                        if ((Int(pcDst) & pcSelfSide) == 0) {
                            mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                            moves++;
                        }
                    } else if ((Int(pcDst) & pcOppSide) != 0) {
                        mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                        vls[moves] = Position.MVV_LVA(pcDst, lva: 2)
                        moves++
                    }
                }
                if (Position.AWAY_HALF(sqSrc, sd: sdPlayer)) {
                    for (var delta = -1; delta <= 1; delta += 2) {
                        sqDst = sqSrc + delta
                        if (Position.IN_BOARD(sqDst)) {
                            var pcDst = squares[sqDst]
                            if (option) {
                                if ((Int(pcDst) & pcSelfSide) == 0) {
                                    mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                                    moves++
                                }
                            } else if ((Int(pcDst) & pcOppSide) != 0) {
                                mvs[moves] = Position.MOVE(sqSrc, sqDst: sqDst)
                                vls[moves] = Position.MVV_LVA(pcDst, lva: 2)
                                moves++
                            }
                        }
                    }
                }
                break
                
            default:
                break
            }
        }
        return moves;
    }
    
    func legalMove( mv:Int) ->Bool{
        var sqSrc = Position.SRC(mv)
        var pcSrc = squares[sqSrc]
        var pcSelfSide = Position.SIDE_TAG(sdPlayer)
        if ((Int(pcSrc) & pcSelfSide) == 0) {
            return false
        }
        
        var sqDst = Position.DST(mv)
        var pcDst = squares[sqDst]
        if ((Int(pcDst) & pcSelfSide) != 0) {
            return false
        }
        
        switch (Int(pcSrc - pcSelfSide)) {
        case PositionMark.PIECE_KING:
            return Position.IN_FORT(sqDst) && Position.KING_SPAN(sqSrc, sqDst: sqDst)
        case PositionMark.PIECE_ADVISOR:
            return Position.IN_FORT(sqDst) && Position.ADVISOR_SPAN(sqSrc, sqDst: sqDst)
        case PositionMark.PIECE_BISHOP:
            return Position.SAME_HALF(sqSrc, sqDst: sqDst) && Position.BISHOP_SPAN(sqSrc, sqDst: sqDst)
                && squares[Position.BISHOP_PIN(sqSrc, sqDst: sqDst)] == 0
        case PositionMark.PIECE_KNIGHT:
            var sqPin = Position.KNIGHT_PIN(sqSrc, sqDst: sqDst)
            return sqPin != sqSrc && squares[sqPin] == 0
        case PositionMark.PIECE_ROOK, PositionMark.PIECE_CANNON:
            var delta=0
            if (Position.SAME_RANK(sqSrc, sqDst: sqDst)) {
                delta = (sqDst < sqSrc ? -1 : 1)
            } else if (Position.SAME_FILE(sqSrc, sqDst: sqDst)) {
                delta = (sqDst < sqSrc ? -16 : 16);
            } else {
                return false
            }
            var sqPin = sqSrc + delta
            while (sqPin != sqDst && squares[sqPin] == 0) {
                sqPin += delta
            }
            if (sqPin == sqDst) {
                return pcDst == 0 || Int(pcSrc) - pcSelfSide == PositionMark.PIECE_ROOK
            }
            if (pcDst == 0 || Int(pcSrc) - pcSelfSide == PositionMark.PIECE_ROOK) {
                return false
            }
            sqPin += delta
            while (sqPin != sqDst && squares[sqPin] == 0) {
                sqPin += delta
            }
            return sqPin == sqDst
        case PositionMark.PIECE_PAWN:
            if (Position.AWAY_HALF(sqDst, sd: sdPlayer)
                && (sqDst == sqSrc - 1 || sqDst == sqSrc + 1)) {
                    return true
            }
            return sqDst == Position.SQUARE_FORWARD(sqSrc, sd: sdPlayer)
        default:
            return false;
        }
    }
    
    func checked() ->Bool{
        var pcSelfSide = Position.SIDE_TAG(sdPlayer)
        var pcOppSide = Position.OPP_SIDE_TAG(sdPlayer)
        for (var sqSrc = 0; sqSrc < 256; sqSrc++) {
            if (Int(squares[sqSrc]) != pcSelfSide + PositionMark.PIECE_KING) {
                continue;
            }
            if (Int(squares[Position.SQUARE_FORWARD(sqSrc, sd: sdPlayer)]) == pcOppSide
                + PositionMark.PIECE_PAWN) {
                    return true
            }
            for (var delta = -1; delta <= 1; delta += 2) {
                if (Int(squares[sqSrc + delta]) == pcOppSide + PositionMark.PIECE_PAWN) {
                    return true
                }
            }
            for (var i = 0; i < 4; i++) {
                if (squares[sqSrc + PositionMark.ADVISOR_DELTA[i]] != 0) {
                    continue;
                }
                for (var j = 0; j < 2; j++) {
                    var pcDst = squares[sqSrc + PositionMark.KNIGHT_CHECK_DELTA[i][j]]
                    if (Int(pcDst) == pcOppSide + PositionMark.PIECE_KNIGHT) {
                        return true;
                    }
                }
            }
            for (var i = 0; i < 4; i++) {
                var delta = PositionMark.KING_DELTA[i]
                var sqDst = sqSrc + delta
                while (Position.IN_BOARD(sqDst)) {
                    var pcDst = squares[sqDst]
                    if (pcDst > 0) {
                        if (Int(pcDst) == pcOppSide + PositionMark.PIECE_ROOK
                            || Int(pcDst) == pcOppSide + PositionMark.PIECE_KING) {
                                return true
                        }
                        break;
                    }
                    sqDst += delta
                }
                sqDst += delta
                while (Position.IN_BOARD(sqDst)) {
                    var pcDst = squares[sqDst]
                    if (pcDst > 0) {
                        if (Int(pcDst) == pcOppSide + PositionMark.PIECE_CANNON) {
                            return true;
                        }
                        break
                    }
                    sqDst += delta
                }
            }
            return false
        }
        return false
    }
    
    func isMate() ->Bool{
        var mvs = [Int](count: PositionMark.MAX_GEN_MOVES, repeatedValue: 0)
        var moves = generateAllMoves(&mvs)
        for (var i = 0; i < moves; i++) {
            if (makeMove(mvs[i])) {
                undoMakeMove()
                return false
            }
        }
        return true
    }
    
    func mateValue() ->Int{
        return distance - PositionMark.MATE_VALUE
    }
    
    func banValue() ->Int{
        return distance - PositionMark.BAN_VALUE
    }
    
    func drawValue()->Int {
        return (distance & 1) == 0 ? -PositionMark.DRAW_VALUE : PositionMark.DRAW_VALUE
    }
    
    func evaluate()->Int {
        var vl = (sdPlayer == 0 ? vlWhite - vlBlack : vlBlack - vlWhite)
            + PositionMark.ADVANCED_VALUE
        return vl == drawValue() ? vl - 1 : vl
    }
    
    func nullOkay()->Bool {
        return (sdPlayer == 0 ? vlWhite : vlBlack) > PositionMark.NULL_OKAY_MARGIN
    }
    
    func nullSafe()->Bool {
        return (sdPlayer == 0 ? vlWhite : vlBlack) > PositionMark.NULL_SAFE_MARGIN
    }
    
    func inCheck()->Bool {
        return chkList[moveNum - 1]
    }
    
    func captured() ->Bool{
        return pcList[moveNum - 1] > 0
    }
    
    func repValue( vlRep:Int) ->Int{
        var vlReturn = ((vlRep & 2) == 0 ? 0 : banValue())
            + ((vlRep & 4) == 0 ? 0 : -banValue())
        return vlReturn == 0 ? drawValue() : vlReturn
    }
    
    public func repStatus()->Int {
        return repStatus(1)
    }
    
    public func repStatus(recur_:Int)->Int {
        var recur = recur_
        var selfSide = false
        var perpCheck = true
        var oppPerpCheck = true
        var index = moveNum - 1
        while (mvList[index] > 0 && pcList[index] == 0) {
            if (selfSide) {
                perpCheck = perpCheck && chkList[index];
                if (keyList[index] == zobristKey) {
                    recur--;
                    if (recur == 0) {
                        return 1 + (perpCheck ? 2 : 0) + (oppPerpCheck ? 4 : 0);
                    }
                }
            } else {
                oppPerpCheck = oppPerpCheck && chkList[index];
            }
            selfSide = !selfSide;
            index--;
        }
        return 0;
    }
    
    func mirror() ->Position{
        var pos =  Position()
        pos.clearBoard()
        for (var sq = 0; sq < 256; sq++) {
            var pc = squares[sq]
            if (pc > 0) {
                pos.addPiece(Position.MIRROR_SQUARE(sq),pc: Int(pc))
            }
        }
        if (sdPlayer == 1) {
            pos.changeSide()
        }
        return pos
    }
    
    public func bookMove() ->Int {
        if (PositionMark.bookSize == 0) {
            return 0
        }
        var isMirror = false
        var lock = zobristLock >> 1 // Convert into Unsigned
        var index = Util.binarySearch(lock, vls: PositionMark.bookLock, from: 0, to: PositionMark.bookSize)
        if (index < 0) {
            isMirror = true
            lock = mirror().zobristLock >> 1 // Convert into Unsigned
            index = Util.binarySearch(lock, vls: PositionMark.bookLock, from: 0, to: PositionMark.bookSize)
        }
        if (index < 0) {
            return 0
        }
        index--
        while (index >= 0 && PositionMark.bookLock[index] == lock) {
            index--
        }
        var mvs = [Int]()
        var vls = [Int]()
        var value = 0
        var moves = 0
        index++
        while (index < PositionMark.bookSize && PositionMark.bookLock[index] == lock) {
            var mv = 0xffff & PositionMark.bookMove[index]
            mv = (isMirror ? Position.MIRROR_MOVE(mv) : mv)
            if (legalMove(mv)) {
                mvs[moves] = mv;
                vls[moves] = PositionMark.bookValue[index]
                value += vls[moves];
                moves++;
                if (moves == PositionMark.MAX_GEN_MOVES) {
                    break
                }
            }
            index++
        }
        if (value == 0) {
            return 0;
        }
        value = abs(Int(arc4random())) % value;
        for (index = 0; index < moves; index++) {
            value -= vls[index]
            if (value < 0) {
                break;
            }
        }
        return mvs[index]
    }
    
     func historyIndex( mv:Int) ->Int{
        return ((squares[Position.SRC(mv)] - 8) << 8) + Position.DST(mv)
    }
    
    
}