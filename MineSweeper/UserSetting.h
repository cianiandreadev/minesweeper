//
//  UserSetting.h
//  MineSweeper
//
//  Created by Andrea Ciani on 14/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"

/**
 *  The UserSetting singleton provides the saving and loading system among the game. UserSetting can be used to store and retrive savings and precedent status of a game.
 */
@interface UserSetting : NSObject

/**
 *  Return a singleton instance of UserSetting.
 *
 *  @return A instance of UserSetting
 */
+(instancetype)defaultSetting;

#pragma mark - Saving System
/**
 *  Save an instance of Board. Use loadBoard to retrive it
 *
 *  @param board A Board object to save
 */
-(void)saveBoard:(Board*)board;
/**
 *  Save the status of a timer. This method can be used with saveBoard: to sabe a status of a game. Use loadSavedTime to retrive it.
 *
 *  @param time The current user time in the game.
 */
-(void)saveTime:(NSUInteger)time;

#pragma mark - Loading System
-(Board*)loadBoard;
-(NSUInteger)loadSavedTime;
@end
