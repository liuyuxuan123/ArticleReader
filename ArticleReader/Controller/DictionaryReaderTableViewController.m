//
//  DictionaryReaderTableViewController.m
//  ArticleReader
//
//  Created by 刘宇轩 on 3/12/18.
//  Copyright © 2018 liuyuxuan. All rights reserved.
//

#import "DictionaryReaderTableViewController.h"


@interface DictionaryReaderTableViewController ()

// the actual dictionary
@property (strong,nonatomic) NSDictionary* wordDictionary;

// divide the actual dictionary into array
// alphabetDictionary[0] ----> Array of words start with 'a'
// alphabetDictionary[1] ----> Array of words start with 'b'
// ......
// alphabetDictionary[25] ---> Array of words start with 'z'
@property (strong,nonatomic) NSMutableDictionary* alphabetDictionary;


@end

@implementation DictionaryReaderTableViewController

#pragma mark - Lazy Instantiation

-(NSMutableDictionary*)alphabetDictionary{
    if(!_alphabetDictionary){
        _alphabetDictionary = [[NSMutableDictionary alloc] init];
        for(int i = 0;i < 26;i++){
            [_alphabetDictionary setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'a' + i]];
        }
    }
    return _alphabetDictionary;
}




-(void)setWordDictionary:(NSDictionary *)wordDictionary{
    _wordDictionary  = wordDictionary;
    
    // Every time the wordDictionary is reseted ---> recalculate alphabetDictionary
    self.alphabetDictionary = [[NSMutableDictionary alloc] init];
    for(int i = 0;i < 26;i++){
        [self.alphabetDictionary setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'a' + i]];
    }
   
    for(NSString* dictionaryKey in _wordDictionary){
        NSMutableArray* alphabetArray = [self.alphabetDictionary objectForKey:[dictionaryKey substringWithRange:NSMakeRange(0, 1)]] ;
        [alphabetArray addObject:dictionaryKey];
    }
    // Sort so that the table view's data will be ordered
    for(int i = 0;i < 26;i++){
        NSMutableArray* alphabetArray = [self.alphabetDictionary objectForKey:[NSString stringWithFormat:@"%c",'a' + i]];
        [alphabetArray sortUsingSelector:@selector(caseInsensitiveCompare:)];
    }
    // Every time the wordDictionary is reseted ---> reload data from alphabetDictionary
    [self.tableView reloadData];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.wordDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"word"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.wordDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"word"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.alphabetDictionary.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count = 0;
    NSArray* wordArray = [self.alphabetDictionary objectForKey:[NSString stringWithFormat:@"%c",'a' + (int)section]];
    count = [wordArray count];
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DictionaryEntryCell" forIndexPath:indexPath];

    
    NSArray* wordArray = [self.alphabetDictionary objectForKey:[NSString stringWithFormat:@"%c",'a' + (int)indexPath.section]];
    NSString* title = wordArray[indexPath.row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[self.wordDictionary[title] intValue]];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%c",'a' + (int)section];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


@end
