//
//  JBSongCell.h
//  JBMusic
//
//  Created by 余彬 on 16/8/4.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBSong;
@interface JBSongCell : UITableViewCell
@property(nonatomic,strong) JBSong *song;
+ (JBSongCell *)songCellWithTableView:(UITableView *)tableView;
@end
