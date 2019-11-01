//
//  ContactTableViewCell.h
//  GSYChat
//
//  Created by up on 2019/10/17.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *username;
@property (nonatomic,strong) UILabel *state;
@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UIButton *disagreeBtn;
-(instancetype)initWithStyle:(UITableViewCellStyle*)style reuserIndentifier:(NSString*)reuseIndentifier;
@end

NS_ASSUME_NONNULL_END
