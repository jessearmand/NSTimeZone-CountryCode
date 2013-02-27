//
//  NSTimeZone+CountryCode.m
//
//  Created by Jesse Armand on 27/2/13.
//
//

#import "NSTimeZone+CountryCode.h"

@implementation NSTimeZone (CountryCode)

+ (NSString *)countryCodeFromLocalizedName
{
  NSString *countryCode = @"";

  [NSTimeZone resetSystemTimeZone];
  NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
  NSString *localizedName = [timeZone localizedName:NSTimeZoneNameStyleShortGeneric locale:[NSLocale systemLocale]];

  NSArray *components = [localizedName componentsSeparatedByString:@"("];

  if ([components count] > 0) {
    // What's inside the parentheses
    id lastComponent = [components lastObject];
    if ([lastComponent isKindOfClass:[NSString class]]) {
      NSString *lastString = lastComponent;
      NSRange whitespaceRange = [lastString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];

      NSRange closingParenthesesRange = [lastString rangeOfString:@")"];
      lastString = [lastString substringToIndex:closingParenthesesRange.location];

      // We found a space or more than two characters, it means it's not a country code, it's a two words name
      if (whitespaceRange.location != NSNotFound || [lastString length] > 2) {
        id firstComponent = [components objectAtIndex:0];
        if ([firstComponent isKindOfClass:[NSString class]]) {
          NSString *firstString = firstComponent;
          countryCode = [firstString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
      } else
        countryCode = lastString;
    }
  }

  return countryCode;
}

@end
