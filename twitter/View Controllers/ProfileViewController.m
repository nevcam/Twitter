//
//  ProfileViewController.m
//  twitter
//
//  Created by nev on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "TweetDetailViewController.h"
#import "User.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSDictionary *userDeets;
@property (nonatomic, strong) NSString *userScreenName;
@property (nonatomic, strong) User *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
//    - (void)getUserDetails:(void(^)(NSArray *userDetails, NSError *error))completion
    [[APIManager shared] getUserDetails:^(NSDictionary *userDetails, NSError *error) {
        self.userDeets = userDetails;
        if (self.userDeets) {
            NSLog(@"😎😎😎 Successfully got user deets");
            NSLog(@"Here are the user deets: %@", self.userDeets);
            self.userScreenName = self.userDeets[@"screen_name"];
            NSLog(@"Here is the screenname: %@", self.userScreenName);
        } else {
            NSLog(@"😫😫😫 Error getting user deets: %@", error.localizedDescription);
        }
    }];
    
    
    [[APIManager shared] getUserTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        //6.store data
        self.tweets = tweets;
//        self.authorLabel = 
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for(Tweet* tweet in tweets) {
                if(tweet.user.screenName == self.userScreenName){
                    self.user = tweet.user;
                    NSLog(@"here is your user %@", self.user.name);
                    [self loadScreen];
                    break;
                }
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        //7.reload table view
        [self.tableView reloadData];
    }];
    
    [self loadScreen];
}

- (void)loadScreen {
    self.authorLabel.text = self.user.name;
    self.handleLabel.text = self.user.screenName;
    self.bioLabel.text = self.user.bioLabel;
    
    NSString *followerCount = self.user.followersCount;
    self.followerCountLabel.text = followerCount;
    NSString *followingCount = self.user.followingCount;
    self.followingCountLabel.text = followingCount;
    
    NSString *fullPhotoURLString = self.user.profileImageURLString;
    NSURL *profilePhotoURL = [NSURL URLWithString:fullPhotoURLString];
    self.profilePhotoView.image = nil;
    [self.profilePhotoView setImageWithURL:profilePhotoURL];
    
    NSString *fullPhotoBannerURLString = self.user.profileBannerURLString;
    NSURL *profileBannerPhotoURL = [NSURL URLWithString:fullPhotoBannerURLString];
    self.bannerView.image = nil;
    [self.bannerView setImageWithURL:profileBannerPhotoURL];
    self.tweetCountLabel.text = self.user.tweetCount;
}

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
