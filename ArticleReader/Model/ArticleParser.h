//
//  ArticleParser.h
//  ArticleReader
//
//  Created by 刘宇轩 on 3/13/18.
//  Copyright © 2018 liuyuxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARTICLEPARSER_UNIT @"unit"
#define ARTICLEPARSER_LESSON @"lesson"
#define ARTICLEPARSER_ENGLISHTITLE @"englishtitle"
#define ARTICLEPARSER_CHINESETITLE @"chinesetitle"
#define ARTICLEPARSER_PROBLEM @"problem"
#define ARTICLEPARSER_NEWWORD @"newword"
#define ARTICLEPARSER_REFERENCE @"reference"


@interface ArticleParser : NSObject

@property (strong,nonatomic) NSString* rawString;
@property (strong,nonatomic) NSArray* documents; 

-(instancetype)initWithArticle:(NSString*)article;

//-(NSArray*)divideArticleBy:(NSString*)sep inRange:(NSRange)aRange;
//-(NSArray*)divideArticleByUnitInRange:(NSRange)aRange;
//-(NSArray*)divideArticleByLessonInRange:(NSRange)aRange;
-(void)parse;
-(NSUInteger) totalLines;

@end
