//
//  JBViewController.m
//  JBMusic
//
//  Created by 余彬 on 16/8/4.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import "JBViewController.h"
#import "JBMusicTool.h"
#import "JBSong.h"
#import "MJExtension.h"
#import "JBSongCell.h"
#import "JBPlayingView.h"

@interface JBViewController()
@property(nonatomic,strong) NSArray *songList;
@property(nonatomic,strong) JBPlayingView *playingView;
@property(nonatomic,strong) NSNumber *currentIndex;
@end
@implementation JBViewController

- (void)viewDidLoad{
    self.title = @"JB音乐";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[UIApplication sharedApplication].keyWindow addSubview:self.playingView];
}


#pragma mark - 懒加载
- (NSArray *)songList{
    if(!_songList){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Musics.plist" ofType:nil];
        _songList = [JBSong objectArrayWithFile:path];
        [JBMusicTool setSongList:_songList];
    }
    return _songList;
}

- (JBPlayingView *)playingView{
    if(!_playingView){
        _playingView = [JBPlayingView palyingView];
    }
    return _playingView;
}

#pragma mark - tableView方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JBSongCell *cell = [JBSongCell songCellWithTableView:tableView];
    cell.song = self.songList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.playingView show:self.songList[indexPath.row]];
}




@end

