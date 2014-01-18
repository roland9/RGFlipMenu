//
//  RGFlipMenuView.h
//  RGFlipMenuView
//
//  Created by RolandG on 17/11/2013.
//  Copyright (c) 2013 FM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGFlipMenuView : UIView

@property (nonatomic, readonly) NSString *menuText;

- (void)popToRoot;
- (void)changeText:(NSString *)theText;

+ (id)subMenuWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock;
- (id)initWithText:(NSString *)menuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus;

@end
