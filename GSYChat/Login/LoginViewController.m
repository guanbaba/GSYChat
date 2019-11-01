//
//  LoginViewController.m
//  GSYChat
//
//  Created by up on 2019/10/16.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "XMPPManager.h"
#import "XMPP.h"
#import "ContactsListViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()
@property (nonatomic,strong) UILabel *usernameLabel;
@property (nonatomic,strong) UITextField *usernameField;
@property (nonatomic,strong) UILabel *passwordLabel;
@property (nonatomic,strong) UITextField *passwordField;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *registerBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateToContactsList) name:@"loginSuccessfully" object:nil];
}

-(void)setupView{
    self.usernameLabel=[[UILabel alloc] init];
    [self.view addSubview:self.usernameLabel];
    self.usernameLabel.text=@"用户名:";
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.left.offset(50);
        make.size.mas_equalTo(CGSizeMake(70, 20));
        
    }];
    self.usernameField=[[UITextField alloc] init];
    self.usernameField.borderStyle=UITextBorderStyleLine;
    [self.view addSubview:self.usernameField];
    self.usernameField.placeholder=@"请输入用户名";
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.left.equalTo(self.usernameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.usernameLabel);
    }];
    self.passwordLabel=[[UILabel alloc] init];
    [self.view addSubview:self.passwordLabel];
    self.passwordLabel.text=@"密码:";
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(50);
        make.left.offset(50);
        make.size.mas_equalTo(CGSizeMake(70, 20));
        
    }];
    self.passwordField=[[UITextField alloc] init];
    self.passwordField.borderStyle=UITextBorderStyleLine;
    [self.view addSubview:self.passwordField];
    self.passwordField.placeholder=@"请输入密码";
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.left.equalTo(self.passwordLabel.mas_right).offset(10);
        make.centerY.equalTo(self.passwordLabel);
    }];
    self.loginBtn=[[UIButton alloc] init];
    self.loginBtn.backgroundColor=[UIColor redColor];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.top.equalTo(self.passwordField.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
    }];
    self.registerBtn=[[UIButton alloc] init];
    self.registerBtn.backgroundColor=[UIColor clearColor];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(navigateToRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.top.equalTo(self.loginBtn.mas_bottom).offset(60);
        make.centerX.equalTo(self.view);
    }];
}
-(void)loginHandler{
    XMPPManager *manager=[XMPPManager sharedManager];
    [manager login:self.usernameField.text password:self.passwordField.text];
}

-(void)navigateToRegisterVC{
    [XMPPManager sharedManager].isLoginVC=NO;
    RegisterViewController *registerVC=[[RegisterViewController alloc] init];
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:registerVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)navigateToContactsList{
    ContactsListViewController *contactsListVC=[[ContactsListViewController alloc] init];
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:contactsListVC];
    self.view.window.rootViewController=navigationController;
}

@end
