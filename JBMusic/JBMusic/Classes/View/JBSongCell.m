//
//  JBSongCell.m
//  JBMusic
//
//  Created by 余彬 on 16/8/4.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import "JBSongCell.h"
#import "JBSong.h"
#import "UIImage+MJ.h"

@implementation JBSongCell
+ (JBSongCell *)songCellWithTableView:(UITableView *)tableView{
    JBSongCell *songCell = [tableView dequeueReusableCellWithIdentifier:@"songCell"];
    if(!songCell){
        songCell = [[JBSongCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"songCell"];
    }
    return songCell;
}

- (void)setSong:(JBSong *)song{
    _song = song;
    self.imageView.image = [UIImage circleImageWithName:song.singerIcon borderWidth:2 borderColor:[UIColor lightGrayColor]];
    self.textLabel.text = song.name;
    self.detailTextLabel.text = song.singer;
}
@end
