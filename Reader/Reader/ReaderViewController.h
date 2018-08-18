//
//  ReaderViewController.h
//  Reader
//
//  Created by 陈欢 on 2018/8/9.
//  Copyright © 2018年 Matcha00. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReaderViewController;
@protocol ReaderViewControllerDelegate <NSObject>

- (void) readerViewControllerDidClickedDismissButton:(ReaderViewController *)viewController;

@end



@interface ReaderViewController : UIViewController
@property (nonatomic, copy) NSString *urlR;
@property (nonatomic, weak) id<ReaderViewControllerDelegate> delegate;
@end
