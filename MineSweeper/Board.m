//
//  Board.m
//  MineSweeper
//
//  Created by Andrea Ciani on 13/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import "Board.h"


typedef enum{
    PositionNord = (1 << 0),
    PositionSud = (1 << 1),
    PositionWest = (1 << 2),
    PositionEst = (1 << 3)
}PositionMask;

@interface Board (){
    NSMutableArray *_matrix;
}

@end

// NOTE: Matrix index stards ^ heigth, <-> width. Indexes: (heigth,width)

@implementation Board
@synthesize
height = _height,
width = _width,
bombCells = _bombCells,
numberOfBombs = _numberOfBombs,
remainingCells = _remainingCells,
delegate;

-(instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height{
    if(self=[super init]){
        _height = height;
        _width = width;
        [self setRemainingCells:width*height];
        
        _matrix = [[NSMutableArray alloc]initWithCapacity:_height];
        _bombCells = [NSMutableArray new];
        
        for (int i=0; i<_height; i++) {
            NSMutableArray *row = [[NSMutableArray alloc]initWithCapacity:_width];
            for(int j=0; j<_width; j++){
                NSUInteger indexArr[] = {i,j};
                NSIndexPath *ip = [NSIndexPath indexPathWithIndexes:indexArr length:2];
                BoardCell *cell = [[BoardCell alloc]initWithPositionInBoard:ip];
                [row addObject:cell];
            }
            [_matrix addObject:row];
        }
        
    }
    return self;
}

-(void)setRemainingCells:(NSUInteger)remainingCells{
    _remainingCells = remainingCells;
    if (remainingCells==0){
        [self.delegate userWins];
        [[NSNotificationCenter defaultCenter]postNotificationName:kBoardUserWinNotification object:nil];
    }
}

-(void)insertBombs:(NSUInteger)bombs{
    _numberOfBombs = bombs;
    [self setRemainingCells:_remainingCells-bombs];
    int todo = (int)bombs; // numbero of cell to insert
    
    while (todo!=0) {
        int x = arc4random_uniform(_width-1); //random x position
        int y = arc4random_uniform(_height-1); // randome y position
        NSUInteger indexArr[] = {x, y}; // random cell
        
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexArr length:2];
        
        BoardCell *aCell = [self boardCellAtIndexPath:indexPath];
        
        if(![aCell isBomb]){
            aCell.status = BoardCellBomb;
            // Increase adiacent cells in all position
            [[self cellAtPostionMask:PositionNord respectToCell:aCell] increaseAdiacentBombs];
            [[self cellAtPostionMask:PositionSud respectToCell:aCell] increaseAdiacentBombs];
            [[self cellAtPostionMask:PositionWest respectToCell:aCell] increaseAdiacentBombs];
            [[self cellAtPostionMask:PositionEst respectToCell:aCell] increaseAdiacentBombs];
            [[self cellAtPostionMask:(PositionNord|PositionEst) respectToCell:aCell] increaseAdiacentBombs];
            [[self cellAtPostionMask:(PositionNord|PositionWest) respectToCell:aCell] increaseAdiacentBombs];
            [[self cellAtPostionMask:(PositionSud|PositionEst) respectToCell:aCell] increaseAdiacentBombs];
            [[self cellAtPostionMask:(PositionSud|PositionWest) respectToCell:aCell] increaseAdiacentBombs];
            
            [_bombCells addObject:indexPath];
            todo--;
        }
    }
    
}

-(BoardCell*)boardCellAtIndexPath:(NSIndexPath*)indexPath{
    BoardCell *cell = [[_matrix objectAtIndex:[indexPath indexAtPosition:0]] objectAtIndex:[indexPath indexAtPosition:1]];
    return cell;
}

-(void)tapCellAtIndexPath:(NSIndexPath*)path{
    // algorithm here
    
    BoardCell *selectedCell = [self boardCellAtIndexPath:path];
    [self floodFill:selectedCell];
    
    if([selectedCell isBomb]){
        [self.delegate userFindBombAtIndexPath:path];
        [self.delegate userLose];
        [[NSNotificationCenter defaultCenter]postNotificationName:kBoardUserLoseNotification object:nil];
    }else if(selectedCell.status == BoardCellUnkown){
        selectedCell.status = BoardCellDiscovered;
        [self.delegate boardCell:selectedCell didBecomeDiscoveredAtIndexPath:path];
    }
}

