//
//  SandboxUtilities.h
//  Created by Ashley Ramsey on 4/06/11.
//  Copyright 2011 ashramsey. All rights reserved.
//

static NSString * const kSandboxUtilitiesVersion = @"1.0.5";
static NSString * const kAlertTitle = @"BW Sandbox";
static BOOL const kMessageActive = YES;

// populated from loadDidView
UITextView * messageTextView;

void message ( NSString *format, ... );
void alertMessage ( NSString *format, ... );
NSString * flattenHTML ( NSString * html );
NSString * trimString ( NSString * string );
