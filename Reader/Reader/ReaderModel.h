//
//  ReaderModel.h
//  Reader
//
//  Created by 陈欢 on 2018/8/9.
//  Copyright © 2018年 Matcha00. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper.h>
@interface ReaderModel : NSObject
@property (nonatomic, copy) NSString *urlReader;
@property (nonatomic, copy) NSString *readerTitle;
@property (nonatomic, assign) NSUInteger plan;
@property (nonatomic, assign) NSUInteger offsetVolume;
@end
