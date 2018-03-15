//
//  AppDelegate.m
//  ArticleReader
//
//  Created by 刘宇轩 on 3/12/18.
//  Copyright © 2018 liuyuxuan. All rights reserved.
//

#import "AppDelegate.h"
#import "ArticleParser.h"
#import "BaseSQLiteManager.h"

@interface AppDelegate ()
@property (strong,nonatomic) ArticleParser* articleParser;
@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        
        
        // Word level is stored in NSUserDefaults since it would not cost a lot of storage
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"everLaunched"];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
        

        NSMutableDictionary* wordDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [[NSUserDefaults standardUserDefaults] setObject:wordDictionary forKey:@"word"];
        
        
        // Array of Words
        // Grouped by its level
        // levelDictionary[0] contain the words whose level are 0
        // And also stored in NSUserDefaults named level0
        // ......
        NSArray* levelDictionary = @[[NSMutableArray array],
                                     [NSMutableArray array],
                                     [NSMutableArray array],
                                     [NSMutableArray array],
                                     [NSMutableArray array],
                                     [NSMutableArray array],
                                     [NSMutableArray array]];
        
        
        
        for(NSString* dictionaryKey in wordDictionary){
            [levelDictionary[[wordDictionary[dictionaryKey] intValue]] addObject:dictionaryKey];
            
        }
        for(int i = 0;i < [levelDictionary count];i++){
            [[NSUserDefaults standardUserDefaults] setObject:levelDictionary[i] forKey:[NSString stringWithFormat:@"%@%d",@"level",i]];
        }
        
        for(int i = 0;i < [wordDictionary count];i++){
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%d",@"level",i]] );
        }
        
        
        //  Article are all stored in sqllite3
        BaseSQLiteContext* currentContext = [BaseSQLiteManager openSQLiteWithName:@"articleReader"];
        [currentContext createTableWithName:@"articleDocument"
                             keysDictionary:@{@"unit":@"integer",
                                              @"lesson" : @"integer",
                                              @"englishtitle" : @"text",
                                              @"chinesetitle" : @"text",
                                              @"problem" : @"text",
                                              @"reference" : @"text",
                                              @"newword":@"text"
                                              } callBack:^(BaseSQLError *error) {
                                                  NSLog(@"%@",[error errorInfo]);
                                              }];
        
        NSString *articlePath = [[NSBundle mainBundle] pathForResource:@"EnglishTextBook" ofType:@"txt"];

        NSMutableString* article = [[NSMutableString alloc] initWithContentsOfFile:articlePath encoding:NSUTF8StringEncoding error:NULL];
        self.articleParser = [[ArticleParser alloc]initWithArticle:article];
        [self.articleParser parse];
        for(id document in self.articleParser.documents){
            
            if ( [document isKindOfClass:[NSDictionary class]]){
                
                [currentContext insertData:@{@"unit":document[ARTICLEPARSER_UNIT],
                                             @"lesson" : document[ARTICLEPARSER_LESSON],
                                             @"englishtitle" : document[ARTICLEPARSER_ENGLISHTITLE],
                                             @"chinesetitle" : document[ARTICLEPARSER_CHINESETITLE],
                                             @"problem" : document[ARTICLEPARSER_PROBLEM],
                                             @"reference" : document[ARTICLEPARSER_REFERENCE],
                                             @"newword": document[ARTICLEPARSER_NEWWORD]
                                             
                                             }
                                 intoTable:@"articleDocument"
                                  callBack:^(BaseSQLError *error) {
                                      
                                  }];
            }
        }

    }
    return YES;
}






@end


