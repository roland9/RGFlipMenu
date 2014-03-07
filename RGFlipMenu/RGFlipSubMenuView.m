//
//  RGFlipSubMenuView.m
//  RGFlipMenu
//
//  Created by RolandG on 05/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import "RGFlipSubMenuView.h"
#import "RGFlipMenuView.h"

@interface RGFlipSubMenuView ()

@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, copy) RGFlipMenuActionBlock actionBlock;

@property (nonatomic, weak) id<RGFlipMenuDelegate> delegate;

@end


@implementation RGFlipSubMenuView

- (id)initWithFrame:(CGRect)frame text:(NSString *)theMenuText actionBlock:(RGFlipMenuActionBlock)theActionBlock delegate:(id<RGFlipMenuDelegate>)theDelegate {
    NSAssert(theMenuText, @"menuText is mandatory");
    NSAssert(theActionBlock, @"actionBlock block is mandatory");

    self = [super initWithFrame:frame];
    if (self) {

        _actionBlock = theActionBlock;
        self.backgroundColor = kRGMainMenuColor;
        _delegate = theDelegate;
        
        [self.layer setCornerRadius:5.f];
        
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
    
    [self.delegate didTapSubMenu:self];
}


@end
