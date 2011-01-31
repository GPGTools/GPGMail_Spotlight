#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h> 
#import <Foundation/Foundation.h>

/* -----------------------------------------------------------------------------
   Step 1
   Set the UTI types the importer supports
  
   Modify the CFBundleDocumentTypes entry in Info.plist to contain
   an array of Uniform Type Identifiers (UTI) for the LSItemContentTypes 
   that your importer can handle
  
   ----------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------
   Step 2 
   Implement the GetMetadataForURL function
  
   Implement the GetMetadataForURL function below to scrape the relevant
   metadata from your document and return it as a CFDictionary using standard keys
   (defined in MDItem.h) whenever possible.
   ----------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------
   Step 3 (optional) 
   If you have defined new attributes, update schema.xml and schema.strings files
   
   The schema.xml should be added whenever you need attributes displayed in 
   Finder's get info panel, or when you have custom attributes.  
   The schema.strings should be added whenever you have custom attributes. 
 
   Edit the schema.xml file to include the metadata keys that your importer returns.
   Add them to the <allattrs> and <displayattrs> elements.
  
   Add any custom types that your importer requires to the <attributes> element
  
   <attribute name="com_mycompany_metadatakey" type="CFString" multivalued="true"/>
  
   ----------------------------------------------------------------------------- */



/* -----------------------------------------------------------------------------
    Get metadata attributes from file
   
   This function's job is to extract useful information your file format supports
   and return it as a dictionary
   ----------------------------------------------------------------------------- */

Boolean GetMetadataForURL(void* thisInterface, 
			   CFMutableDictionaryRef attributes, 
			   CFStringRef contentTypeUTI,
			   CFURLRef urlForFile)
{
    /* Pull any available metadata from the file at the specified path */
    /* Return the attribute keys and attribute values in the dict */
    /* Return TRUE if successful, FALSE if there was no data provided */
	Boolean success=NO;
    NSDictionary *tempDict;
    NSAutoreleasePool *pool;
	
	NSLog(@"[gpgmailimporter] : invoked with %@", urlForFile);
	
    // Don't assume that there is an autorelease pool around the calling of this function.
    pool = [[NSAutoreleasePool alloc] init];
    // load the document at the specified location
    tempDict=[[NSDictionary alloc] initWithContentsOfFile:(NSString *)urlForFile];
    if (tempDict)
    {
		// set the kMDItemTitle attribute to the Title
		[(NSMutableDictionary *)attributes setObject:[tempDict objectForKey:@"title"]
											  forKey:(NSString *)kMDItemTitle];
		
		// set the kMDItemAuthors attribute to an array containing the single Author
		// value
		[(NSMutableDictionary *)attributes setObject:[NSArray arrayWithObject:[tempDict objectForKey:@"author"]]
											  forKey:(NSString *)kMDItemAuthors];
		
		// set our custom document notes attribute to the Notes value
		// (in the real world, you'd likely use the kMDItemTextContent attribute, however that
		// would make it hard to demonstrate using a custom key!)
		[(NSMutableDictionary *)attributes setObject:[tempDict objectForKey:@"notes"]
											  forKey:@"com_apple_myCocoaDocumentApp_myCustomDocument_notes"];
		
		// return YES so that the attributes are imported
		success=YES;
		
		// release the loaded document
		[tempDict release];
    }
    [pool release];
    return success;
/*    
	char cpath[PATH_MAX];
	CFMutableStringRef unencrypted_message;
	
	printf("[gpgmailimporter] : opening %s", urlForFile);
	if (CFStringGetCString(urlForFile, cpath, sizeof(cpath), kCFStringEncodingUTF8) == FALSE) {
		return FALSE;
	}

	printf("[gpgmailimporter] : parsing %s", cpath);
	unencrypted_message = CFStringCreateMutable(NULL, 0);
    // todo: check if is encrypted a uncrypt if true

	CFDictionarySetValue(attributes, kMDItemTextContent, unencrypted_message);
	CFDictionarySetValue(attributes, kMDItemKind, CFSTR("OpenPGP"));
	CFDictionarySetValue(attributes, kMDItemCreator, CFSTR("openpgp"));
	CFRelease(unencrypted_message);
	
	return TRUE;
 */
}
