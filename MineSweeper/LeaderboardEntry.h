//
//  LeaderboardEntry.h
//  MineSweeper
//
//  Created by Andrea Ciani on 16/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  The LeaderboardEntry is the CoreData representation (subclass of ManagedObject) of a single entry in the leaderBoard. Use this class to save a single entry in the leaderboard.
 */
@interface LeaderboardEntry : NSManagedObject

/**
 *  The player name, as "sign" of the record.
 */
@property (nonatomic, retain) NSString * player;
/**
 *  The time needed to the player to win the game (less is better)
 */
@property (nonatomic, retain) NSNumber * score;
/**
 *  The date in which the record was scored 
 */
@property (nonatomic, retain) NSDate * date;

@end
