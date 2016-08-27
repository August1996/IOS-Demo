//
//  JBLrcCell.m
//  JBMusic
//
//  Created by 余彬 on 16/8/5.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import "JBLrcCell.h"
#import "JBLrcLine.h"
#import "UIView+Extension.h"

@implementation JBLrcCell

- (void)setLine:(JBLrcLine *)line{
    _line = line;
    self.textLabel.text = line.content;
}

+ (JBLrcCell *)lrcCellWithTableView:(UITableView *)tableView{
    JBLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[JBLrcCell alloc]init];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

@end
