//
//  ECFullScreenPlayerController.h
//  Beacon
//
//  Created by SeaHub on 2017/5/20.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ECPlayerViewModel;
@protocol ECFullScreenPlayerControllerDelegate <NSObject>

- (void)fullScreenController:(UIViewController *)controller
  viewWillDisappearWithModel:(ECPlayerViewModel *)viewModel;

@end

@interface ECFullScreenPlayerController : UIViewController

@property (nonatomic, weak, nullable) id<ECFullScreenPlayerControllerDelegate> delegate;
@property (nonatomic, strong, nullable) ECPlayerViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
