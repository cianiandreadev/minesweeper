//
//  LeaderboardTableViewController.m
//  MineSweeper
//
//  Created by Andrea Ciani on 17/04/15.
//  Copyright (c) 2015 Ciani Andrea. All rights reserved.
//

#import "LeaderboardTableViewController.h"
#import "AppDelegate.h"
#import "LeaderboardEntry.h"

@interface LeaderboardTableViewController (){
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *_fetchResultController;
    
    NSDateFormatter *_dateFormatter;
}

@end

@implementation LeaderboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Your Leaderboard";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    
    _dateFormatter = [[NSDateFormatter alloc]init];
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    managedObjectContext = appDelegate.managedObjectContext;
    
    _fetchResultController = [self fetchResultController];
    
    
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSFetchedResultsController*)fetchResultController{
    if (_fetchResultController == nil){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"LeaderboardEntry" inManagedObjectContext:managedObjectContext]];
        // Configure the request's entity, and optionally its predicate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                                  initWithFetchRequest:fetchRequest
                                                  managedObjectContext:managedObjectContext
                                                  sectionNameKeyPath:nil
                                                  cacheName:nil];
        _fetchResultController = controller;
    }
    
    [_fetchResultController performFetch:nil]; // handle error here!
    return _fetchResultController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_fetchResultController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchResultController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    LeaderboardEntry *obj = [_fetchResultController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ sec",obj.score.stringValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"By %@ on %@",obj.player,[_dateFormatter stringFromDate:obj.date]];
    
    return cell;
}

-(IBAction)dismissLeaderboard:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
