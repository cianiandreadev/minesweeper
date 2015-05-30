//
//  ViewController.m
//  MineSweeper
//
//  Created by Andrea Ciani on 13/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import "GameViewController.h"
#import "Board.h"

//saving
#import "AppDelegate.h" // CD reference
#import "LeaderboardEntry.h"
#import "UserSetting.h"
//--

@interface GameViewController (){
    BoardViewController *_currentBoardViewController;
    NSTimer *_timerCounter;
}

/**
 *  Bool that track the playing. Init in true, become false when user win/lose.
 */
@property (nonatomic,getter=isPlaying) BOOL playing;

@end

@implementation GameViewController
@synthesize
currentBoard = _currentBoard,
playingTime = _playingTime,
playing = _playing;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self observeValueForKeyPath:@"playing" ofObject:self change:nil context:nil];
    
    // Retrive somewhere the board
    
    [_currentBoard addObserver:self forKeyPath:@"remainingCells" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    _timerCounter = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTime) userInfo:nil repeats:YES];

    if (!self.playingTime)[self setPlayingTime:@(0)];
    
    [self setPlaying:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userWin) name:kBoardUserWinNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLose) name:kBoardUserLoseNotification object:nil];
    
}

-(void)setPlayingTime:(NSNumber*)time{
    _playingTime = time;
    self.ibTimeLabel.text = [NSString stringWithFormat:@"%@",self.playingTime.stringValue];
}

-(void)increaseTime{
    [self setPlayingTime:@(_playingTime.doubleValue+1)];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"remainingCells"]){
        self.ibRimainingCell.text = [NSString stringWithFormat:@"%i",(int)_currentBoard.remainingCells];
    }
}

-(void)setPlaying:(BOOL)playing{
    if (playing) {
        [_timerCounter fire];
    }else{
        [_timerCounter invalidate];
    }
    _playing = playing;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"BoardViewSegue"]) {
        if (!_currentBoard){ // If we don't have any board yet we create a standard one
            _currentBoard = [[Board alloc]initWithWidth:8 height:8];
            [_currentBoard insertBombs:10];
        }
    
        self.ibRimainingCell.text = [NSString stringWithFormat:@"%i",(int)_currentBoard.remainingCells];
        BoardViewController *dest = (BoardViewController*)segue.destinationViewController;
        _boardViewController = dest;
        [_boardViewController setDelegate:self];
        dest.board = _currentBoard;
    }
}

-(IBAction)cheatButtonPressed:(UIButton*)sender{
    [sender setSelected:!sender.isSelected]; //toggle
    [_boardViewController bombsAtIndexPaths:_currentBoard.bombCells makeVisible:sender.isSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backView:(id)sender{
    
    if (self.isPlaying) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Do you want to save your game?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
        [alert setTag:10];
        [alert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [_currentBoard removeObserver:self forKeyPath:@"remainingCells"];
}

#pragma mark Alertview Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 10 && buttonIndex==1){ // Save board
        [[UserSetting defaultSetting]saveBoard:_currentBoard];
        [[UserSetting defaultSetting]saveTime:self.playingTime.unsignedIntegerValue];
    }
}

#pragma mark - BoardViewControllerDelegate

-(void)userWin{
    [self setPlaying:NO];    
}

-(void)userLose{
    [self setPlaying:NO];
}

-(void)userWinSaveRequestedWithNickname:(NSString *)nickname{
    if (nickname.length==0)nickname = @"Unknown";
    
    AppDelegate *ad = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *moc = ad.managedObjectContext;
    
    LeaderboardEntry *entry = [[LeaderboardEntry alloc]initWithEntity:[NSEntityDescription entityForName:@"LeaderboardEntry" inManagedObjectContext:moc] insertIntoManagedObjectContext:moc];
    
    entry.score = self.playingTime;
    entry.player = nickname;
    entry.date = [NSDate date];
    
    [moc save:nil]; // Here I should handle better the error...
    
    NSLog(@"Requeste save with name: %@",nickname);
    
}

@end
