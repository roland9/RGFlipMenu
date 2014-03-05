//
//  RGFlipMenu.h
//  RGFlipMenu
//
//  Created by RolandG on 05/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGFlipMenu : NSObject

@property (nonatomic, copy) NSString *menuText;
@property (nonatomic, strong) NSArray *subMenus;
@property (nonatomic, copy) void (^actionBlock) (void);

- (id)initWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus;
- (id)initWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock;

@end
