//
//  RGFlipMenu.h
//  RGFlipMenu
//
//  Created by RolandG on 05/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RGFlipMenuView;

@interface RGFlipMenu : NSObject

@property (nonatomic, copy) NSString *menuText;
@property (nonatomic, copy) void (^actionBlock) (void);
@property (nonatomic, strong) NSArray *subMenus;
@property (nonatomic, assign) BOOL isMenuClosed;
@property (nonatomic, strong) id menuView;


- (id)initWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus;
- (id)initWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock;

@end
