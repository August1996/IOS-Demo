//
//  JBLrcView.m
//  JBMusic
//
//  Created by 余彬 on 16/8/4.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import "JBLrcView.h"
#import "JBLrcLine.h"
#import "UIView+Extension.h"
#import "JBLrcCell.h"

@interface JBLrcView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *lrcLines;
@property(nonatomic,assign) int cntIndex;
@end

@implementation JBLrcView


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        UITableView *tableView = [[UITableView alloc]init];
        [self addSubview:tableView];
        self.tableView = tableView;
    }
    return self;
}


#pragma mark - 初始化tableView
- (void)willMoveToWindow:(UIWindow *)newWindow{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(self.height * 0.5, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSMutableArray *)lrcLines{
    if(!_lrcLines){
        _lrcLines = [[NSMutableArray alloc]init];
    }
    return _lrcLines;
}


#pragma mark - 设置歌词进行分割
- (void)setLrcString:(NSString *)lrcString{
    NSArray *lines = [lrcString componentsSeparatedByString:@"\n"];
    [self.lrcLines removeAllObjects];
    for(int i = 0;i < lines.count;i++){
        if([lines[i] hasPrefix:@"["]){
            JBLrcLine *line = [[JBLrcLine alloc]init];
            if([lines[i] hasPrefix:@"[ti:"] || [lines[i] hasPrefix:@"[ar:"] || [lines[i] hasPrefix:@"[al:"]){
                NSString *lineContent = [[lines[i] componentsSeparatedByString:@":"]lastObject];
                line.content = [lineContent substringToIndex:lineContent.length - 1];
            }else{
                NSArray *lineSplit = [lines[i] componentsSeparatedByString:@"]"];
                NSString *lineTime = lineSplit[0];
                NSString *lineContent = lineSplit[1];
                line.time = [lineTime substringFromIndex:1];
                line.content = lineContent;
            }
            [self.lrcLines addObject:line];
        }
    }
    self.cntIndex = 0;
    [self.tableView reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JBLrcLine *line = self.lrcLines[indexPath.row];
    JBLrcCell *cell = [JBLrcCell lrcCellWithTableView:tableView];
    cell.line = line;
    if(indexPath.row == _cntIndex){
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcLines.count;
}

#pragma mark - 设置当前播放时间去更新歌词
- (void)setCurrentTime:(NSTimeInterval)currentTime{
    int preIndex = _cntIndex;
    if(currentTime < _currentTime){
        _cntIndex = 0;
    }
    _currentTime = currentTime;
    
    for(int i = _cntIndex;i < self.lrcLines.count;i++){
        JBLrcLine *cntLine = self.lrcLines[i];
        if(i == self.lrcLines.count - 1){
            _cntIndex = i;
            break;
        }else{
            JBLrcLine *nextLine = self.lrcLines[i + 1];
            if(currentTime >= [self strLrcTime:cntLine.time] && currentTime <  [self strLrcTime:nextLine.time]){
                _cntIndex = i;
                break;
            }
            
        }
    }
    if(preIndex != _cntIndex){
        NSArray *refreshData = @[[NSIndexPath indexPathForRow:preIndex inSection:0],[NSIndexPath indexPathForRow:_cntIndex inSection:0]];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_cntIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.tableView reloadRowsAtIndexPaths:refreshData withRowAnimation:NO];
    }
    
}

#pragma mark - 格式化时间
- (NSTimeInterval)strLrcTime:(NSString *)strTime{
    if(!strTime){
        return 0;
    }
    NSArray *timeUnits = [strTime componentsSeparatedByString:@":"];
    CGFloat min = [[timeUnits firstObject] intValue] * 60;
    CGFloat sAndMs = [[timeUnits lastObject] doubleValue];
    NSTimeInterval time = min + sAndMs;
    return time;
}

@end
