---
layout: default
title: Digital model of canopy
---

## Default usage

`grid_canopy` creates a canopy surface model using a LiDAR cloud of points. Using the local maximum algorithm, it assigns the elevation of the highest return within each grid cell to the grid cell center. It returns an object of class `grid_metrics`. A `grid_metrics` object is a `data.table` and therefore a `data.frame`, but because it is also a `grid_metrics` object you can plot it easily in 2D or 3D.

```r
canopy = grid_canopy(lidar)
plot(canopy)
```

![](images/grid_metrics-canopy.jpg)

## Resolution

`grid_canopy` has an optional parameter `res`. The cell size is the square of the resolution. Default is 2.

```r
canopy = grid_canopy(lidar, res = 2)
```
