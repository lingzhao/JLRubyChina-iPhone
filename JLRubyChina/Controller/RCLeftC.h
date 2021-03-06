//
//  LeftViewController.h
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LeftMenuType_Home=0,
    LeftMenuType_ForumNodes,
    LeftMenuType_CoolSites,
    LeftMenuType_TopMembers,
    LeftMenuType_MyHomePage,
    LeftMenuType_Wiki,
    LeftMenuType_More,
    LeftMenuType_End
}LeftMenuType;

@protocol LeftMenuDelegate;
@interface RCLeftC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id<LeftMenuDelegate> delegate;

- (id)initWithStyle:(UITableViewStyle)style;
- (void)setSelectedMenuType:(LeftMenuType)type;

@end

@protocol LeftMenuDelegate <NSObject>

- (void)didSelectLeftMenuType:(LeftMenuType)type;

@end
