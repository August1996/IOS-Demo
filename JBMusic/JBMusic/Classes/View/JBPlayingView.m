//
//  JBPlayingView.m
//  JBMusic
//
//  Created by 余彬 on 16/8/4.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import "JBPlayingView.h"
#import "JBSong.h"
#import "JBMusicTool.h"
#import "UIView+Extension.h"
#import "JBLrcView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface JBPlayingView()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singername;
@property (weak, nonatomic) IBOutlet UIButton *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *silder;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIView *durationBg;
@property (weak, nonatomic) IBOutlet UIView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *totalProgressBar;
@property (weak, nonatomic) IBOutlet JBLrcView *lrcView;
@property(nonatomic,assign) BOOL autoPause;
@property (nonatomic,strong) JBSong *currentSong;
@property(nonatomic,strong) AVAudioPlayer *player;
@property(nonatomic,strong) NSTimer *songTimer;
@property(nonatomic,strong) CADisplayLink *lrcTimer;
@end

@implementation JBPlayingView


#pragma mark 生成playingView
+ (JBPlayingView *)palyingView{
    JBPlayingView *playingView = [[[NSBundle mainBundle]loadNibNamed:@"JBPlayingView" owner:self options:nil]lastObject];
    
    playingView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, playingView.frame.size.width, playingView.frame.size.height);
    
    [playingView.totalProgressBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:playingView action:@selector(jumpTo:)]];
    [playingView.silder addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:playingView action:@selector(slideTo:)]];
    
    return playingView;
}

# pragma mark 退出
- (IBAction)exit:(UIButton *)sender {
    [self removeSongTimer];
    [self removeLrcTimer];
    [self hide];
}

# pragma mark - 切换词图
- (IBAction)toggleLrc:(UIButton *)sender {
    self.lrcView.hidden = !self.lrcView.isHidden;
    [self addLrcTimer];
}

# pragma mark - 播放控制
- (IBAction)playOrPause:(UIButton *)sender {
    if(!self.player)
        return;
    
    if(self.player.isPlaying){
        [JBMusicTool pauseMusic:[JBMusicTool currentSong]];
        self.autoPause = NO;
    }else{
        [JBMusicTool playMusic:[JBMusicTool currentSong]];
    }
    sender.selected = !sender.selected;
}
- (IBAction)previous:(id)sender {
    [self playNewSong:[JBMusicTool previousSong]];
}
- (IBAction)next:(id)sender {
    [self playNewSong:[JBMusicTool nextSong]];
}

#pragma mark - 控制视图
- (void)show:(JBSong *)song{
    
    if(self.currentSong != song){
        [self playNewSong:song];
    }
    
    [self addSongTimer];
    [self addLrcTimer];
    [self autoUpdate];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
    }];
}


#pragma mark - 播放新的音乐
- (void)playNewSong:(JBSong *)song{
    
    [JBMusicTool stopMusic:self.currentSong];
    self.player = [JBMusicTool playMusic:song];
    NSString *path = [[NSBundle mainBundle]pathForResource:song.lrcname ofType:nil];
    [self.lrcView setLrcString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
    self.player.delegate = self;
    [self updateInfo:0];
    [self addSongTimer];
    [self addLrcTimer];
    self.currentSong = song;
    
    self.songName.text = song.name;
    self.singername.text = song.singer;
    self.singerIcon.image = [UIImage imageNamed:song.icon];
    self.durationLabel.text = [self strWithInterval:self.player.duration];
    self.playBtn.selected = YES;
    [self updateLockScreenInfo];
}

- (NSString *)strWithInterval:(NSTimeInterval )interval{
    int min = interval / 60.0;
    int sec = (int)interval % 60;
    return [NSString stringWithFormat:@"%.2d:%.2d",min,sec];
}

#pragma mark - 定时器相关
- (void)addSongTimer{
        [self removeSongTimer];
    self.songTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.songTimer forMode:NSRunLoopCommonModes];
}

- (void)autoUpdate{
    if(self.player == nil) return;
    [self updateInfo:self.player.currentTime];
}

- (void)removeSongTimer{
    if(!self.songTimer)
        return;
    [self.songTimer invalidate];
    self.songTimer = nil;
}

- (void)updateInfo:(NSTimeInterval )duration{
    @synchronized (self) {
        if(self.player == nil) return;
        
        CGFloat maxWidth = self.durationBg.width - self.silder.width;
        
        CGFloat persent = duration / self.player.duration;
        if(duration >= self.player.duration){
            [self next:nil];
            return;
        }
        [self.silder setTitle:[self strWithInterval:duration] forState:UIControlStateNormal];
        self.silder.x = maxWidth * persent;
        self.progressBar.width = self.silder.center.x;
    }
}


- (void)addLrcTimer{
    [self removeLrcTimer];
    if(!self.lrcView.isHidden){
        
        self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateCntTime)];
        
        [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)removeLrcTimer{
    if(!self.lrcTimer) return;
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

- (void)updateCntTime{
    if(!self.player)
        return;
    self.lrcView.currentTime = self.player.currentTime;
}

#pragma mark -修改播放进度
- (void)jumpTo:(UITapGestureRecognizer *)tapGest{
    if(!self.player)return;
    
    CGFloat x = [tapGest locationInView:self.durationBg].x;
    
    CGFloat time = (x / self.durationBg.width) * self.player.duration;
    self.player.currentTime = time;
    [self autoUpdate];
}

- (void)slideTo:(UIPanGestureRecognizer *)panGest{
    if(!self.player) return;
    CGFloat x = [panGest translationInView:self.durationBg].x + self.silder.x;
    CGFloat time = (x / (self.durationBg.width - self.silder.width)) * self.player.duration;
    if(panGest.state == UIGestureRecognizerStateBegan){
        [self removeSongTimer];
    }else if(panGest.state == UIGestureRecognizerStateChanged){
        if(x < self.durationBg.width - self.silder.width && x > 0){
            [self updateInfo:time];
        }
    }else if(panGest.state == UIGestureRecognizerStateEnded){
        self.player.currentTime = time;
        [self addSongTimer];
    }
    [panGest setTranslation:CGPointZero inView:self.durationBg
     ];
}

#pragma mark - 播放被中断处理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self next:nil];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    if(self.playBtn.selected){
        self.autoPause = YES;
        [self playOrPause:nil];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    if(!self.playBtn.selected && self.autoPause){
        [self playOrPause:nil];
    }
}

#pragma mark - 更新锁屏信息
- (void)updateLockScreenInfo{
    if(!self.currentSong || !self.player)
        return;
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    //设置显示信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MPMediaItemPropertyTitle] = self.currentSong.name;
    info[MPMediaItemPropertyArtist] = self.currentSong.singer;
    info[MPMediaItemPropertyAlbumTitle] = self.currentSong.name;
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:self.currentSong.icon]];
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);
    info[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    
    center.nowPlayingInfo = info;
    
    
    //成为第一响应者才能接受远程事件
    [self becomeFirstResponder];
    
    
    //开始接受远程事件
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
}

#pragma mark - 配置可接受远程事件
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if(event.type == UIEventTypeRemoteControl){
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
                [self playOrPause:nil];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self next:nil];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self previous:nil];
                break;
            default:
                break;
        }
    }
}
@end
