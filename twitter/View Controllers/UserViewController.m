//
//  UserViewController.m
//  twitter
//
//  Created by nev on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "UserViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "AppDelegate.h"
#import "TweetDetailViewController.h"

@interface UserViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[APIManager shared] getOtherUserTimelineWithCompletion:self.user completion:^(NSArray *tweets, NSError *error) {
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
    
    
    self.authorLabel.text = self.user.name;
    NSString *at = @"@";
    NSString *fullHandle = [at stringByAppendingString:self.user.screenName];
    
    self.screenNameLabel.text = fullHandle;
//    self.bioLabel.text = self.user.description;
    NSString *followerCount = self.user.followersCount;
    self.followerCountLabel.text = followerCount;
    NSString *followingCount = self.user.followingCount;
    self.followingCountLabel.text = followingCount;
    
    self.bioLabel.text = self.user.bioLabel;
    
    NSString *fullPhotoURLString = self.user.profileImageURLString;
    NSURL *profilePhotoURL = [NSURL URLWithString:fullPhotoURLString];
    self.profilePhotoView.image = nil;
    [self.profilePhotoView setImageWithURL:profilePhotoURL];
    
    NSString *fullPhotoBannerURLString = self.user.profileBannerURLString;
    NSURL *profileBannerPhotoURL = [NSURL URLWithString:fullPhotoBannerURLString];
    self.bannerImageView.image = nil;
    [self.bannerImageView setImageWithURL:profileBannerPhotoURL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end
