//
//  UserModel.m
//  GSYChat
//
//  Created by up on 2019/10/21.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
static UserModel *user;
+(UserModel*)defualtUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user=[[UserModel alloc] init];
        user.contactsList=[[NSMutableArray alloc] init];
        user.addFriendsList=[[NSMutableArray alloc] init];
    });
    return user;
}
@end
