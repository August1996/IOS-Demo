//
//  JBLrcCell.h
//  JBMusic
//
//  Created by 余彬 on 16/8/5.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBLrcLine;
@interface JBLrcCell : UITableViewCell
@property(nonatomic,strong) JBLrcLine *line;
+ (JBLrcCell *)lrcCellWithTableView:(UITableView *)tableView;
@end
