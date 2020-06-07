# FurysToolbox

A collection of potentially useful UIKit views, available through SPM

## SeparatorView

Mimics the separator on tableviews, has an intrinsic size of 1 physical pixel (rather than 1 logical pixel). Can be used to separate rows or columns where a tableview isn’t being used.


## RoundedRectangleView

Can be used as a mask or container, will have nice smooth round corners which are used by the system in iOS. Radius is configurable, as are the corners to apply to. Set `fillColor` to adjust the color.

This is in contrast to setting layer.cornerRadius on a view which has abrupt corners.

## RoundedImageView

Can be used to mask an image with nice rounded corners. If `cornerRadius` is negative then the corners will be equal to `min(width, height)` (which means if the image is a square it will appear as a circle).

## NotificationBannerView

A generic notification banner that can be used to provide a user with ad-hoc information. Includes a swipe down dismiss gesture.
