//
//  UserViewController.h
//  twitter
//
//  Created by nev on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

@end

NS_ASSUME_NONNULL_END
