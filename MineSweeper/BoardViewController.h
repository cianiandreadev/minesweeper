//
//  BoardViewController.h
//  MineSweeper
//
//  Created by Andrea Ciani on 14/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"

@protocol BoardViewControllerDelegate;

/**
 *  The BoardViewController handle the model of the Board. It is used to configure the interface and works as Board delegate
 */
@interface BoardViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, BoardDelegate, UIAlertViewDelegate>

/**
 *  The current board handled by the controller
 */
@property (nonatomic,strong) Board *board;

/**
 *  The BoardViewController delegate
 */
@property (nonatomic,weak) id <BoardViewControllerDelegate> delegate;

/**
 *  Permits the cheating through the visualization of the bombs
 *
 *  @param indexPaths An array of NSIndexPath that represent the coordinates of the bombs
 *  @param visible    YES if the bombs should be visible, NO otherwise
 */
-(void)bombsAtIndexPaths:(NSArray*)indexPaths makeVisible:(BOOL)visible;

@end

/**
 *  The Delegate can be used for additional methods
 */
@protocol BoardViewControllerDelegate <NSObject>

@optional
/**
 *  Called when the user wins a board AND want to save his score (i.e. on the leaderboard)
 *
 *  @param nickname The chosen nickname
 */
-(void)userWinSaveRequestedWithNickname:(NSString*)nickname;

@end