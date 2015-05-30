//
//  UserSetting.m
//  MineSweeper
//
//  Created by Andrea Ciani on 14/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import "UserSetting.h"

#pragma mark - Keys

#define standard [NSUserDefaults standardUserDefaults] // for fast usage of userdefaults.

NSString *const kUDBoard = @"kUDBoard";
NSString *const kUDTime = @"kUDTime";

#pragma mark -

@implementation UserSetting

+(instancetype)defaultSetting{
    static dispatch_once_t onceToken;
    static UserSetting *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserSetting alloc] init];
    });
    return sharedInstance;
}

-(Board*)loadBoard{
    NSData *boardData = [standard objectForKey:kUDBoard];
    Board* board = [NSKeyedUnarchiver unarchiveObjectWithData:boardData];
    return board;
}

-(NSUInteger)loadSavedTime{
    return [[standard objectForKey:kUDTime] unsignedIntegerValue];
}


-(void)saveTime:(NSUInteger)time{
    [standard setObject:@(time) forKey:kUDTime];
}

-(void)saveBoard:(Board *)board{
    NSData *boardData = [NSKeyedArchiver archivedDataWithRootObject:board];
    [standard setObject:boardData forKey:kUDBoard];
}

@end
