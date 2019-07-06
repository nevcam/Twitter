//
//  TweetCell.m
//  twitter
//
//  Created by nev on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "TimelineViewController.h"

@implementation TweetCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePhoto addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePhoto setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}
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
    self.numRetweetsLabel.text = [@(self.tweet.retweetCount) stringValue];
    self.numLikesLabel.text = [@(self.tweet.favoriteCount) stringValue];
    self.numRepliesLabel.text = [@(self.tweet.replyCount) stringValue];
    
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    // TODO: Call method on delegate
    [self.delegate tweetCell:self didTap:self.tweet.user];
    
}

@end
