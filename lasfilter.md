---
layout: default
title: Filter a cloud of points
---

The function `lasfilter` allows for filtering of the cloud of points based on a set of conditions. This function is based on `dplyr::filter` and works in the same way.

## Get only the first returns

```r
firstReturns = lidar %>% lasfilter(ReturnNumber == 1)
```
    
## Get only non-ground returns

```r
vegetation = lidar %>% lasfilter(Classification != 2)
```
    
## Get only first returns with a scan angle of 0 degrees

```r
first0 = lidar %>% lasfilter(ReturnNumber == 1, ScanAngle == 0)
```
    
# Alias

Some extract functions are already defined in the package with aliased names.

```r
lidar %>% getFirst
lidar %>% getLast
lidar %>% getFirstLast
lidar %>% getFirstOfMany
lidar %>% getSingle
lidar %>% getGround
```
