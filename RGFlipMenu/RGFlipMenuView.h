//
//  RGFlipMenuView.h
//  RGFlipMenuView
//
//  Created by RolandG on 17/11/2013.
//  Copyright (c) 2013 FM. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef <#existing#> <#new#>;

@interface RGFlipMenu : NSObject
- (id)initWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus;
- (id)initWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock;
@end


@interface RGFlipMenuView : UIView

@property (nonatomic, readonly) NSString *menuText;

- (void)popToRoot;
- (void)changeText:(NSString *)theText;

- (id)initWithFrame:(CGRect)theFrame mainMenus:(NSArray *)theMainMenus;

@end
