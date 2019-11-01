//
//  ContactsListViewController.m
//  GSYChat
//
//  Created by up on 2019/10/17.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import "ContactsListViewController.h"
#import "ContactTableViewCell.h"
#import "XMPPManager.h"
#import "UserModel.h"
#import "ContactModel.h"
#import "AddContactViewController.h"
#import "ChatViewController.h"

@interface ContactsListViewController ()
@property (nonatomic,strong) UITableView *contactsTable;
@property (nonatomic,strong) NSMutableArray *contactsArray;
@property (nonatomic) NSInteger newRequestsNum;
@end

@implementation ContactsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNaviBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initContactsList) name:@"rosterFetchSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContactsTable) name:@"getOneMoreContact" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRequestNum) name:@"getNewFriendRequest" object:nil];
    [[XMPPManager sharedManager].roster fetchRoster];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadContactsTable];
}
-(void)reloadContactsTable{
    if(!self.contactsTable){
        [self setupTableView];
    }
    self.contactsArray=[UserModel defualtUser].contactsList;
    self.newRequestsNum=[UserModel defualtUser].addFriendsList.count;
    [self.contactsTable reloadData];
}

-(void)setupNaviBar{
    self.navigationItem.title=@"联系人列表";
    UIBarButtonItem *refreshbBtn=[[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(reloadContactsTable)];
    self.navigationItem.rightBarButtonItem=refreshbBtn;
}

-(void)setupTableView{
    self.contactsTable=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.contactsTable];
    self.contactsTable.dataSource=self;
    self.contactsTable.delegate=self;
}

-(void)initContactsList{
    if(!self.contactsTable){
        self.contactsArray=[UserModel defualtUser].contactsList;
        [self setupTableView];
    }
}

-(void)updateRequestNum{
    self.newRequestsNum=[UserModel defualtUser].addFriendsList.count;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.contactsTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

//-(void)updateContactsTable{
//    [[XMPPManager sharedManager].roster fetchRoster];
//    self.contactsArray=[UserModel defualtUser].contactsList;
//    [self.contactsTable reloadData];
//}

#pragma UITableViewDataSource&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    else{
        return self.contactsArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    if(cell==nil){
        cell=[[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuserIndentifier:@"contactCell"];
    }
    if(indexPath.section==0){
        cell.avatar.image=[UIImage imageNamed:@"avatar_male"];
        cell.username.text=@"新的朋友";
        if(self.newRequestsNum>=1){
            cell.state.textColor=[UIColor redColor];
            cell.state.text=[NSString stringWithFormat:@"%d",self.newRequestsNum];
            cell.state.hidden=NO;
        }
        else{
            cell.state.hidden=YES;
        }
    }
    else if(indexPath.section==1){
        ContactModel *contact=self.contactsArray[indexPath.row];
        cell.avatar.image=[UIImage imageWithData:contact.vCardTemp.photo];
        cell.username.text=contact.vCardTemp.nickname;
        cell.state.text=contact.isOnline?@"online":@"offline";
        cell.state.hidden=NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        AddContactViewController *addContactVC=[[AddContactViewController alloc] init];
        [self.navigationController pushViewController:addContactVC animated:YES];
    }
    else if(indexPath.section==1){
        ChatViewController *chatVC=[[ChatViewController alloc] init];
        chatVC.contact=self.contactsArray[indexPath.row];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
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
