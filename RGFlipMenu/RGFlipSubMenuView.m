//
//  RGFlipSubMenuView.m
//  RGFlipMenu
//
//  Created by RolandG on 05/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import "RGFlipSubMenuView.h"
#import "RGFlipMenu.h"
#import "RGFlipMenuView.h"

@interface RGFlipSubMenuView ()

@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, copy) void (^actionBlock) (void);

@end


@implementation RGFlipSubMenuView

- (id)initWithFrame:(CGRect)frame text:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock {
    NSAssert(theMenuText, @"menuText is mandatory");
    NSAssert(theActionBlock, @"actionBlock block is mandatory");

    self = [super initWithFrame:frame];
    if (self) {

        _actionBlock = theActionBlock;
        self.backgroundColor = kRGMainMenuColor;
        
        _menuLabel = [[UILabel alloc] initWithFrame:frame];
        [_menuLabel setText:theMenuText];
        [_menuLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        [_menuLabel setTextAlignment:NSTextAlignmentCenter];
        [_menuLabel setTextColor:[UIColor darkGrayColor]];
        [_menuLabel setNumberOfLines:3];
        [self addSubview:_menuLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMenu:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)didTapMenu:(id)sender {
    NSAssert([sender isKindOfClass:[UITapGestureRecognizer class]], @"inconsistent");
    
    self.actionBlock();
}


@end
