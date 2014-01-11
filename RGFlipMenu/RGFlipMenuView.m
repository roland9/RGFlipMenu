//
//  RGFlipMenuView.m
//  RGFlipMenuView
//
//  Created by RolandG on 17/11/2013.
//  Copyright (c) 2013 FM. All rights reserved.
//

#import "RGFlipMenuView.h"

@interface RGFlipMenuView ()
@property (copy) void (^actionBlock) (void);
@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UIView *backsideMenuView;
@property (nonatomic, strong) NSArray *subMenus;
@property (nonatomic, assign) BOOL isFrontsideShown;
@end


@implementation RGFlipMenuView {
    BOOL isSubMenu;
    CGPoint originalCenter;
}

#define kRGHeight 180
#define kRGWidth  180


////////////////////////////////////////////////////////////////////
# pragma mark - Public methods

-(void)popToRoot {
    NSAssert(!isSubMenu, @"switch to root only allowed for main/root menu, not the sub menus");
    if (!self.isFrontsideShown) {
        [self didTapMenu];
    }
}

- (NSString *)menuText {
    return self.menuLabel.text;
}


////////////////////////////////////////////////////////////////////
# pragma mark - public initializers and factories

+ (id)subMenuWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock {
    NSAssert(theMenuText, @"menuText is mandatory");
    NSAssert(theActionBlock, @"actionBlock block is mandatory");
    
    RGFlipMenuView *menu = [[RGFlipMenuView alloc] initWithFrame:CGRectMake(0, 0, kRGWidth, kRGHeight) text:theMenuText actionBlock:theActionBlock subMenus:NULL isSubMenu:YES];
    return menu;
}


- (id)initWithText:(NSString *)menuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus {
    CGRect frame = CGRectMake(0, 0, kRGWidth, kRGHeight);
    self = [self initWithFrame:frame text:menuText actionBlock:theActionBlock subMenus:theSubMenus isSubMenu:NO];
    return self;
}


////////////////////////////////////////////////////////////////////
# pragma mark - designated initializer

