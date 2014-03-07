//
//  RGFlipMenu.h
//  RGFlipMenu
//
//  Created by RolandG on 05/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RGFlipMenuView;
@class RGFlipMenu;

typedef void (^RGFlipMenuActionBlock)(id me);

@interface RGFlipMenu : NSObject

@property (nonatomic, copy) NSString *menuText;
@property (nonatomic, copy) RGFlipMenuActionBlock actionBlock;
@property (nonatomic, strong) NSArray *subMenus;
@property (nonatomic, assign) BOOL isMenuClosed;
@property (nonatomic, assign) BOOL isMenuSelected;
@property (nonatomic, strong) id menuView;

- (id)initWithText:(NSString *)theMenuText actionBlock:(RGFlipMenuActionBlock)theActionBlock subMenus:(NSArray *)theSubMenus;
- (id)initWithText:(NSString *)theMenuText actionBlock:(RGFlipMenuActionBlock)theActionBlock;

@end
