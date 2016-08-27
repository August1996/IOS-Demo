//
//  JBLrcView.h
//  JBMusic
//
//  Created by 余彬 on 16/8/4.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import "DRNRealTimeBlurView.h"

@interface JBLrcView : DRNRealTimeBlurView
- (void)setLrcString:(NSString *)lrcString;
@property(nonatomic,assign) NSTimeInterval currentTime;
@end
