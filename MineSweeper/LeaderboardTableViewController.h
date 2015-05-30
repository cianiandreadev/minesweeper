//
//  LeaderboardTableViewController.h
//  MineSweeper
//
//  Created by Andrea Ciani on 17/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/**
 *  The LeaderboardTableViewController manages the leaderboard and the coredata persistent store to build the leaderboard view.
 */
@interface LeaderboardTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

/**
 *  Called when the user want to dismiss the view
 *
 *  @param sender The sender object
 */
-(IBAction)dismissLeaderboard:(id)sender;

@end
