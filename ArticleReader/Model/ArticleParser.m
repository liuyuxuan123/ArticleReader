//
//  ArticleParser.m
//  ArticleReader
//
//  Created by 刘宇轩 on 3/13/18.
//  Copyright © 2018 liuyuxuan. All rights reserved.
//





#import "ArticleParser.h"
@interface ArticleParser()

@property (strong,nonatomic) NSArray* articleLines;

@end


@implementation ArticleParser

-(NSArray*)documents{
    if(!_documents){
        _documents = [[NSArray alloc] init];
    }
    return _documents;
}

-(instancetype)initWithArticle:(NSString *)article{
    self = [super init];
    if(self){
        self.rawString = article;
        self.articleLines = [self.rawString componentsSeparatedByString:@"\n"];
    }
    return self;
}

-(NSUInteger)totalLines{
    return [[self.rawString componentsSeparatedByString:@"\n"] count];
}

-(NSArray*)divideArticleBy:(NSString*)sep inRange:(NSRange)aRange compareMode:(BOOL)isCompare{
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    
    __block int currentIndexOfElement = 0;
    [self.articleLines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= aRange.location && idx < aRange.location + aRange.length){
            NSString* articleLine = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (!isCompare){
                if ( [articleLine hasPrefix:sep] ){
                    int indexOfElement = [[[articleLine componentsSeparatedByString:@" "]lastObject] intValue];
                    if (indexOfElement > currentIndexOfElement){
                        [locationArray addObject:@(idx)];
                        currentIndexOfElement = indexOfElement;
                    }
                }
            }else{
                if ([articleLine hasPrefix:sep]){
                    [locationArray addObject:@(idx)];
                }
            }
        }
    }];
    
    //NSLog(@"A %@",locationArray);
    
    NSMutableArray* validRangeArray = [[NSMutableArray alloc] init];
    
    for(int i = 0;i < locationArray.count;i ++){
        NSRange validRange;
        if(i == locationArray.count - 1){
            validRange = NSMakeRange([locationArray[i] intValue], aRange.location + aRange.length - [locationArray[i] intValue]);
        }else{
            validRange = NSMakeRange([locationArray[i] intValue], [locationArray[i + 1] intValue] - [locationArray[i] intValue]);
        }
        [validRangeArray addObject:NSStringFromRange(validRange)];
    }
    return validRangeArray;
    
}
-(NSArray*)divideArticleByUnitInRange:(NSRange)aRange{
    return [self divideArticleBy:@"Unit" inRange:aRange compareMode:NO];
}

-(NSArray*)divideArticleByLessonInRange:(NSRange)aRange{
    return [self divideArticleBy:@"Lesson" inRange:aRange compareMode:NO];
}
-(NSRange)divideArticleByProblem:(NSRange)aRange{
    return NSRangeFromString([[self divideArticleBy:@"First listen" inRange:aRange compareMode:YES] firstObject]);
}

-(NSRange)divideArticleByWordAndExpressions:(NSRange)aRange{
    return NSRangeFromString([[self divideArticleBy:@"New words" inRange:aRange compareMode:YES] firstObject]);
}

-(NSRange)divideArticleByReference:(NSRange)aRange{
    return NSRangeFromString([[self divideArticleBy:@"参考译文" inRange:aRange compareMode:YES] firstObject]);
}

-(void)parse{
    
    NSMutableArray* temporaryDocument = [[NSMutableArray alloc] init];
    NSArray* unitRanges = [self divideArticleByUnitInRange:NSMakeRange(0, [self totalLines])];
    //NSLog(@"Unit Range%@",unitRanges);
    
    int currentUnit = 0;
    int currentLesson = 0;
    
    for(id unitRange in unitRanges){
        currentUnit += 1;
        if( [unitRange isKindOfClass:[NSString class]] ){
            NSRange unitrange = NSRangeFromString(unitRange);
            NSArray* lessonRanges = [self divideArticleByLessonInRange:unitrange];
            //NSLog(@"lesson in Range %@ is %@",unitRange,lessonRanges);
            for(id lessonRange in lessonRanges){
                currentLesson += 1;
                NSRange lessonrange = NSRangeFromString(lessonRange);
                
                
                //NSString* title = [self.articleLines[lessonrange.location + 1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString* englishTitle =[self.articleLines[lessonrange.location + 1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];;
                NSString* chineseTitle = [self.articleLines[lessonrange.location + 2] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];;
                
             
                
                NSRange referencerange = [self divideArticleByReference:lessonrange];
                NSString* reference = [[self.articleLines objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(referencerange.location + 1, referencerange.length - 1)]] componentsJoinedByString:@""];
                
                NSRange newwordrange = [self divideArticleByWordAndExpressions:NSMakeRange(lessonrange.location, referencerange.location - lessonrange.location)];
                NSString* newword = [[self.articleLines objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(newwordrange.location + 1, newwordrange.length - 1)]] componentsJoinedByString:@""];
                
                NSRange problemrange = [self divideArticleByProblem:NSMakeRange(lessonrange.location, newwordrange.location - lessonrange.location)];
                NSString* problem = [[self.articleLines objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(problemrange.location + 2, problemrange.length - 2)]] componentsJoinedByString:@""];
                

//                NSLog(@"EnglishTitle:%@",englishTitle);
//                NSLog(@"ChineseTitle:%@",chineseTitle);
//                NSLog(@"Promblem:%@",problem);
//                NSLog(@"New word:%@",newword);
//                NSLog(@"Reference:%@",reference);
                
                NSDictionary* entry = @{
                                        ARTICLEPARSER_UNIT : @(currentUnit),
                                        ARTICLEPARSER_LESSON : @(currentLesson),
                                        ARTICLEPARSER_ENGLISHTITLE : englishTitle,
                                        ARTICLEPARSER_CHINESETITLE : chineseTitle,
                                        ARTICLEPARSER_PROBLEM : problem,
                                        ARTICLEPARSER_NEWWORD : newword,
                                        ARTICLEPARSER_REFERENCE : reference
                                        };
                [temporaryDocument addObject:entry];
            }
        }
    }
    
    self.documents = temporaryDocument;
   
    
}





@end
