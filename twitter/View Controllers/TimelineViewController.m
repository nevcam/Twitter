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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (Tweet *tweet in tweets) {
//                NSString *text = tweet.text;
//                NSLog(@"%@", text);
//            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            //            for (Tweet *tweet in tweets) {
            //                NSString *text = tweet.text;
            //                NSLog(@"%@", text);
            //            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        // Reload the tableView now that there is new data
        [self.tableView reloadData];
        // Tell the refreshControl to stop spinning
        
    }];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 20;
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    //Set tweet labels
    Tweet *tweet = self.tweets[indexPath.row];
    cell.authorLabel.text = tweet.user.name;
    NSString *at = @"@";
    NSString *fullHandle = [at stringByAppendingString:tweet.user.screenName];

    cell.screenNameLabel.text = fullHandle;
    cell.tweetLabel.text = tweet.text;
    
    // URL for profile photo view
//    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
//    NSString *profileURLString = tweet.user.prof;
//    NSString *fullPhotoURLString = [baseURLString stringByAppendingString:posterURLString];
    // checks if it's a valid URL
    NSString *fullPhotoURLString = tweet.user.profileImageURLString;
    NSURL *profilePhotoURL = [NSURL URLWithString:fullPhotoURLString];
    cell.profilePhoto.image = nil;
    [cell.profilePhoto setImageWithURL:profilePhotoURL];
    
    cell.dateLabel.text = tweet.createdAtString;
    cell.numRetweetsLabel.text = [@(tweet.retweetCount) stringValue];
    cell.numLikesLabel.text = [@(tweet.favoriteCount) stringValue];
    cell.numRepliesLabel.text = [@(tweet.replyCount) stringValue];
//    if(tweet.retweeted) {
//
//    }
//
//    if(tweet.favorited) {
//
//    }
    
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


@end
