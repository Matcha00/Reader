//
//  ReaderWebViewController.h
//  Reader
//
//  Created by 陈欢 on 2018/8/9.
//  Copyright © 2018年 Matcha00. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReaderModel;
@interface ReaderWebViewController : UIViewController

@property (nonatomic, copy) NSString *urlWeb;

@property (nonatomic, strong) ReaderModel *showModel;
@end
