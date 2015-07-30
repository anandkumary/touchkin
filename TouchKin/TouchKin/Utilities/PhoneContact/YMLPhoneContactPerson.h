

#import <Foundation/Foundation.h>

/*
 // Property keys
 AB_EXTERN const ABPropertyID kABPersonFirstNameProperty;          // First name - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonLastNameProperty;           // Last name - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonMiddleNameProperty;         // Middle name - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonPrefixProperty;             // Prefix ("Sir" "Duke" "General") - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonSuffixProperty;             // Suffix ("Jr." "Sr." "III") - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonNicknameProperty;           // Nickname - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonFirstNamePhoneticProperty;  // First name Phonetic - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonLastNamePhoneticProperty;   // Last name Phonetic - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonMiddleNamePhoneticProperty; // Middle name Phonetic - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonOrganizationProperty;       // Company name - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonJobTitleProperty;           // Job Title - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonDepartmentProperty;         // Department name - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonEmailProperty;              // Email(s) - kABMultiStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonBirthdayProperty;           // Birthday associated with this person - kABDateTimePropertyType
 AB_EXTERN const ABPropertyID kABPersonNoteProperty;               // Note - kABStringPropertyType
 AB_EXTERN const ABPropertyID kABPersonCreationDateProperty;       // Creation Date (when first saved)
 AB_EXTERN const ABPropertyID kABPersonModificationDateProperty;   // Last saved date
 
 // Addresses
 AB_EXTERN const ABPropertyID kABPersonAddressProperty;            // Street address - kABMultiDictionaryPropertyType
 AB_EXTERN const CFStringRef kABPersonAddressStreetKey;
 AB_EXTERN const CFStringRef kABPersonAddressCityKey;
 AB_EXTERN const CFStringRef kABPersonAddressStateKey;
 AB_EXTERN const CFStringRef kABPersonAddressZIPKey;
 AB_EXTERN const CFStringRef kABPersonAddressCountryKey;
 AB_EXTERN const CFStringRef kABPersonAddressCountryCodeKey;
 
 // Phone numbers
 AB_EXTERN const ABPropertyID kABPersonPhoneProperty;              // Generic phone number - kABMultiStringPropertyType
 AB_EXTERN const CFStringRef kABPersonPhoneMobileLabel;
 AB_EXTERN const CFStringRef kABPersonPhoneIPhoneLabel __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
 AB_EXTERN const CFStringRef kABPersonPhoneMainLabel;
 AB_EXTERN const CFStringRef kABPersonPhoneHomeFAXLabel;
 AB_EXTERN const CFStringRef kABPersonPhoneWorkFAXLabel;
 AB_EXTERN const CFStringRef kABPersonPhoneOtherFAXLabel __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
 AB_EXTERN const CFStringRef kABPersonPhonePagerLabel;
 AB_EXTERN const CFStringRef kABPersonInstantMessageServiceGoogleTalk __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
 AB_EXTERN const CFStringRef kABPersonInstantMessageServiceSkype __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
 AB_EXTERN const CFStringRef kABPersonInstantMessageServiceFacebook __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);

 */

@interface YMLPhoneContactPerson : NSObject

@property (nonatomic, copy) NSString *contactID;
@property (nonatomic, copy) NSString *firstName, *lastName, *middleName, *jobTitle, *city, *zip, *country, *countryCode;
@property (nonatomic, copy) NSString *googleTalk, *skype, *facebook;
@property (nonatomic, strong) NSMutableArray *emails, *phoneNumbers;
@property (nonatomic, strong) NSData *imageData;

@end
