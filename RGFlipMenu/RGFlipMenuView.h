//
//  RGFlipMenuView.h
//  RGFlipMenuView
//
//  Created by RolandG on 17/11/2013.
//  Copyright (c) 2013 FM. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRGMainMenuColor        [UIColor yellowColor]
#define kRGSubMenuNormalColor   [UIColor greenColor]
#define kRGSubMenuSelectedColor [UIColor cyanColor]

CGRect mainMenuRect();

@class RGFlipMainMenuView;
@class RGFlipSubMenuView;

@protocol RGFlipMenuDelegate <NSObject>
- (void)didTapMenu:(RGFlipMainMenuView *)mainMenuView;
- (void)didTapSubMenu:(RGFlipSubMenuView *)subMenuView;
@end


@interface RGFlipMenuView : UIView <RGFlipMenuDelegate>

- (void)popToRoot;
//- (void)changeText:(NSString *)theText;

- (id)initWithFrame:(CGRect)theFrame mainMenus:(NSArray *)theMainMenus;

@end
