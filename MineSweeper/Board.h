//
//  Board.h
//  MineSweeper
//
//  Created by Andrea Ciani on 13/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notification sent when the user wins
#define kBoardUserWinNotification @"kBoardUserWinNotification"
// Notification sent when the user lose
#define kBoardUserLoseNotification @"kBoardUserLoseNotification"

@protocol BoardDelegate;

@class BoardCell;

/**
 *  The Board is the model representation (conform to NSCoding) of the status of a single game board. You can create a new board with initWithWidth:Height and use insertBombs: to fill with random bombs.
The BoardDelegate is mandatory for communicate with the board after an user action.
 */
@interface Board : NSObject <NSCoding>

/**
 *  The number of 'horizontal' squares in the board
 */
@property (nonatomic,readonly) NSUInteger width;
/**
 *  The number of 'vertical' squares in the board
 */
@property (nonatomic,readonly) NSUInteger height;
/**
 *  The number of bombs inside the board
 */
@property (nonatomic,readonly) NSUInteger numberOfBombs;
/**
 *  The number of "still unknown" cells (bombs not considered)
 */
@property (nonatomic) NSUInteger remainingCells;

/**
 *  Array of NSIndexPath with the coordinate of the bombs
 */
@property (nonatomic,readonly) NSMutableArray *bombCells;

/**
 *  The Board Delegate.
 */
@property (nonatomic,weak) id <BoardDelegate> delegate;

/**
 *  Create a new Board with given parameters
 *
 *  @param width  The number of 'horizontal' cell
 *  @param height The number of 'vertical' cell
 *
 *  @return Return a new board with NO bombs inside (use insertBombs: to fill the board).
 */
-(instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height;

/**
 *  Insert a given number of bombs in the board, randomly
 *
 *  @param bombs The number of bombs to insert in the board
 */
-(void)insertBombs:(NSUInteger)bombs;

/**
 *  Notify the board that a user has just tapped in a specified cell
 *
 *  @param path The NSIndexPath that represent the position of the tap
 */
-(void)tapCellAtIndexPath:(NSIndexPath*)path;

/**
 *  Return the cell contained in a gived indexPath
 *
 *  @param indexPath A position in the board where retrieve the BoardCell
 *
 *  @return Return a BoardCell instance
 */
-(BoardCell*)boardCellAtIndexPath:(NSIndexPath*)indexPath;

@end

/**
 *  The BoardDelegate is used to communicate with the board after a user tap, in order to know which action and conseguences a tap has created.
 Use boardCell:didBecomeDiscoveredAtIndexPath: to uncover the cell in the user interface.
 */
@protocol BoardDelegate <NSObject>

@required
/**
 *  This method tells to the delegate that some cell has just been discovered and should become visible in the interface
 *
 *  @param cell      The cell just discovered
 *  @param indexPath The indexPath of the cell
 */
-(void)boardCell:(BoardCell*)cell didBecomeDiscoveredAtIndexPath:(NSIndexPath*)indexPath;
/**
 *  Called when the user just tapped a cell where is stored a bomb.
 *
 *  @param indexPath The position where the bombs is found.
 */
-(void)userFindBombAtIndexPath:(NSIndexPath*)indexPath;
@required
/**
 *  Called when the user wins
 */
-(void)userWins;
@required
/**
 *  Called when the user lose
 */
-(void)userLose;

@end

typedef enum {
    BoardCellUnkown, // not jet discoverd
    BoardCellDiscovered, // discovered
    BoardCellBomb, // the cell contain a bomb
}BoardCellStatus;

/**
 *  BoardCell class represent a single model representation of a cell inside the board. Conform to NSCoding for saving.
 */
@interface BoardCell : NSObject <NSCoding>

/**
 *  The BoardCellStatus of the cell
 */
@property (nonatomic) BoardCellStatus status;
/**
 *  The number of adiacentBombs in all directions
 */
@property (nonatomic) NSUInteger adiacentBombs;
/**
 *  The position of the cell in the board
 */
@property (nonatomic,readonly) NSIndexPath *positionInBoard;

/**
 *  Create a new cell with given parameters
 *
 *  @param position The position of the cell
 *
 *  @return Return a new cell with a given position and an BoardCellUnkown status
 */
-(instancetype)initWithPositionInBoard:(NSIndexPath*)position;

/**
 *  Increase the number of adiacentBombs of 1.
 */
-(void)increaseAdiacentBombs;
/**
 *  Return if the current cell contains a bombs
 *
 *  @return Return YES if the cell contain a bomb, NO otherwise
 */
-(BOOL)isBomb;
/**
 *  Return the status of the current Cell. Fillable means that the current cell could be filled during the floodFill algorithm (usually fillable mean that the cell has a number of adiacent cell of 0).
 *
 *  @return YES if fillable, NO otherwise.
 */
-(BOOL)isFillable;

@end
