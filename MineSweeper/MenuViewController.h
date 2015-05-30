//
//  MenuViewController.h
//  MineSweeper
//
//  Created by Andrea Ciani on 14/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This calss manage the starting menu of the app
 */
@interface MenuViewController : UIViewController <UIActionSheetDelegate>

/**
 *  Called when the user want to start a new game
 *
 *  @param sender The sender object
 */
-(IBAction)newGamePressed:(id)sender;

/**
 *  Called when the user want to retrieve a saved game
 *
 *  @param sender The sender object
 */
-(IBAction)loadGamePressed:(id)sender;

@end
