//
//  JBMusicTool.m
//  音乐Demo
//
//  Created by 余彬 on 16/8/3.
//  Copyright © 2016年 余彬. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import "JBMusicTool.h"
#import "JBSong.h"
@implementation JBMusicTool

static NSMutableDictionary *_musics;
static NSArray *_songList;
static int _currentSongIndex;



+ (void)initialize{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [session setActive:YES error:nil];
}


+ (void)setSongIndex:(int)index{
    if(index < 0){
        _currentSongIndex = 0;
    }else if(index >= _songList.count){
        _currentSongIndex = _songList.count - 1;
    }else {
        _currentSongIndex = index;
    }
    [self playMusic:[self currentSong]];
}

+ (NSMutableDictionary *)musics{
    if(!_musics){
        _musics = [[NSMutableDictionary alloc]init];
    }
    return _musics;
}

+ (void)setSongList:(NSArray *)songList{
    _songList = songList;
}

+ (AVAudioPlayer *)playMusic:(JBSong *)song{
    if(!song) return nil;
    
    AVAudioPlayer *player = [self musics][song.filename];
    if(!player){
        NSURL *url = [[NSBundle mainBundle]URLForResource:song.filename withExtension:nil];
        if(!url) return nil;
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    }
    [player prepareToPlay];
    [self musics][song.filename] = player;
    [player play];
    _currentSongIndex = [_songList indexOfObject:song];
    return player;
}

+ (BOOL)pauseMusic:(JBSong *)song{
    if(!song) return NO;
    
    AVAudioPlayer *player = [self musics][song.filename];
    if(!player) return NO;
    [player pause];
    return YES;
}

+ (BOOL)stopMusic:(JBSong *)song{
    if(!song) return NO;
    AVAudioPlayer *player = [self musics][song.filename];
    if(!player) return NO;
    
    [player stop];
    player = nil;
    [[self musics] removeObjectForKey:song.filename];
    return YES;
}

+ (JBSong *)nextSong{
    if(_currentSongIndex == _songList.count - 1){
        _currentSongIndex = 0;
    }else {
        _currentSongIndex++;
    }
    return [self currentSong];
}

+ (JBSong *)previousSong{
    if(_currentSongIndex == 0){
        _currentSongIndex = _songList.count - 1;
    }else {
        _currentSongIndex--;
    }
    return [self currentSong];
}

+ (JBSong *)currentSong{
    if(_currentSongIndex < 0 || _currentSongIndex >= _songList.count){
        return nil;
    }
    return _songList[_currentSongIndex];
}







@end
