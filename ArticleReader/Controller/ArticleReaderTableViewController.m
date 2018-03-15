//
//  ArticleReaderTableViewController.m
//  ArticleReader
//
//  Created by 刘宇轩 on 3/12/18.
//  Copyright © 2018 liuyuxuan. All rights reserved.
//
#import "ArticleParser.h"
#import "ArticleReaderTableViewController.h"
#import "ArticleDetailTableViewController.h"
#import "BaseSQLiteManager.h"


@interface ArticleReaderTableViewController ()

// Divide the whole book into units
@property (nonatomic,strong) NSArray<NSArray*>* unitsLesson;


@end

@implementation ArticleReaderTableViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    BaseSQLiteContext* currentContext = [BaseSQLiteManager openSQLiteWithName:@"articleReader"];
    
    NSMutableArray* temporaryUnitArray = [[NSMutableArray alloc] init];
    [currentContext selectKeys:@[@{@"unit":@"integer"}] fromTable:@"articleDocument" orderBy:nil orderType:nil whileStr:nil callBack:^(NSArray<NSDictionary *> *dataArray, BaseSQLError *error) {
        for(NSDictionary* item in dataArray){
            if ( ![temporaryUnitArray containsObject:item[ARTICLEPARSER_UNIT]]){
                [temporaryUnitArray addObject:item[ARTICLEPARSER_UNIT]];
            }
        }
    }];
    
    for(id unit in temporaryUnitArray){
        int unitIndex = [unit intValue];
        [currentContext selectKeys:@[@{@"lesson":@"integer"}] fromTable:@"articleDocument" orderBy:nil orderType:nil whileStr:[NSString stringWithFormat:@"unit = %d",unitIndex] callBack:^(NSArray<NSDictionary *> *dataArray, BaseSQLError *error) {
            NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
            //NSLog(@"lesson %@",dataArray);
            for(id lesson in dataArray){
                [tmpArray addObject:lesson[ARTICLEPARSER_LESSON]];
            }
            
            NSMutableArray* tmpArrays = [NSMutableArray arrayWithArray:self.unitsLesson];
            [tmpArrays addObject:tmpArray];
            self.unitsLesson = [tmpArrays copy];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // the number of units
    return [self.unitsLesson count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // the number of lessons in each unit
    return [self.unitsLesson[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleNameCell" forIndexPath:indexPath];
    BaseSQLiteContext* currentContext = [BaseSQLiteManager openSQLiteWithName:@"articleReader"];
    [currentContext selectKeys:@[@{@"englishtitle":@"text"},@{@"chinesetitle":@"text"}] fromTable:@"articleDocument" orderBy:nil orderType:nil whileStr:[NSString stringWithFormat:@"lesson = %d",[self.unitsLesson[indexPath.section][indexPath.row] intValue]] callBack:^(NSArray<NSDictionary *> *dataArray, BaseSQLError *error) {
        cell.textLabel.text = [dataArray firstObject][ARTICLEPARSER_ENGLISHTITLE];
        cell.detailTextLabel.text = [dataArray firstObject][ARTICLEPARSER_CHINESETITLE];
    }];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // unit name
    return [NSString stringWithFormat:@"Unit%ld",section + 1];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[UITableViewCell class]]){
        
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath){
            if ([segue.destinationViewController isKindOfClass:[ArticleDetailTableViewController class]]){
                ArticleDetailTableViewController* destinationVC = (ArticleDetailTableViewController*)segue.destinationViewController;
                BaseSQLiteContext* currentContext = [BaseSQLiteManager openSQLiteWithName:@"articleReader"];
                [currentContext selectKeys:@[@{@"problem":@"text"},@{@"reference":@"text"},@{@"newword":@"text"},@{@"englishtitle":@"text"},@{@"chinesetitle":@"text"}] fromTable:@"articleDocument" orderBy:nil orderType:nil whileStr:[NSString stringWithFormat:@"lesson = %d",[self.unitsLesson[indexPath.section][indexPath.row] intValue]] callBack:^(NSArray<NSDictionary *> *dataArray, BaseSQLError *error) {
                    
                    NSString* problem = [dataArray firstObject][ARTICLEPARSER_PROBLEM];
                    NSString* newword = [dataArray firstObject][ARTICLEPARSER_NEWWORD];
                    NSString* reference = [dataArray firstObject][ARTICLEPARSER_REFERENCE];
                    NSString* englishtitle = [dataArray firstObject][ARTICLEPARSER_ENGLISHTITLE];
                    //NSString* chinesetitle = [dataArray firstObject][ARTICLEPARSER_CHINESETITLE];
                    
                    [destinationVC setRawString:problem newWord:newword reference:reference];
                    destinationVC.navigationItem.title = englishtitle;
                    
                }];
            }
        }
    }
}


@end
