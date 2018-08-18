//
//  SwipeUpInteractiveTransition.h
//  Reader
//
//  Created by 陈欢 on 2018/8/18.
//  Copyright © 2018年 Matcha00. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeUpInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interacting;

- (void)wireToViewController:(UIViewController *)viewController;
@end
