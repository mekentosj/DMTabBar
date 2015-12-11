//
//  DMTabBarItem.h
//  DMTabBar - XCode like Segmented Control
//
//  Created by Daniele Margutti on 6/18/12.
//  Copyright (c) 2012 Daniele Margutti (http://www.danielemargutti.com - daniele.margutti@gmail.com).
//  All rights reserved.
//  Licensed under MIT License

#import <Foundation/Foundation.h>

@interface DMTabBarItem : NSButtonCell

@property (strong) NSImage *icon;
@property (strong) NSImage *alternateIcon;
@property (strong) NSString *toolTip;                       
@property (copy) NSString *keyEquivalent;
@property (assign) NSUInteger keyEquivalentModifierMask;    
@property (assign) NSInteger state;                         

// Internal use
// We'll use a customized NSButton (+NSButtonCell) and apply it inside the bar for each item.
// You should never access to this element, but only with the DMTabBarItem istance itself.
@property (readonly, strong)  NSButton *tabBarItemButton;

+ (DMTabBarItem *)tabBarItemWithIcon:(NSImage *)iconImage tag:(NSUInteger)itemTag;
- (id)initWithIcon:(NSImage *)iconImage tag:(NSUInteger)itemTag;

@end
