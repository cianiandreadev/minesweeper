//
//  MenuViewController.m
//  MineSweeper
//
//  Created by Andrea Ciani on 14/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import "MenuViewController.h"
#import "UserSetting.h"
#import "GameViewController.h"

#define LOAD_SEGUE_ID @"loadGameSegue"
#define NEWGAME_SEGUE_ID @"newGameSegue"

@interface MenuViewController (){
    Board *_currentBoard;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    // if the segue is the "loading segue" and I have no board saved prevent segue and show a message.
    if([identifier isEqualToString:LOAD_SEGUE_ID] && [[UserSetting defaultSetting] loadBoard]==nil){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No saved game found" message:@"You have not saved any game yet. To save a game play a match and close the match, choosing 'save match'" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:LOAD_SEGUE_ID]) {
        GameViewController *next = (GameViewController*) [segue destinationViewController];
        [next setCurrentBoard:_currentBoard];
        [next setPlayingTime:@([[UserSetting defaultSetting] loadSavedTime])];
    }
    if ([segue.identifier isEqualToString:NEWGAME_SEGUE_ID]) {
        GameViewController *next = (GameViewController*) [segue destinationViewController];
        next.currentBoard = _currentBoard;
    }
}
 // The creation of the board is demanded to the delegate of the actionsheet this time, becuase the user need to choose the difficulty
-(IBAction)newGamePressed:(id)sender{
    UIActionSheet *chooses = [[UIActionSheet alloc]initWithTitle:@"Choose Difficulty" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Hard",@"Medium",@"Easy",nil];
    [chooses showInView:self.view];
}

-(IBAction)loadGamePressed:(id)sender{
    _currentBoard = [[UserSetting defaultSetting] loadBoard];
    [self performSegueWithIdentifier:LOAD_SEGUE_ID sender:self];

}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==2){ // easy
        _currentBoard = [[Board alloc]initWithWidth:8 height:8];
        [_currentBoard insertBombs:5];
    }
    if (buttonIndex==1){ // medium
        _currentBoard = [[Board alloc]initWithWidth:8 height:8];
        [_currentBoard insertBombs:10];
    }
    if (buttonIndex==0){ // hard
        _currentBoard = [[Board alloc]initWithWidth:12 height:12];
        [_currentBoard insertBombs:40];
    }
    if (buttonIndex==3)return;
    
    [self performSegueWithIdentifier:NEWGAME_SEGUE_ID sender:self];
}

@end
