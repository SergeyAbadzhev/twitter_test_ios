//
//  TweetsViewController.m
//  Twitter test app
//
//  Created by Sergey on 04.08.15.
//  Copyright (c) 2015 Sergey Abadzhev. All rights reserved.
//

#import "TweetsViewController.h"

@interface TweetsViewController ()

@end

@implementation TweetsViewController

NSMutableArray* twitterResponse;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[TWTRTweetTableViewCell class] forCellReuseIdentifier:@"tweetCell"];
    twitterResponse=[[NSMutableArray alloc]init];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self getUserTimeline];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self getUserTimeline];
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
     
-(void) getUserTimeline{
    
    
        NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:@"https://api.twitter.com/1.1/statuses/home_timeline.json"
                                                                                parameters:@{@"userid": [Twitter sharedInstance].session.userID,
                                                                                             @"screen_name" : [Twitter sharedInstance].session.userName} error:nil];
        
        NSURLResponse *response;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(!data)
        {
            NSLog(@"error....: %@",error.localizedDescription);
        }
        else
        {
            
            [twitterResponse removeAllObjects];
            
            NSArray *arrayRep = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            twitterResponse = [NSMutableArray arrayWithArray:[TWTRTweet tweetsWithJSONArray:arrayRep]];
            
           [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return twitterResponse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"tweetCell";
    
    TWTRTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    TWTRTweet *tweet = twitterResponse[indexPath.row];
    [cell configureWithTweet:tweet];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)logoutBtnPressed:(id)sender {
    [[Twitter sharedInstance] logOut];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)composeBtnPressed:(id)sender {
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    

    
    // Called from a UIViewController
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
}

@end
