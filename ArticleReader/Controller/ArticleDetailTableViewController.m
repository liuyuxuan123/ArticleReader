//
//  ArticleDetailViewController.m
//  ArticleReader
//
//  Created by 刘宇轩 on 3/13/18.
//  Copyright © 2018 liuyuxuan. All rights reserved.
//

#import "ArticleDetailTableViewController.h"


@implementation ArticleComponentCell
@end

@implementation NewwordComponentCell
@end

@interface ArticleDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableAttributedString* problemString;
@property (strong,nonatomic) NSMutableAttributedString* newwordString;
@property (strong,nonatomic) NSMutableAttributedString* referenceString;

@property (strong,nonatomic) NSMutableAttributedString* problemCurrentString;
@property (strong,nonatomic) NSMutableAttributedString* newwordCurrentString;
@property (strong,nonatomic) NSMutableAttributedString* referenceCurrentString;

@property (strong,nonatomic) NSMutableDictionary* ProblemBasicAttribute;
@property (strong,nonatomic) NSMutableDictionary* NewwordBasicAttribute;
@property (strong,nonatomic) NSMutableDictionary* ReferenceBasicAttribute;

@property (nonatomic) int currentState;
@end

@implementation ArticleDetailTableViewController


#pragma mark - Lazy instantiation


-(void)setProblemString:(NSMutableAttributedString *)problemString{
    _problemString = problemString;
    [self.tableView reloadData];
}

-(void)setNewwordString:(NSMutableAttributedString *)newwordString{
    _newwordString = newwordString;
    [self.tableView reloadData];
}

-(void)setReferenceString:(NSMutableAttributedString *)referenceString{
    _referenceString = referenceString;
    [self.tableView reloadData];
}

-(void)setProblemCurrentString:(NSMutableAttributedString *)problemCurrentString{
    _problemCurrentString = problemCurrentString;
    [self.tableView reloadData];
    //[self reloadData];
}

-(void)setNewwordCurrentString:(NSMutableAttributedString *)newwordCurrentString{
    _newwordCurrentString = newwordCurrentString;
    [self.tableView reloadData];
    //[self reloadData];
}

-(void)setReferenceCurrentString:(NSMutableAttributedString *)referenceCurrentString{
    _referenceCurrentString = referenceCurrentString;
    [self.tableView reloadData];
    //[self reloadData];
}


-(NSMutableDictionary*)ProblemBasicAttribute{
    if(!_ProblemBasicAttribute){
        _ProblemBasicAttribute = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   NSFontAttributeName : [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:16.0]
                                                                                   }];
    }
    return _ProblemBasicAttribute;
}

-(NSMutableDictionary*)NewwordBasicAttribute{
    if(!_NewwordBasicAttribute){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        paragraphStyle.lineSpacing = 10;// 字体的行间距
        //        paragraphStyle.firstLineHeadIndent = 20.0f;//首行缩进
        paragraphStyle.alignment = NSTextAlignmentRight;
        
        _NewwordBasicAttribute = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   NSFontAttributeName : [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:16.0],
                                                                                   NSParagraphStyleAttributeName:paragraphStyle
                                                                                   
                                                                                   }];
    }
    return _NewwordBasicAttribute;
}


-(NSMutableDictionary*)ReferenceBasicAttribute{
    if(!_ReferenceBasicAttribute){
        _ReferenceBasicAttribute = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                     NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]
                                                                                     }];
    }
    return _ReferenceBasicAttribute;
}

-(void) updateUI{
    [self.tableView reloadData];
}

-(void)setRawString:(NSString *)problem newWord:(NSString *)newword reference:(NSString *)reference{
    self.problemString = [[NSMutableAttributedString alloc] initWithString:problem attributes:self.ProblemBasicAttribute];
    self.problemCurrentString = [self.problemString mutableCopy];
    
    self.newwordString = [[NSMutableAttributedString alloc] initWithString:newword attributes:self.NewwordBasicAttribute];
    self.newwordCurrentString = [self.newwordString mutableCopy];
    
    self.referenceString = [[NSMutableAttributedString alloc] initWithString:reference attributes:self.ReferenceBasicAttribute];
    self.referenceCurrentString = [self.referenceString mutableCopy];
    
    [self updateUI];
}