#pragma mark - Coding Protocol
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(_height) forKey:@"heightObj"];
    [aCoder encodeObject:@(_width) forKey:@"widthObj"];
    [aCoder encodeObject:_bombCells forKey:@"bombsArray"];
    [aCoder encodeObject:@(_remainingCells) forKey:@"remainingCells"];
    [aCoder encodeObject:_matrix forKey:@"matrix"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _height = [[aDecoder decodeObjectForKey:@"heightObj"] integerValue];
        _width = [[aDecoder decodeObjectForKey:@"widthObj"] integerValue];
        _bombCells = [aDecoder decodeObjectForKey:@"bombsArray"];
        _remainingCells = [[aDecoder decodeObjectForKey:@"remainingCells"] integerValue];
        _matrix = [aDecoder decodeObjectForKey:@"matrix"];
    }
    return self;
}

#pragma mark - getCellFromPosition

-(BoardCell*)cellAtPostionMask:(PositionMask)position respectToCell:(BoardCell*)cell{
    NSIndexPath *posip = cell.positionInBoard;
    NSInteger x = [posip indexAtPosition:0];
    NSInteger y = [posip indexAtPosition:1];
    
    if(position & PositionNord) y--;
    if(position & PositionSud) y++;
    if(position & PositionEst) x++;
    if(position & PositionWest) x--;
    
    BoardCell *result;
    @try {
        result = _matrix[x][y];
    }
    @catch (NSException *exception) { // temp (it should return nil if outside the matrix)
        result = nil;
    }
    return result;
}


#pragma mark <PRIVATE>
// Core algorithm of MineSweeper
-(void)floodFill:(BoardCell*)startingCell{
    if ([startingCell isFillable]){
        [self setRemainingCells:_remainingCells-1];
        startingCell.status = BoardCellDiscovered;
        [self.delegate boardCell:startingCell didBecomeDiscoveredAtIndexPath:startingCell.positionInBoard];
        if (startingCell.adiacentBombs==0){
            [self floodFill:[self cellAtPostionMask:PositionNord respectToCell:startingCell]];
            [self floodFill:[self cellAtPostionMask:PositionSud respectToCell:startingCell]];
            [self floodFill:[self cellAtPostionMask:PositionWest respectToCell:startingCell]];
            [self floodFill:[self cellAtPostionMask:PositionEst respectToCell:startingCell]];
        }else{
            return;
        }
    }else{
        return;
    }
}

@end

@implementation BoardCell
@synthesize
adiacentBombs,
positionInBoard = _positionInBoard;

-(instancetype)initWithPositionInBoard:(NSIndexPath *)position{
    if (self=[super init]) {
        _positionInBoard = position;
        self.adiacentBombs = 0;
        self.status = BoardCellUnkown;
    }
    return self;
}

-(void)increaseAdiacentBombs{
    self.adiacentBombs = self.adiacentBombs+1;
}

// just easier to read
-(BOOL)isFillable{
    if (self.isBomb)return false;
    //if (self.adiacentBombs=0) return false;
    if (self.status != BoardCellUnkown) return false;
    return true;
}

-(BOOL)isBomb{
    return (self.status == BoardCellBomb ? YES : NO);
}

#pragma mark - Coding Protocol

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(adiacentBombs) forKey:@"adiacent"];
    [aCoder encodeObject:@(self.status) forKey:@"status"];
    [aCoder encodeObject:self.positionInBoard forKey:@"position"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.adiacentBombs = [[aDecoder decodeObjectForKey:@"adiacent"] integerValue];
        self.status = [[aDecoder decodeObjectForKey:@"status"]intValue];
        _positionInBoard = [aDecoder decodeObjectForKey:@"position"];
    }
    return self;
}

@end;
