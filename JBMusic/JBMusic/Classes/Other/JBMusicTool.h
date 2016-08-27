//
//  JBMusicTool.h
//  音乐Demo
//
//  Created by 余彬 on 16/8/3.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVAudioPlayer,JBSong;
@interface JBMusicTool : NSObject
+ (AVAudioPlayer *)playMusic:(JBSong *)song;
+ (BOOL)pauseMusic:(JBSong *)song;
+ (BOOL)stopMusic:(JBSong *)song;
+ (void)setSongList:(NSArray *)songList;
+ (JBSong *)nextSong;
+ (JBSong *)previousSong;
+ (JBSong *)currentSong;
@end
