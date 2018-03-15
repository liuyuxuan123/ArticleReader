//
//  ArticleDetailViewController.h
//  ArticleReader
//
//  Created by 刘宇轩 on 3/13/18.
//  Copyright © 2018 liuyuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleReader-Swift.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface ArticleComponentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *titleLabel;

@end

@interface NewwordComponentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end


@interface ArticleDetailTableViewController : UIViewController<PinterestSegmentDelegate,UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate>

@property (strong,nonatomic) NSString* rawString;

-(void)setRawString:(NSString*)problem newWord:(NSString*)newword reference:(NSString*) reference;

@end
