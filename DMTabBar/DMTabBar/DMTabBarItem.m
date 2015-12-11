//
//  DMTabBarItem.m
//  DMTabBar - XCode like Segmented Control
//
//  Created by Daniele Margutti on 6/18/12.
//  Copyright (c) 2012 Daniele Margutti (http://www.danielemargutti.com - daniele.margutti@gmail.com).
//  All rights reserved.
//  Licensed under MIT License

#import "DMTabBarItem.h"

@interface DMTabBarButtonCell : NSButtonCell
@end

@interface DMTabBarItem()
@property (strong) NSButton *tabBarItemButton;
@end

@implementation DMTabBarItem

+ (DMTabBarItem *)tabBarItemWithIcon:(NSImage *)iconImage tag:(NSUInteger)itemTag
{
    return [[DMTabBarItem alloc] initWithIcon:iconImage tag:itemTag];
}

- (id)initWithIcon:(NSImage *)iconImage tag:(NSUInteger)itemTag
{
    if (self = [super init])
    {
        // Create associated NSButton to place inside the bar
        // (it's customized by DMTabBarButtonCell with a special gradient for selected state)
        _tabBarItemButton = [[NSButton alloc] initWithFrame:NSZeroRect];
        _tabBarItemButton.cell = [[DMTabBarButtonCell alloc] init];
        _tabBarItemButton.image = iconImage;
        _tabBarItemButton.enabled = YES;
        _tabBarItemButton.tag = itemTag;
        _tabBarItemButton.buttonType = NSToggleButton; // needed for on/off style buttons
        [_tabBarItemButton sendActionOn:NSLeftMouseDownMask];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[DMTabBarItem] tag=%i - title=%@", (int)self.tag, self.title];
}


#pragma mark -
#pragma mark - Properties redirects

// We simply redirects properties to the the NSButton class

- (NSImage *)icon
{
    return _tabBarItemButton.image;
}

- (void)setIcon:(NSImage *)newIcon
{
    _tabBarItemButton.image = newIcon;
}

- (NSImage *)alternateIcon
{
    return _tabBarItemButton.alternateImage;
}

- (void)setAlternateIcon:(NSImage *)newIcon
{
    _tabBarItemButton.alternateImage = newIcon;
}

- (NSInteger)tag
{
    return _tabBarItemButton.tag;
}

- (void)setTag:(NSInteger)newTag
{
    _tabBarItemButton.tag = newTag;
}

- (NSString *)toolTip
{
    return _tabBarItemButton.toolTip;
}

- (void)setToolTip:(NSString *)newToolTip
{
    _tabBarItemButton.toolTip = newToolTip;
}

- (NSUInteger) keyEquivalentModifierMask
{
    return _tabBarItemButton.keyEquivalentModifierMask;
}

- (void)setKeyEquivalentModifierMask:(NSUInteger)newKeyEquivalentModifierMask
{
    _tabBarItemButton.keyEquivalentModifierMask = newKeyEquivalentModifierMask;
}

- (NSString *)keyEquivalent
{
    return _tabBarItemButton.keyEquivalent;
}

- (void)setKeyEquivalent:(NSString *)newKeyEquivalent
{
    _tabBarItemButton.keyEquivalent = newKeyEquivalent;
}

- (NSInteger)state
{
    return _tabBarItemButton.state;
}

- (void)setState:(NSInteger)value
{
    _tabBarItemButton.state = value;
}

@end


#pragma mark - 
#pragma mark -

@implementation DMTabBarButtonCell

- (id)init
{
    if (self = [super init])
    {
        self.bezelStyle = NSTexturedRoundedBezelStyle;
    }
    return self;
}

- (NSInteger)nextState
{
    return self.state;
}
 
- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    /* DISABLED XCode STYLE DRAWING
     
    if (self.state == NSOnState)
    {
        // If selected we need to draw the border new background for selection
        // (otherwise we will use default back color)
        // Save current context
        [[NSGraphicsContext currentContext] saveGraphicsState];
        
        // Draw light vertical gradient
        [kDMTabBarItemGradient drawInRect:frame angle:-90.0f];
        
        // Draw shadow on the left border of the item
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = NSMakeSize(1.0f, 0.0f);
        shadow.shadowBlurRadius = 2.0f;
        shadow.shadowColor = [NSColor darkGrayColor];
        [shadow set];
        
        [[NSColor blackColor] set];        
        CGFloat radius = 50.0;
        NSPoint center = NSMakePoint(NSMinX(frame) - radius, NSMidY(frame));
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:center];
        [path appendBezierPathWithArcWithCenter:center radius:radius startAngle:-90.0f endAngle:90.0f];
        [path closePath];
        [path fill];
        
        // shadow of the right border
        shadow.shadowOffset = NSMakeSize(-1.0f, 0.0f);
        [shadow set];
        
        center = NSMakePoint(NSMaxX(frame) + radius, NSMidY(frame));
        path = [NSBezierPath bezierPath];
        [path moveToPoint:center];
        [path appendBezierPathWithArcWithCenter:center radius:radius startAngle:90.0f  endAngle:270.0f];
        [path closePath];
        [path fill];
        
        // Restore context
        [[NSGraphicsContext currentContext] restoreGraphicsState];
    }
     */

}

@end
