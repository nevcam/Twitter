//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetDetailViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
//1.table view as a subview
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //3.view controller becomes its datasource and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    // Get timeline
    [self getTimeLine];
}

- (void)getTimeLine {
    //4.make API request
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        //6.store data
        self.tweets = tweets;
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        //7.reload table view
        [self.tableView reloadData];
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getTimeLine];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//8. tableView asks its dataSource for numberOfRows and cellForRowAt
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 9. returns the number of items returned from the API
    return self.tweets.count;
}

// 10. returns an instance of the custom cell with that reuse identifier with it's elements populated with data at the index asked for
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //2.custom cell with reuse identifier
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    //Set tweet labels
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.tweet = tweet;
    cell.authorLabel.text = tweet.user.name;
    NSString *at = @"@";
    NSString *fullHandle = [at stringByAppendingString:tweet.user.screenName];

    cell.screenNameLabel.text = fullHandle;
    cell.tweetLabel.text = tweet.text;
    
    NSString *fullPhotoURLString = tweet.user.profileImageURLString;
    NSURL *profilePhotoURL = [NSURL URLWithString:fullPhotoURLString];
    cell.profilePhoto.image = nil;
    [cell.profilePhoto setImageWithURL:profilePhotoURL];
    
    cell.dateLabel.text = tweet.createdAtString;
    cell.numRetweetsLabel.text = [@(tweet.retweetCount) stringValue];
    cell.numLikesLabel.text = [@(tweet.favoriteCount) stringValue];
    cell.numRepliesLabel.text = [@(tweet.replyCount) stringValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier  isEqual: @"composeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier  isEqual: @"detailSegue"]) {
            UITableViewCell *tappedCell = sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
            Tweet *tweet = self.tweets[indexPath.row];
            TweetDetailViewController *tweetDetailViewController = [segue destinationViewController];
            tweetDetailViewController.tweet = tweet;
    } else {
        
    }
    
}

- (void)didTweet:(nonnull Tweet *)tweet {
    NSLog(@"%@", tweet.text);
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    // clear out the access tokens
    [[APIManager shared] logout];
}


@end
