//
//  ViewController.h
//  MineSweeper
//
//  Created by Andrea Ciani on 13/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"

/**
 *  The GameViewController control the game behavior exept the behaviour of the board
 @see BoardViewController for the controller of board.
 */
@interface GameViewController : UIViewController <BoardViewControllerDelegate,UIAlertViewDelegate>

#pragma mark -
#pragma mark IBOutlets
/**
 *  The facebutton. This can be used for additional control
 */
@property (strong, nonatomic) IBOutlet UIButton *ibFaceButton;
/**
 *  The label that shows the number of cell remaining to discover
 */
@property (strong, nonatomic) IBOutlet UILabel *ibRimainingCell;
/**
 *  The label that show the current time of the user
 */
@property (strong, nonatomic) IBOutlet UILabel *ibTimeLabel;

#pragma mark Properties
/**
 *  The BoardController that manage the board in the view
 */
@property (strong, nonatomic) BoardViewController *boardViewController;
/**
 *  The current board handled by the BoardViewController
 */
@property (strong, nonatomic) Board *currentBoard;
/**
 *  The current play time of the player
 */
@property (strong, nonatomic) NSNumber* playingTime;

#pragma mark -
/**
 *  Called when the user want to show the bombs. It used the value "selected" of the cheatButton to hide/show the bombs
 *
 *  @param sender The button sender.
 */
-(IBAction)cheatButtonPressed:(UIButton*)sender;

/**
 *  Called when the user want to dismiss the game. A popup is shown to ask the user if he/she want to save the current game if the current game is not still end
 *
 *  @param sender The button sender
 */
-(IBAction)backView:(id)sender;


@end

