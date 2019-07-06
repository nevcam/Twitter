//
//  User.h
//  twitter
//
//  Created by nev on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImageURLString;
@property (strong, nonatomic) NSString *profileBannerURLString;
@property (strong, nonatomic) NSString *followersCount;
@property (strong, nonatomic) NSString *followingCount;
@property (strong, nonatomic) NSString *bioLabel;
//@property (strong, nonatomic) NSString *description;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
