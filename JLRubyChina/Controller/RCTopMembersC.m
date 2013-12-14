//
//  RCTopUsersC.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/14/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopMembersC.h"
#import "UIImage+nimbusImageNamed.h"
#import "RCUserLauncherButtonView.h"
#import "RCUserEntity.h"
#import "RCTopMembersModel.h"
#import "RCUserHomepageC.h"

#define PAGE_MAX_COUNT (IS_IPHONE5 ? (5 * 5) : (4*4))

@interface RCTopMembersC ()<NILauncherViewModelDelegate>
@property (nonatomic, assign) NITableViewActionBlock tapAction;
@property (nonatomic, strong) RCTopMembersModel* requestModel;
@property (nonatomic, readwrite, retain) NILauncherViewModel* launcherModel;
@property (nonatomic, strong) NSArray* topMembersArray;
@end

@implementation RCTopMembersC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"TOP活跃会员";
        self.navigationItem.leftBarButtonItem = [RCGlobalConfig createMenuBarButtonItemWithTarget:self
                                                                                           action:@selector(showLeft:)];
        self.navigationItem.rightBarButtonItem = [RCGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                                                               action:@selector(refreshTopMembers)];
        
        _requestModel = [[RCTopMembersModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(211, 211, 211);//[UIColor whiteColor];
    [self refreshTopMembers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.revealSideViewController updateViewWhichHandleGestures];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.requestModel.isLoading) {
        [self.requestModel cancelRequstOperation];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)refreshTopMembers
{
    [self.requestModel loadTopMembersWithBlock:^(NSArray *topMembersArray, NSError *error) {
        [self reloadLaunchViewWithTopMembersArray:topMembersArray];
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadLaunchViewWithTopMembersArray:(NSArray*)topMembersArray
{
    if (topMembersArray.count) {
        NSMutableArray* contents = [NSMutableArray array];
        RCUserEntity* user = nil;
        NILauncherViewObject* viewObject = nil;
        NSMutableArray* pageArray = nil;
        
        for (NSUInteger i = 0; i < topMembersArray.count; i++) {
            user = topMembersArray[i];
            viewObject = [RCUserLauncherViewObject objectWithTitle:user.loginId
                                                      defaultImage:[UIImage nimbusImageNamed:@"head_b.png"]
                                                          imageUrl:user.avatarUrl];
            if (0 == i % PAGE_MAX_COUNT) {
                pageArray = [NSMutableArray arrayWithCapacity:PAGE_MAX_COUNT];
                [contents addObject:pageArray];
            }
            [pageArray addObject:viewObject];
        }
        self.topMembersArray = topMembersArray;
        self.launcherModel = [[NILauncherViewModel alloc] initWithArrayOfPages:contents delegate:self];
        self.launcherView.dataSource = self.launcherModel;
        [self.launcherView reloadData];
    }
    else {
        // HUD show
    }
}

#pragma mark - NILauncherViewModelDelegate

- (void)launcherViewModel:(NILauncherViewModel *)launcherViewModel
      configureButtonView:(UIView<NILauncherButtonView> *)buttonView
          forLauncherView:(NILauncherView *)launcherView
                pageIndex:(NSInteger)pageIndex
              buttonIndex:(NSInteger)buttonIndex
                   object:(id<NILauncherViewObject>)object {
    
    // The NILauncherViewObject object always creates a NILauncherButtonView so we can safely cast
    // here and update the label's style to add the nice blurred shadow we saw in the
    // BasicInstantiation example.
    NILauncherButtonView* launcherButtonView = (NILauncherButtonView *)buttonView;
    launcherButtonView.label.textColor = RGBCOLOR(0, 105, 215);
//    
//    launcherButtonView.label.layer.shadowColor = [UIColor blackColor].CGColor;
//    launcherButtonView.label.layer.shadowOffset = CGSizeMake(0, 1);
//    launcherButtonView.label.layer.shadowOpacity = 1;
//    launcherButtonView.label.layer.shadowRadius = 1;
}

#pragma mark - NILauncherDelegate

- (void)launcherView:(NILauncherView *)launcher didSelectItemOnPage:(NSInteger)page atIndex:(NSInteger)index {
    // Now that we're using a model we can easily refer back to which object was selected when we
    // receive a selection notification.
    //id<NILauncherViewObject> object = [self.launcherModel objectAtIndex:index pageIndex:page];
    RCUserLauncherViewObject* object = (RCUserLauncherViewObject*)[self.launcherModel objectAtIndex:index pageIndex:page];
    if (object.title.length) {
        RCUserHomepageC* c = [[RCUserHomepageC alloc] initWithUserLoginId:object.title];
        [self.navigationController pushViewController:c animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Side View Controller

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLeft:(id)sender
{
    // used to push a new controller, but we preloaded it !
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft
                                                         withOffset:SIDE_DIRECTION_LEFT_OFFSET
                                                           animated:YES];
}

@end