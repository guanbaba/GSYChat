//
//  ContactModel.h
//  GSYChat
//
//  Created by up on 2019/10/21.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPvCardTemp.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactModel : NSObject
@property (nonatomic,strong) XMPPJID *jid;
@property (nonatomic) BOOL isOnline;
@property (nonatomic,strong) XMPPvCardTemp *vCardTemp;

@end

NS_ASSUME_NONNULL_END
