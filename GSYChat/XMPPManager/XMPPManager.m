//
//  XMPPManager.m
//  GSYChat
//
//  Created by up on 2019/10/16.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import "XMPPManager.h"
#import "UserModel.h"
#import "ContactModel.h"


@interface XMPPManager()
@property (nonatomic,strong) UserModel *user;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSData *avatarData;
@property (nonatomic,strong) NSString *type;
@end


@implementation XMPPManager

 static XMPPManager *manager;

+(XMPPManager*)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[XMPPManager alloc] init];
    });
    return  manager;
}

-(void)setupStream{
    self.isLoginVC=YES;
    self.stream=[[XMPPStream alloc] init];
    self.stream.hostName=HOST_NAME;
    self.stream.hostPort=HOST_PORT;
    [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.rosterStorage=[XMPPRosterCoreDataStorage sharedInstance];
    self.roster=[[XMPPRoster alloc] initWithRosterStorage:self.rosterStorage dispatchQueue:dispatch_get_global_queue(0, 0)];
    [self.roster activate:self.stream];
    [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.roster.autoFetchRoster=NO;
    
    self.vCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    self.vCardTempModule=[[XMPPvCardTempModule alloc] initWithvCardStorage:self.vCardStorage];
    [self.vCardTempModule activate:self.stream];
    [self.vCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.vCardAvatarModule=[[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.vCardTempModule];
    [self.vCardAvatarModule activate:self.stream];
    [self.vCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.archivingStorage=[XMPPMessageArchivingCoreDataStorage sharedInstance];
    self.archiving=[[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.archivingStorage dispatchQueue:dispatch_get_main_queue()];
    [self.archiving activate:self.stream];
    [self.archiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.context=self.archivingStorage.mainThreadManagedObjectContext;
}

//登录

-(void)login: (NSString*)username password:(NSString*)password{
    self.type=@"login";
    self.user=[UserModel defualtUser];
    self.user.username=username;
    self.user.password=password;
    XMPPJID *jid=[XMPPJID jidWithUser:username domain:HOST_NAME resource:RESOURCE];
    self.stream.myJID=jid;
    if(self.stream.isConnected){
        [self.stream disconnect];
    }
    NSError *error=[[NSError alloc] init];
    [self.stream connectWithTimeout:30.0f error:&error];
    if(error){
        NSLog(@"%@",__func__);
    }
}
-(void)xmppStreamDidConnect:(XMPPStream*)sender{
    NSError *error=[[NSError alloc] init];
    if([self.type isEqualToString:@"login"])
        [self.stream authenticateWithPassword:self.user.password error:&error];
    else if([self.type isEqualToString:@"register"])
        [self.stream registerWithPassword:self.password error:&error];
    if(error){
        NSLog(@"%@",__func__);
    }
}
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    if(self.isLoginVC){
        NSLog(@"login successfully!");
        XMPPPresence *presence=[XMPPPresence presence];
        [self.stream sendElement:presence];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessfully" object:nil];
    }
    else{
        XMPPvCardTemp *myvCard=[XMPPvCardTemp vCardTemp];
        myvCard.nickname=self.username;
        myvCard.photo=self.avatarData;
        [[XMPPManager sharedManager].vCardTempModule updateMyvCardTemp:myvCard];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"registerSuccessfully" object:nil];
    }
}

-(void)xmppStream:(XMPPStream*)sender didNotAuthenticate:(nonnull DDXMLElement *)error{
    NSLog(@"login unsuccessfully!");
}

//注册
-(void)register:(NSString*)username password:(NSString*)password avatar:(NSData*)avatar{
    self.type=@"register";
    self.username=username;
    self.password=password;
    self.avatarData=avatar;
    XMPPJID *jid=[XMPPJID jidWithUser:username domain:HOST_NAME resource:RESOURCE];
    self.stream.myJID=jid;
    if(self.stream.isConnected){
        [self.stream disconnect];
    }
    NSError *error=[[NSError alloc] init];
    [self.stream connectWithTimeout:30.0f error:&error];
    if(error){
        NSLog(@"%@",__func__);
    }
}

-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    [[XMPPManager sharedManager] login:self.username password:self.password];
}

//获取好友

-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
    if([[[item attributeForName:@"subscription"] stringValue] isEqualToString:@"both"]||[[[item attributeForName:@"subscription"] stringValue] isEqualToString:@"to"]||[[[item attributeForName:@"subscription"] stringValue] isEqualToString:@"from"]){
        NSString *jidStr=[[item attributeForName:@"jid"] stringValue];
        XMPPJID *jid=[XMPPJID jidWithString:jidStr resource:RESOURCE];
        BOOL exist=NO;
        for(ContactModel *contactItem in self.user.contactsList){
            if([contactItem.jid.user isEqualToString:jid.user]){
                exist=YES;
                break;
            }
        }
        if(exist==NO){
            [[XMPPManager sharedManager].vCardTempModule fetchvCardTempForJID:jid ignoreStorage:YES];  
        }
    }
}
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"rosterFetchSuccessfully" object:nil];
    NSLog(@"%d",[UserModel defualtUser].contactsList.count);
}

-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
         didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                    forJID:(XMPPJID *)jid{
    if(!vCardTemp.nickname)
        return;
    if([jid.user isEqualToString:[UserModel defualtUser].username]){
        [UserModel defualtUser].vCardTemp=vCardTemp;
    }
    else{
        BOOL exist=NO;
        for(ContactModel *contactItem in self.user.contactsList){
            if([contactItem.jid.user isEqualToString:jid.user]){
                exist=YES;
                break;
            }
        }
        if(exist==NO){
            ContactModel *contact=[[ContactModel alloc] init];
            contact.jid=jid;
            contact.vCardTemp=vCardTemp;
            contact.isOnline=YES;
            [self.user.contactsList addObject:contact];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getOneMoreContact" object:nil];
        }
    }
}

-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    NSLog(@"成功收到好友请求");
    UserModel *user=[UserModel defualtUser];
    NSString *username=presence.from.user;
    NSString *domain=presence.from.domain;
    BOOL exist=NO;
    for(XMPPJID *jid in user.addFriendsList){
        if([jid.user isEqualToString:username]&&[jid.user isEqualToString:domain]){
            exist=YES;
            break;
        }
    }
    if(exist==NO){
        [user.addFriendsList addObject:presence.from];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getNewFriendRequest" object:nil];
    }
}

//消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSXMLElement *request=[message elementForName:@"request"];
    if(request){
        if([request.xmlns isEqualToString:@"urn:xmpp:receipts"]){
            NSLog(@"message received!");
            XMPPMessage *msg=[XMPPMessage messageWithType:message.type to:message.from elementID:message.elementID];
            NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [msg addChild:recieved];
            [self.stream sendElement:msg];
        }
    }
    else{
        NSXMLElement *received=[message elementForName:@"received"];
        if (received)
        {
            if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])
            {
                NSLog(@"message send success!");
            }
        }
    }
}

@end
