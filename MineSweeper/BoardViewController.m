//
//  BoardViewController.m
//  MineSweeper
//
//  Created by Andrea Ciani on 14/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import "BoardViewController.h"
#import "BoardViewCell.h"

#define OFFSET 2

const int alertViewWinTag = 10;
const int alertViewLoseTag = 5;

@interface BoardViewController ()

@end

@implementation BoardViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[BoardViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
    [_board setDelegate:self];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)bombsAtIndexPaths:(NSArray*)indexPaths makeVisible:(BOOL)visible{
    for (NSIndexPath *indexPath in indexPaths) {
        [((BoardViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[indexPath indexAtPosition:1] inSection:[indexPath indexAtPosition:0]]]) setContentVisible:visible];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _board.width;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _board.height;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BoardViewCell *cell = (BoardViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    BoardCell *boardCell = [self.board boardCellAtIndexPath:indexPath];
    
    if (boardCell.status == BoardCellDiscovered) [cell setDiscovered:YES];
    
    cell.adiacentBombsCount = [boardCell adiacentBombs];
    [cell setBomb:[boardCell isBomb]];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected Cell (%i,%i)",(int)indexPath.section,(int)indexPath.row) ;
    
    //BoardCell *cell = (BoardCell*) [collectionView cellForItemAtIndexPath:indexPath];
    
    [self.board tapCellAtIndexPath:indexPath];
}

#pragma mark - FlowDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView setNeedsLayout];
    [collectionView setNeedsDisplay];
    
    float edgeX = (collectionView.frame.size.width-((_board.width+1)*OFFSET))/_board.width;

    return CGSizeMake(edgeX, edgeX);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(OFFSET, OFFSET/2, 0, OFFSET/2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return OFFSET;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return OFFSET;
}


#pragma mark - BoardDelegate

-(void)boardCell:(BoardCell*)cell didBecomeDiscoveredAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"discovered cell(%@) :[%i]",cell.positionInBoard.description, (int)cell.adiacentBombs);
    BoardViewCell *boardViewCell = (BoardViewCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
    [boardViewCell setDiscovered:YES];
}
-(void)userFindBombAtIndexPath:(NSIndexPath*)indexPath{
    BoardViewCell *boardViewCell = (BoardViewCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
    [boardViewCell showBomb:YES];
}
-(void)userWins{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"You Win!!" message:@"If you want to save your result in the leaderboard insert your name and press ok!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [alert setTag:alertViewWinTag];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}
-(void)userLose{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You lose" message:@"Try again, you'd be more lucky!" delegate:self cancelButtonTitle:@"Ok :-(" otherButtonTitles: nil];
    [alert show];
    [alert setTag:alertViewLoseTag];
}

#pragma mark - AlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag]==alertViewWinTag && buttonIndex==1) {
        // save here!
        if ([self.delegate respondsToSelector:@selector(userWinSaveRequestedWithNickname:)])
            [self.delegate userWinSaveRequestedWithNickname:[alertView textFieldAtIndex:0].text];
    }
    if ([alertView tag]==alertViewLoseTag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
