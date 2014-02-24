AffiliateLinkify
================

Open links to apps or any iTunes content through AffiliateLinkify and get paid. You can earn affiliate commissions on all iTunes content including: iOS apps, Mac apps, movies, TV shows, eBooks, and music. The current rate (2/24/2014) is a 7% commission for 24 hours. After a user clicks your link, you will earn 7% of their purchases (including in-app purchases, purchases of other apps they buy, and even Apple TV rentals) for the next 24 hours unless they click someone else's affiliate link in the mean time.

##Setup
1. Apply for the [iTunes affiliate program](https://www.apple.com/itunes/affiliates/).
2. Copy the AffiliateLinkify directory into your project.
3. Replace the `kAffiliateCode` constant with your own affiliate code.

##Usage
###Is it an iTunes content link?
Check if your link is valid to earn commissions through the affiliate program with `[AffiliateLinkify isValidURL:url]`

###Opening the App Store app
Where you would normally use `[[UIApplication sharedApplication] openURL:url]` for an iTunes link, use `[[UIApplication sharedApplication] openAffiliateURL:url]`

###Launching the product view controller
If you would prefer that users view iTunes content without leaving your app, you can launch the product view controller. AffiliateLinkify ensures that your affiliate link is used so that any purchases through the product view controller will be attributed to you.

Create an AffiliateLinkify object and call `openInternalAppStoreWithURL:fromViewController:delegate:`. The delegate must conform to the SKStoreProductViewControllerDelegate protocol.

	AffiliateLinkify *affiliateLinkify = [[AffiliateLinkify alloc] init];
	[affiliateLinkify openInternalAppStoreWithURL:url
                           	   fromViewController:self
                                         delegate:self];

