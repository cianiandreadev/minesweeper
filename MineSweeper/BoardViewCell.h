//
//  BoardViewCell.h
//  MineSweeper
//
//  Created by Andrea Ciani on 14/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This class represent a single UICollectionViewCell of the board view.
 */
@interface BoardViewCell : UICollectionViewCell

/**
 *  The number of adiacent bombs. This value is shown to the user when he/she taps on the cell
 */
@property (nonatomic) NSUInteger adiacentBombsCount;

/**
 *  The color that the cell should have once discovered (i.e. red for the bombs)
 */
@property (nonatomic,strong) UIColor *status;

/**
 *  TRUE if the cell was discovered, NO otherwise
 */
@property (nonatomic,getter=isDiscovered) BOOL discovered;
/**
 *  TRUE if the cell contain a bomb, NO otherwise
 */
@property (nonatomic,getter=isBomb) BOOL bomb;
/**
 *  TRUE if the cell should show the current content (adiacent count, bomb etc...), NO otherwise. This value should be setted to TRUE when the cell is tapped or during a cheat.
 */
@property (nonatomic) BOOL contentVisible;

/**
 *  Show the current status bomb if the user tap on the cell and the cell is a bomb
 *
 *  @param show YES to show the bomb, NO otherwise
 */
-(void)showBomb:(BOOL)show;

@end
