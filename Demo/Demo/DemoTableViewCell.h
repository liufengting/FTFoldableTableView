//
//  DemoTableViewCell.h
//  Demo
//
//  Created by liufengting on 2018/5/29.
//  Copyright © 2018年 liufengting. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const DemoTableViewCellIdentifier = @"DemoTableViewCellIdentifier";

@interface DemoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
