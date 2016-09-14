---
layout: default
title: Compute a series of descriptive statistics
---

The `grid_metrics` function makes rasters (cells) and enables computation of one or more metrics for each cell.
The size of the cells is given by the parameter `res` (for resolution). The cell area is the square of the resolution. The desired metric is given by an expression in the parameter `func`. The `grid_metrics` function returns a `grid_metrics` object.

## Grid one metric

The following code enable to compute the mean height of the returns in each automatically computed 400 square meters cells.

```r
hmean = lidar %>% grid_metrics(20, mean(Z))
plot(hmean)
```
    
 ![](images/grid_metrics-mean.jpg)
 
Several functions provided by the package correspond to a `grid_metrics` alias.

[`grid_canopy`](canopy.html) is an alias for:

```r
canopy = lidar %>% grid_metrics(2, max(Z))
plot(canopy)
```
    
![](images/grid_metrics-canopy.jpg)

`grid_density` is an alias for:

```r
density = lidar %>% grid_metrics(4, length(unique(pulseID))/16)
plot(density)
```
    
![](images/pulse.png)


Some functions are already available in the package, for example `entropy` or `vci`

```r
entropy = lidar %>% grid_metrics(20, entropy(Z))
vci     = lidar %>% grid_metrics(20, vci(Z, zmax = 40))
 ```
 
The user can use its own functions

## Grid multiple metrics

When we want to compute several metrics we would like to compute each metric at the same time. We can use `grid_metrics` with a function which return several values in a labelled `list`:

### Define your own metric function

```r
myMetrics = function(z, i, angle, pulseID, area)
{
  ret = list(
  density = length(unique(pulseID))/area,
  hmean   = mean(z),
  hmax    = max(z),
  imean   = mean(i),
  angle   = mean(abs(angle))
  )

  return(ret)
}
```
    
The about page [common miss usage of grid_metrics](gridmetrics-error.html) provides further details on how to write a proper function. An internal system check the output of the user's function before to run the `grid_metrics` funtion.

### Use your own function in grid_metrics

    metrics = grid_metrics(lidar, 20, myMetrics(Z, Intensity, ScanAngle, pulseID, 400))

## split_flightline option

`grid_metrics` allows for an optional parameter named `option`. You can set this parameter to `"split_flighline"`. In this case, the algorithm will compute the metrics on each flighline individually. In this case in the overlaps, for example, you will have the same raster twice.

    metrics = grid_metrics(lidar, 20, myMetrics(Z, Intensity, ScanAngle, pulseID, 400), option = "split_flightline")

## cloudMetrics

The function `cloudMetrics` works exactly like `grid_metrics` but it does not have a `resolution` parameter and it does not make cells. It only computes one or several metrics on a cloud of points based on the function given in the parameter. It is useful for computing metrics on a single plot inventory.

    metrics = cloud_metrics(lidar, myMetrics(Z, Intensity, ScanAngle, pulseID, 400), option = "split_flightline")

## Quality control for grid_metrics and geographic data

The previous sections showed how to efficiently process a dataset. It returns a list of plots with the associated metrics. But some plots fall in water and the algorithm cannot guess that. Some plots are incomplete because they fall at the edge of the file or the edge of a flightline, or in this edge of a void area (providers removed some data), or for other good reasons. The algorithm makes cells but it does not control what was in the cells. You can control the quality of cells in two ways:

- [Using quality metrics](gridmetrics-control.html)
- [Filtering data based on shapefiles](classify_from_shapefile.html)
