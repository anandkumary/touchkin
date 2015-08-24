//
//  KnobView.h
//  circularProgressVIew
//
//  Created by Anand Kumar  on 8/17/15.
//  Copyright (c) 2015 YMediaLabs. All rights reserved.
//

#import "TKSplitView.h"
//IB_DESIGNABLE
@interface KnobView : TKSplitView

@property (nonatomic, assign) CGFloat ratio;

-(void) addKnobAnimtation;
@end
