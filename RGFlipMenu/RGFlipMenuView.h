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


@interface RGFlipMenuView : UIView

@property (nonatomic, readonly) NSString *menuText;

- (void)popToRoot;
- (void)changeText:(NSString *)theText;

- (id)initWithFrame:(CGRect)theFrame mainMenus:(NSArray *)theMainMenus;

@end
