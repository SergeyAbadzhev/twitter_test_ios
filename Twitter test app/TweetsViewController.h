//
//  TweetsViewController.h
//  Twitter test app
//
//  Created by Sergey on 04.08.15.
//  Copyright (c) 2015 Sergey Abadzhev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import "UIScrollView+SVPullToRefresh.h"

@interface TweetsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *composeBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutBtn;


@end
