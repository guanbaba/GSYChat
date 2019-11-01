//
//  ContactTableViewCell.m
//  GSYChat
//
//  Created by up on 2019/10/17.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "Masonry.h"

@interface ContactTableViewCell()
@end

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle*)style reuserIndentifier:(NSString*)reuseIndentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIndentifier];
    if(self){
        self.avatar=[[UIImageView alloc] init];
        self.avatar.clipsToBounds=YES;
        self.avatar.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:self.avatar];
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.offset(18);
            make.centerY.equalTo(self.contentView);
        }];
        self.username=[[UILabel alloc] init];
        [self addSubview:self.username];
        [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(180, 20));
            make.left.equalTo(self.avatar.mas_right).offset(18);
            make.centerY.equalTo(self.contentView);
        }];
        self.state=[[UILabel alloc] init];
        [self addSubview:self.state];
        [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 20));
            make.right.offset(-18);
            make.centerY.equalTo(self.contentView);
        }];
        self.disagreeBtn=[[UIButton alloc] init];
        [self.disagreeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.disagreeBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.disagreeBtn addTarget:self action:@selector(disagreeAdd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.disagreeBtn];
        self.disagreeBtn.hidden=YES;
        [self.disagreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 20));
            make.right.offset(-18);
            make.centerY.equalTo(self.contentView);
        }];
        self.agreeBtn=[[UIButton alloc] init];
        [self.agreeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [self.agreeBtn addTarget:self action:@selector(agreeAdd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.agreeBtn];
        self.agreeBtn.hidden=YES;
        [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 20));
            make.right.equalTo(self.disagreeBtn.mas_left).offset(-18);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

-(void)agreeAdd{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"agreeAdd" object:nil userInfo:@{@"username":self.username.text}];
}

-(void)disagreeAdd{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disagreeAdd" object:nil userInfo:@{@"username":self.username.text}];
}

@end
