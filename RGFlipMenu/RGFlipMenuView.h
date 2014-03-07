//
//  RGFlipMenuView.h
//  RGFlipMenuView
//
//  Created by RolandG on 17/11/2013.
//  Copyright (c) 2013 FM. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRGMainMenuColor    [UIColor yellowColor]
#define kRGSubMenuColor     [UIColor greenColor]

CGRect mainMenuRect();

@class RGFlipMainMenuView;


@protocol RGFlipMenuDelegate <NSObject>
- (void)didTapMenu:(RGFlipMainMenuView *)mainMenuView;
@end


@interface RGFlipMenuView : UIView <RGFlipMenuDelegate>

- (void)popToRoot;
//- (void)changeText:(NSString *)theText;

- (id)initWithFrame:(CGRect)theFrame mainMenus:(NSArray *)theMainMenus;

@end
