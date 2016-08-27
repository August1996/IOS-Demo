//
//  JBSong.h
//  JBMusic
//
//  Created by 余彬 on 16/8/4.
//  Copyright © 2016年 余彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBSong : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *filename;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *lrcname;
@property(nonatomic,copy) NSString *singerIcon;
@property(nonatomic,copy) NSString *singer;
@end