#pragma mark - View life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.currentState = 0;
    
    PinterestSegment* segmentedSlider = [[PinterestSegment alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 100, self.view.frame.size.width - 40, 40) titles:@[@"Blank",@"Level 0", @"Level 1", @"Level 2", @"Level 3", @"Level 4", @"Level 5", @"Level 6"]];
    
    segmentedSlider.delegate = self;
    [self.view addSubview:segmentedSlider];
    
}



#pragma mark - Pinterest Segment Delegate
-(void)pinterestSegmentDidTapAt:(NSInteger)at{
    
    [self changeDataSourceTo:at];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)changeDataSourceTo:(NSInteger)at{
    if(at > 0){
        self.currentState = (int)at;
        
        //        NSArray* levelWords = [[NSUserDefaults standardUserDefaults] objectForKey:@"level"][at - 1];
        NSMutableArray* lowerLevelWords = [[NSMutableArray alloc]init];
        for(int i = 0;i < at;i++){
            
            [lowerLevelWords addObjectsFromArray: [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%d",@"level",i]]];
        }
        
        NSMutableArray* rangesOfWordsInProblem = [NSMutableArray array];
        NSMutableArray* rangesOfWordsInNewword = [NSMutableArray array];
        for(id word in lowerLevelWords){
            NSRange wordRangeInProblem = [self.problemString.string rangeOfString:word options:NSCaseInsensitiveSearch];
            if(wordRangeInProblem.location != NSNotFound){
                //NSLog(@"Word:%@ AT:%@",word,NSStringFromRange(wordRangeInProblem));
                [rangesOfWordsInProblem addObject:NSStringFromRange(wordRangeInProblem)];
            }
            
            NSRange wordRangeInNewword = [self.newwordString.string rangeOfString:word options:NSCaseInsensitiveSearch];
            if(wordRangeInNewword.location != NSNotFound){
                 NSLog(@"Word:%@ AT:%@",word,NSStringFromRange(wordRangeInNewword));
                [rangesOfWordsInNewword addObject:NSStringFromRange(wordRangeInNewword)];
            }
            
            
        }
        NSMutableAttributedString* problemHightedString = [self.problemString mutableCopy];
        
        NSMutableDictionary* attributeOfProblemHightedString = [self.ProblemBasicAttribute mutableCopy];
        [attributeOfProblemHightedString setObject:[UIColor blackColor] forKey:NSBackgroundColorAttributeName];
        [attributeOfProblemHightedString setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        for(id rangeOfWord in rangesOfWordsInProblem){
            NSRange wordRange = NSRangeFromString(rangeOfWord);
            [problemHightedString setAttributes:attributeOfProblemHightedString range:wordRange];
        }
        self.problemCurrentString = problemHightedString;
        
        
        
        NSMutableAttributedString* newwordHightedString = [self.newwordString mutableCopy];
        
        NSMutableDictionary* attributeOfNewwordHightedString = [self.NewwordBasicAttribute mutableCopy];
        [attributeOfNewwordHightedString setObject:[UIColor redColor] forKey:NSBackgroundColorAttributeName];
        [attributeOfNewwordHightedString setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        for(id rangeOfWord in rangesOfWordsInNewword){
            NSRange wordRange = NSRangeFromString(rangeOfWord);
            [newwordHightedString setAttributes:attributeOfNewwordHightedString range:wordRange];
        }
        self.newwordCurrentString = newwordHightedString;
        
    }else{
        
        self.problemCurrentString = self.problemString;
        self.newwordCurrentString = self.newwordString;
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if(indexPath.section == 0){
        NewwordComponentCell  *cell = (NewwordComponentCell*)[tableView dequeueReusableCellWithIdentifier:@"NewwordComponentCell"];
        cell.titleLabel.attributedText = self.problemCurrentString;
        return cell;
    }else if(indexPath.section == 1){
        ArticleComponentCell  *cell = (ArticleComponentCell*)[tableView dequeueReusableCellWithIdentifier:@"ArticleComponentCell"];
        
        cell.titleLabel.attributedText = self.newwordCurrentString;
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        //[a-zA-Z]+
        
        NSError *error;
        NSString *regulaStr = @"[a-zA-Z]{1,}[-| ]?[a-zA-Z]{2,}";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:self.newwordString.string
                                                    options:0
                                                      range:NSMakeRange(0, [self.newwordString length])];
        
        
        for (NSTextCheckingResult *match in arrayOfAllMatches) {
            NSString *substringForMatch = [self.newwordString.string substringWithRange:match.range];
            if(![substringForMatch isEqualToString:@"adj"] && ![substringForMatch isEqualToString:@"adv"]){
                
                [cell.titleLabel addLinkToPhoneNumber:substringForMatch withRange:match.range];
            }
        }
        cell.titleLabel.delegate = self;
        return cell;
    }else{
        NewwordComponentCell  *cell = (NewwordComponentCell*)[tableView dequeueReusableCellWithIdentifier:@"NewwordComponentCell"];
        cell.titleLabel.attributedText = self.referenceCurrentString;
        return cell;
    }
    
    
    
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString* result = @"";
    if(section == 0){
        result = @"听录音，然后回答以下问题";
    }else if(section == 1){
        result = @"生词和短语";
    }else if(section == 2){
        result = @"参考译文";
    }
    return result;
}

#pragma mark - Table view delegate
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return NO;
}

#pragma mark - TTTAttributedLabel delegate
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
    
    NSLog(@"CALLED !!! %@",phoneNumber );
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:@"word"][phoneNumber];
    
    if(value){
        int level = [value intValue];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:phoneNumber
                                                                       message:[NSString stringWithFormat:@"%@'s level is %d",phoneNumber,level]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"熟悉" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  if (level < 6){
                                                                      NSMutableArray* wordsAtLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%d",@"level",level + 1]] mutableCopy];
                                                                      
                                                                      [wordsAtLevel addObject:phoneNumber];
                                                                      
                                                                      [[NSUserDefaults standardUserDefaults] setObject:wordsAtLevel forKey:[NSString stringWithFormat:@"%@%d",@"level",level + 1]];
                                                                      
                                                                     
                                                                      NSMutableArray* wordsAtOriginLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%d",@"level",level]] mutableCopy];
                                                                      [wordsAtOriginLevel removeObject:phoneNumber];
                                                                     
                                                                      [[NSUserDefaults standardUserDefaults] setObject:wordsAtOriginLevel forKey:[NSString stringWithFormat:@"%@%d",@"level",level]];
                                                                      
                                                                      NSMutableDictionary* wordsDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"word"] mutableCopy];
                                                                      
                                                                      //wordsDic[phoneNumber] = @(level + 1);
                                                                      [wordsDic setObject:@(level + 1) forKey:phoneNumber];
                                                                      [[NSUserDefaults standardUserDefaults] setObject:wordsDic forKey:@"word"];
                                                                     
                                                                      [self changeDataSourceTo:self.currentState];
                                                                      [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                                      
                                                                  }
                                                              }];
        UIAlertAction* noneAction = [UIAlertAction actionWithTitle:@"见过" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                    
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"没见过" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 if (level > 0){
                                                                     NSMutableArray* wordsAtLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%d",@"level",level - 1]] mutableCopy];
                                                                     
                                                                     [wordsAtLevel addObject:phoneNumber];
                                                                     
                                                                     [[NSUserDefaults standardUserDefaults] setObject:wordsAtLevel forKey:[NSString stringWithFormat:@"%@%d",@"level",level - 1]];
                                                                     
                                                                     NSMutableArray* wordsAtOriginLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%d",@"level",level]] mutableCopy];
                                                                     [wordsAtOriginLevel removeObject:phoneNumber];
                                                                     
                                                                     [[NSUserDefaults standardUserDefaults] setObject:wordsAtOriginLevel forKey:[NSString stringWithFormat:@"%@%d",@"level",level]];
                                                                     
                                                                     NSMutableDictionary* wordsDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"word"] mutableCopy];
                                                                     wordsDic[phoneNumber] = @(level - 1);
                                                                     [[NSUserDefaults standardUserDefaults] setObject:wordsDic forKey:@"word"];
                                                                 }
                                                             }];
        [alert addAction:defaultAction];
        [alert addAction:noneAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
//    }else{
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:phoneNumber
//                                                                       message:[NSString stringWithFormat:@"%@ is %d",phoneNumber,level]
//                                                                preferredStyle:UI];
//
//    }
    
}



@end


