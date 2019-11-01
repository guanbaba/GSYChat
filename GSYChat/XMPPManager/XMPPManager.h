//
//  XMPPManager.h
//  GSYChat
//
//  Created by up on 2019/10/16.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPRoster.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardTemp.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

NS_ASSUME_NONNULL_BEGIN

#define HOST_NAME @"172.20.53.119"
#define HOST_PORT 5222
#define DOMAIN  @"172.20.53.119"
#define RESOURCE @"ios"

@interface XMPPManager : NSObject
@property (nonatomic,strong) XMPPStream *stream;
@property (nonatomic,strong) XMPPRosterCoreDataStorage *rosterStorage;
@property (nonatomic,strong) XMPPRoster *roster;
@property (nonatomic,strong) XMPPvCardCoreDataStorage *vCardStorage;
@property (nonatomic,strong) XMPPvCardTempModule *vCardTempModule;
@property (nonatomic,strong) XMPPvCardAvatarModule *vCardAvatarModule;
@property (nonatomic,strong) XMPPMessageArchivingCoreDataStorage *archivingStorage;
@property (nonatomic,strong) XMPPMessageArchiving *archiving;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL isLoginVC;
+(XMPPManager*)sharedManager;
-(void)setupStream;
-(void)login: (NSString*)username password:(NSString*)password;
-(void)register:(NSString*)username password:(NSString*)password avatar:(NSData*)avatar;
@end

NS_ASSUME_NONNULL_END
