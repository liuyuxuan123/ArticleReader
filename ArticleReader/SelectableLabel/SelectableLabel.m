//
//  SelectableLabel.m
//  ArticleReader
//
//  Created by 刘宇轩 on 3/14/18.
//  Copyright © 2018 liuyuxuan. All rights reserved.
//

#import "SelectableLabel.h"

@implementation SelectableLabel
-(instancetype)init{
    self = [super init];
    if (self){
        [self setUp];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setUp {

    self.userInteractionEnabled = YES;
    self.highlighted = YES;
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)]];
}

- (void)longPress:(UILongPressGestureRecognizer*)aRec {
    
    // 设置label为第一响应者
    [self becomeFirstResponder];
    // 自定义 UIMenuController
    UIMenuController * menu = [UIMenuController sharedMenuController];
    UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyText:)];
    
    menu.menuItems = @[item1];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action == @selector(copyText:)) return YES;
    return NO;
}
- (void)copyText:(UIMenuController *)menu {
    // 没有文字时结束方法
    if (!self.text) return;
    // 复制文字到剪切板
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.text;
}


@end
