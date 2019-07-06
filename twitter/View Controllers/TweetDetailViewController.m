//
//  TweetDetailViewController.m
//  twitter
//
//  Created by nev on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.authorLabel.text = self.tweet.user.name;
    NSString *at = @"@";
    NSString *fullHandle = [at stringByAppendingString:self.tweet.user.screenName];
    
    self.screenNameLabel.text = fullHandle;
    self.tweetLabel.text = self.tweet.text;
    
    NSString *fullPhotoURLString = self.tweet.user.profileImageURLString;
    NSURL *profilePhotoURL = [NSURL URLWithString:fullPhotoURLString];
    self.profilePhotoView.image = nil;
    [self.profilePhotoView setImageWithURL:profilePhotoURL];
    
    self.dateLabel.text = self.tweet.longDate;
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    self.favCountLabel.text = [@(self.tweet.favoriteCount) stringValue];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self refreshData];
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
        UIImage *defaultRetweet = [UIImage imageNamed:@"retweet-icon"];
        [self.retweetButton setImage:defaultRetweet forState:UIControlStateNormal];
        //        self.favButton.;
        
    } else {
        // TODO: Update the local tweet model
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        // TODO: Update cell UI
        [self refreshData];
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
        UIImage *greenRetweet = [UIImage imageNamed:@"retweet-icon-green"];
        [self.retweetButton setImage:greenRetweet forState:UIControlStateNormal];
    }
}

- (IBAction)didTapFav:(id)sender {
    if(self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self refreshData];
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
        UIImage *defaultFav = [UIImage imageNamed:@"favor-icon"];
        [self.favButton setImage:defaultFav forState:UIControlStateNormal];
        //        self.favButton.;
        
    } else {
        // TODO: Update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        // TODO: Update cell UI
        [self refreshData];
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        UIImage *redFav = [UIImage imageNamed:@"favor-icon-red"];
        [self.favButton setImage:redFav forState:UIControlStateNormal];
    }
}

- (void)refreshData {
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    self.favCountLabel.text = [@(self.tweet.favoriteCount) stringValue];
    
}


@end
