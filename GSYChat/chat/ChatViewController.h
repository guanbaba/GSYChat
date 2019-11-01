//
//  ChatViewController.h
//  GSYChat
//
//  Created by up on 2019/10/31.
//  Copyright © 2019 guanshiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController
@property (nonatomic,strong) ContactModel* contact;
@end

NS_ASSUME_NONNULL_END
