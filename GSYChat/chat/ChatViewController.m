//
//  ChatViewController.m
//  GSYChat
//
//  Created by up on 2019/10/31.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import "ChatViewController.h"
#import "Masonry.h"
#import "XMPP.h"
#import "XMPPManager.h"

@interface ChatViewController ()
@property (nonatomic,strong) UILabel *chatRecordLabel;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self getChatRecord];
}

-(void)getChatRecord{
    NSManagedObjectContext *context=[XMPPManager sharedManager].context;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@ AND bareJidStr == %@", [XMPPManager sharedManager].stream.myJID.bare,self.contact.jid.bare];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects) {
        NSMutableString *recordStr=@"";
        for(XMPPMessageArchiving_Message_CoreDataObject *coreDataObject in fetchedObjects){
            [recordStr appendString:coreDataObject.body];
            [recordStr appendString:@"\n"];
        }
        self.chatRecordLabel.text=recordStr;
    }
}

-(void)setupView{
    self.chatRecordLabel=[[UILabel alloc] init];
    [self.view addSubview:self.chatRecordLabel];
    [self.chatRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 500));
        make.top.offset(150);
        make.centerX.equalTo(self.view);
    }];
    UIButton *sendBtn=[[UIButton alloc] init];
    [self.view addSubview:sendBtn];
    sendBtn.backgroundColor=[UIColor greenColor];
    [sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.bottom.offset(-150);
        make.centerX.equalTo(self.view);
    }];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sendBtnClicked{
    XMPPMessage *message=[XMPPMessage messageWithType:@"chat" to:self.contact.jid];
    [message addBody:@"This is a test message!"];
    NSXMLElement *receipt=[NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];
    [[XMPPManager sharedManager].stream sendElement:message];
}

@end
