//
//  RegisterViewController.m
//  GSYChat
//
//  Created by up on 2019/10/22.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import "RegisterViewController.h"
#import "Masonry.h"
#import "XMPPManager.h"
#import <UIKit/UIImagePickerController.h>

@interface RegisterViewController ()
@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) NSData *avatarData;
@property (nonatomic,strong) UILabel *usernameLabel;
@property (nonatomic,strong) UITextField *usernameField;
@property (nonatomic,strong) UILabel *passwordLabel1;
@property (nonatomic,strong) UITextField *passwordField1;
@property (nonatomic,strong) UILabel *passwordLabel2;
@property (nonatomic,strong) UITextField *passwordField2;
@property (nonatomic,strong) UIButton *registerBtn;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToLoginVC) name:@"registerSuccessfully" object:nil];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupNaviBar];
    [self setupView];
}

-(void)setupNaviBar{
    self.navigationItem.title=@"用户注册";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToLoginVC)];
}

-(void)backToLoginVC{
    [XMPPManager sharedManager].isLoginVC=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupView{
    self.avatarImageView=[[UIImageView alloc] init];
    self.avatarImageView.image=[UIImage imageNamed:@"avatar_male"];
    self.avatarData=UIImagePNGRepresentation(self.avatarImageView.image);
    [self.avatarImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setAvatar)];
    [self.avatarImageView addGestureRecognizer:tapGestureRecognizer];
    [self.view addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.offset(150);
        make.centerX.equalTo(self.view);
    }];
    self.usernameLabel=[[UILabel alloc] init];
    [self.view addSubview:self.usernameLabel];
    self.usernameLabel.text=@"用户名:";
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(50);
        make.left.offset(50);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        
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
    self.passwordLabel1=[[UILabel alloc] init];
    [self.view addSubview:self.passwordLabel1];
    self.passwordLabel1.text=@"密码:";
    [self.passwordLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(50);
        make.left.offset(50);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        
    }];
    self.passwordField1=[[UITextField alloc] init];
    self.passwordField1.borderStyle=UITextBorderStyleLine;
    [self.view addSubview:self.passwordField1];
    self.passwordField1.placeholder=@"请输入密码";
    [self.passwordField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.left.equalTo(self.passwordLabel1.mas_right).offset(10);
        make.centerY.equalTo(self.passwordLabel1);
    }];
    self.passwordLabel2=[[UILabel alloc] init];
    [self.view addSubview:self.passwordLabel2];
    self.passwordLabel2.text=@"重复密码:";
    [self.passwordLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField1.mas_bottom).offset(50);
        make.left.offset(50);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        
    }];
    self.passwordField2=[[UITextField alloc] init];
    self.passwordField2.borderStyle=UITextBorderStyleLine;
    [self.view addSubview:self.passwordField2];
    self.passwordField2.placeholder=@"请再次输入密码";
    [self.passwordField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.left.equalTo(self.passwordLabel2.mas_right).offset(10);
        make.centerY.equalTo(self.passwordLabel2);
    }];
    self.registerBtn=[[UIButton alloc] init];
    self.registerBtn.backgroundColor=[UIColor redColor];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.top.equalTo(self.passwordField2.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
    }];
}

- (void)textFieldValueChanged:(UITextField *)textField{
    if(self.usernameField.text.length>0&&self.passwordField1.text.length>0&&self.passwordField2.text.length>0){
        self.registerBtn.backgroundColor=[UIColor colorWithRed:237 green:23 blue:31 alpha:1.0];
        self.registerBtn.enabled=YES;
    }
    else{
        self.registerBtn.backgroundColor=[UIColor colorWithRed:239 green:188 blue:188 alpha:1.0];
        self.registerBtn.enabled=NO;
    }
}

-(void)setAvatar{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:action1];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"使用相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"本设备未发现摄像头!");
            return;
        }
        UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
        imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate=self;
        imagePickerController.allowsEditing=YES;
        [self showDetailViewController:imagePickerController sender:nil];
    }];
    [alertController addAction:action2];
    UIAlertAction *action3=[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
        imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate=self;
        imagePickerController.allowsEditing=YES;
        [self showDetailViewController:imagePickerController sender:nil];
    }];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type=[info objectForKey:UIImagePickerControllerMediaType];
    if([type isEqualToString:@"public.image"]){
        UIImage *image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage *resizedImage100 = [self reSizeImage:image toSize:CGSizeMake(100, 100)];
        UIImage *resizedImage40 = [self reSizeImage:image toSize:CGSizeMake(40, 40)];
        NSData *data;
        if(UIImagePNGRepresentation(resizedImage40)==nil){
            data=UIImageJPEGRepresentation(resizedImage40, 1.0);
        }
        else{
            data=UIImagePNGRepresentation(resizedImage40);
        }
        self.avatarData=data;
        self.avatarImageView.image=resizedImage100;
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIImage*)reSizeImage:(UIImage*)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

-(void)registerHandler{
    if([self.passwordField1.text isEqualToString:self.passwordField2.text]){
        [[XMPPManager sharedManager] register:self.usernameField.text password:self.passwordField1.text avatar:self.avatarData];
    }
    else{
        UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"输入错误" message:@"两次输入的密码不一致！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertControllerStyleAlert handler:^(UIAlertAction * _Nonnull action) {
            self.passwordField1.text=@"";
            self.passwordField2.text=@"";
            [self.passwordField1 becomeFirstResponder];
        }];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
@end
