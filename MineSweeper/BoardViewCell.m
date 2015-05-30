//
//  BoardViewCell.m
//  MineSweeper
//
//  Created by Andrea Ciani on 14/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import "BoardViewCell.h"

@interface BoardViewCell (){
    UILabel *_contentCellLabel;
}

@end

@implementation BoardViewCell

@synthesize
adiacentBombsCount = _adiacentBombsCount,
status = _status,
discovered=_discovered,
bomb = _bomb,
contentVisible = _contentVisible;


-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        // nil maps to false for booleans, no init
        _adiacentBombsCount = 0;
        [self setUnknown];
        
        // Number that display the adiacent bombs
        _contentCellLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_contentCellLabel setTextAlignment:NSTextAlignmentCenter];
        [_contentCellLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentCellLabel];
        [self setContentVisible:NO];
    }
    return self;
}

-(void)setAdiacentBombsCount:(NSUInteger)adiacentBombsCount{
    if (self.isBomb) return;
    _adiacentBombsCount = adiacentBombsCount;
    _contentCellLabel.text = [NSString stringWithFormat:@"%i",(int)_adiacentBombsCount];
}

-(void)setBomb:(BOOL)bomb{
    if (bomb) {
        _contentCellLabel.text = @"!!!";
    }
}

// Starting state
-(void)setUnknown{
    self.backgroundColor = [UIColor darkGrayColor];
}

-(void)setDiscovered:(BOOL)discovered{
    if(discovered){
        // here show numbers
        self.backgroundColor = [UIColor lightGrayColor];
        self.userInteractionEnabled = false;
        _status = self.backgroundColor;
    }else{
        self.backgroundColor = _status;
    }
    _discovered = discovered;
    [self setContentVisible:_discovered];
}

-(void)showBomb:(BOOL)show{
    if(show){
        self.backgroundColor = [UIColor redColor];
    }else{
        self.backgroundColor = _status;
    }
}

-(void)setContentVisible:(BOOL)contentVisible{
    _contentVisible = contentVisible;
    [_contentCellLabel setHidden:!_contentVisible];
}

@end
