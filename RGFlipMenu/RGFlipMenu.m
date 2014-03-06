//
//  RGFlipMenu.m
//  RGFlipMenu
//
//  Created by RolandG on 05/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import "RGFlipMenu.h"

@interface RGFlipMenu()
@end


@implementation RGFlipMenu

- (id)initWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus {
    self = [super init];
    if (self) {
        _menuText = theMenuText;
        _actionBlock = theActionBlock;
        _subMenus = theSubMenus;
        _isMenuClosed = YES;
    }
    return self;
}

- (id)initWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock {
    return [self initWithText:theMenuText actionBlock:theActionBlock subMenus:NULL];
}

@end

