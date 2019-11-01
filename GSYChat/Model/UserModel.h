//
//  UserModel.h
//  GSYChat
//
//  Created by up on 2019/10/21.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPvCardTemp.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSMutableArray *contactsList;
@property (nonatomic,strong) XMPPvCardTemp *vCardTemp;
@property (nonatomic,strong) NSMutableArray *addFriendsList;

+(UserModel*)defualtUser;
@end

NS_ASSUME_NONNULL_END
