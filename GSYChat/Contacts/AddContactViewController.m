//
//  AddContactViewController.m
//  GSYChat
//
//  Created by up on 2019/10/24.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import "AddContactViewController.h"
#import "XMPP.h"
#import "XMPPManager.h"
#import "ContactTableViewCell.h"
#import "ContactModel.h"
#import "UserModel.h"

@interface AddContactViewController ()
@property (nonatomic,strong) UITableView *requestsTable;
@property (nonatomic,strong) NSMutableArray *requestsArray;
@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreeAddFriend:) name:@"agreeAdd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disagreeAddFriend:) name:@"disagreeAdd" object:nil];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupNaviBar];
    [self initRequstsArray];
    [self setupTableView];
}

-(void)setupNaviBar{
    self.navigationItem.title=@"新的朋友";
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem=rightBtn;
}

-(void)addFriend{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"请输入用户名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"添加好友的用户名";
    }];
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *username=[alertController.textFields firstObject].text;
        XMPPJID *jid=[XMPPJID jidWithUser:username domain:DOMAIN resource:RESOURCE];
        [[XMPPManager sharedManager].roster subscribePresenceToUser:jid];
    }];
    [alertController addAction:okAction];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)setupTableView{
    self.requestsTable=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.requestsTable];
    self.requestsTable.dataSource=self;
    self.requestsTable.delegate=self;
}

-(void)initRequstsArray{
    self.requestsArray=[UserModel defualtUser].addFriendsList;
}

-(void)agreeAddFriend:(NSNotification*)notification{
    NSDictionary *userinfo=notification.userInfo;
    XMPPJID *jid=[XMPPJID jidWithUser:userinfo[@"username"] domain:DOMAIN resource:RESOURCE];
    [[XMPPManager sharedManager].roster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提示" message:@"添加好友成功！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    XMPPJID *removeJid=[[XMPPJID alloc] init];
    for(XMPPJID *currentJid in [UserModel defualtUser].addFriendsList){
        if([jid.user isEqualToString:currentJid.user]){
            removeJid=currentJid;
            break;
        }
    }
    [[UserModel defualtUser].addFriendsList removeObject:removeJid];
    self.requestsArray=[UserModel defualtUser].addFriendsList;
    [self.requestsTable reloadData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactsListShouldUpdate" object:nil];
}

-(void)disagreeAddFriend:(NSNotification*)notification{
    
}

#pragma UITableViewDataSource&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.requestsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    if(cell==nil){
        cell=[[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuserIndentifier:@"contactCell"];
    }
    XMPPJID *jid=self.requestsArray[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:@"avatar_male"];
    cell.username.text=jid.user;
    cell.state.hidden=YES;
    cell.agreeBtn.hidden=NO;
    cell.disagreeBtn.hidden=NO;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end