- (id)initWithFrame:(CGRect)frame text:(NSString *)menuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus isSubMenu:(BOOL)theSubMenuFlag {
    self = [super initWithFrame:frame];
    if (self) {
        
        isSubMenu = theSubMenuFlag;
        
        [self setBackgroundColor:[UIColor yellowColor]];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [textLabel setText:menuText];
        [textLabel setFont:[UIFont preferredFontForTextStyle:isSubMenu ? UIFontTextStyleSubheadline : UIFontTextStyleHeadline]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setTextColor:[UIColor darkGrayColor]];
        [textLabel setNumberOfLines:3];
        [self addSubview:textLabel];
        self.menuLabel = textLabel;

        // create back side menu view with the menu items
        CGRect backsideMenuFrame = CGRectMake(0, 0, 200, 200);
        self.backsideMenuView = [[UIView alloc] initWithFrame:backsideMenuFrame];
        [self.backsideMenuView setBackgroundColor:[UIColor brownColor]];
        [self.backsideMenuView setHidden:YES];
        [self.backsideMenuView.layer setTransform:CATransform3DMakeRotation(M_PI, 0., 1., 0.)];
        [self addSubview:self.backsideMenuView];

        NSUInteger subMenuIndex = 0;
        for (RGFlipMenuView *subMenuView in theSubMenus) {
            NSAssert([subMenuView isKindOfClass:[RGFlipMenuView class]], @"expected instance RGMenuView class in backsideMenu array");
            
            CGRect frame = [self subMenuFrameWithIndex:subMenuIndex];
            [subMenuView setFrame:frame];
            [self.backsideMenuView addSubview:subMenuView];
            subMenuIndex ++;
        }
        
        self.subMenus = theSubMenus;
        
        self.isFrontsideShown = YES;
        self.actionBlock = theActionBlock;
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMenu)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


////////////////////////////////////////////////////////////////////
# pragma mark - Private

- (void)didTapMenu {
    
    if (isSubMenu) {
        self.actionBlock();
        
    } else {
        
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);

        // rotate menu back & forth
        [UIView animateWithDuration:1.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.layer setTransform:CATransform3DMakeRotation(M_PI_2, isLandscape ? 0. : 1., isLandscape ? 1. : 0., 0.)];
            
        } completion:^(BOOL finished) {
            
            [self toggleStatus];
            
            BOOL isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
            
            [UIView animateWithDuration:1.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut  animations:^{

                if (self.isFrontsideShown) {
                    [self.layer setTransform:CATransform3DIdentity];
                    
                    [self setCenter:originalCenter];
                    
                    // fan back (is that a phrase?) submenus
                    NSUInteger subMenuIndex = 0;
                    for (RGFlipMenuView *subMenuView in self.backsideMenuView.subviews) {
                        if (isLandscape)
                            [subMenuView setCenter:CGPointMake(subMenuView.center.x - subMenuIndex*CGRectGetWidth(self.frame), subMenuView.center.y)];
                        else
                            [subMenuView setCenter:CGPointMake(subMenuView.center.x, subMenuView.center.y - subMenuIndex*CGRectGetHeight(self.frame))];
                        subMenuIndex++;
                    }
                    
                } else {
                    
                    CATransform3D transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeRotation(M_PI_2, isLandscape ? 0. : 1., isLandscape ? 1. : 0., 0.));
                    
                    // on iPhone, make a bit smaller so it fits on screen
                    if (!isIPad)
                        transform = CATransform3DConcat(transform, CATransform3DMakeScale(0.9f, 0.9f, 0.9f));
                    
                    [self.layer setTransform:transform];
                    
                    originalCenter = self.center;
                    if (isLandscape)
                        [self setCenter:CGPointMake(self.center.x - CGRectGetWidth(self.frame), self.center.y)];
                    else
                        [self setCenter:CGPointMake(self.center.x, self.center.y - CGRectGetHeight(self.frame))];
                    
                    // fan out submenus
                    NSUInteger subMenuIndex = 0;
                    for (RGFlipMenuView *subMenuView in self.backsideMenuView.subviews) {
                        if (isLandscape)
                            [subMenuView setCenter:CGPointMake(subMenuView.center.x + subMenuIndex*CGRectGetWidth(self.frame), subMenuView.center.y)];
                        else
                            [subMenuView setCenter:CGPointMake(subMenuView.center.x, subMenuView.center.y + subMenuIndex*CGRectGetHeight(self.frame))];
                        
                        subMenuIndex++;
                    }
                    
                }

            } completion:^(BOOL finished) {
                self.isFrontsideShown ? self.actionBlock() : nil; // todoRG pending - call block of background menu
            }];
            
        }];
    }
}


- (void)toggleStatus {
    self.isFrontsideShown = !self.isFrontsideShown;
    [self.menuLabel setHidden:!self.isFrontsideShown];
    [self.backsideMenuView setHidden:self.isFrontsideShown];
}


- (CGRect)subMenuFrameWithIndex:(NSUInteger)index {
    CGFloat width = 90;
    CGFloat height = width;
    CGFloat xPadding = 10;
    CGFloat yPadding = xPadding;

    return CGRectMake(xPadding, yPadding, 180, 180);

//    switch (index) {
//        case 0:
//            return CGRectMake(xPadding, yPadding, width, height);
//            break;
//            
//        case 1:
//            return CGRectMake(width+2.*xPadding, yPadding, width, height);
//            break;
//
//        case 2:
//            return CGRectMake(xPadding, height+2.*yPadding, width, height);
//            break;
//
//        case 3:
//            return CGRectMake(width+xPadding, height+2.*yPadding, width, height);
//            break;
//
//        default:
//            NSAssert(NO, @"inconsistent - expected 0 <= index <= 3");
//            return CGRectMake(0, 0, 10, 10);
//            break;
//    }
}


@end
