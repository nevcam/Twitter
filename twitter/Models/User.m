//
//  User.m
//  twitter
//
//  Created by nev on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageURLString = dictionary[@"profile_image_url_https"];
        
        // Initialize any other properties
        self.profileBannerURLString = dictionary[@"profile_banner_url"];
        self.followersCount = [NSString stringWithFormat:@"%@", dictionary[@"followers_count"] ];
        self.followingCount = [NSString stringWithFormat:@"%@", dictionary[@"friends_count"] ];
        self.bioLabel = dictionary[@"description"];
        
    }
    return self;
}

@end
