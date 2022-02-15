cofbb
================

This R package serves the spatial bounding box definitions we use in the
Record Lab.

### Requirements

-   [R v4+](https://www.r-project.org/)

-   [rlang](https://CRAN.R-project.org/package=rlang)

-   [dplyr](https://CRAN.R-project.org/package=dplyr)

-   [sf](https://CRAN.R-project.org/package=sf)

### Suggested

-   [leaflet](https://CRAN.R-project.org/package=leaflet)

### Installation

    remotes::install_github("BigelowLab/cofbb")

### Usage

Retrieve a table of all known bounding boxes.

``` r
cofbb::get_table()
```

    ## # A tibble: 9 × 5
    ##   name       xmin  xmax  ymin  ymax
    ##   <chr>     <dbl> <dbl> <dbl> <dbl>
    ## 1 maine     -71.1 -67    43    47.5
    ## 2 gom       -72   -63    39    46  
    ## 3 nwa       -77   -51.5  37.9  56.7
    ## 4 nwa2      -77   -42.5  36.5  56.7
    ## 5 neac      -74   -59.8  41    48.2
    ## 6 liac      -74   -59.8  37.9  48.2
    ## 7 gosl      -67   -56.5  44.4  50.5
    ## 8 world    -180   180   -90    90  
    ## 9 world360    0   360   -90    90

Retrieve one or more regions by name as a table.

``` r
cofbb::get_bb(c("world", "nwa2"), form = "table")
```

    ## # A tibble: 2 × 5
    ##   name   xmin  xmax  ymin  ymax
    ##   <chr> <dbl> <dbl> <dbl> <dbl>
    ## 1 nwa2    -77 -42.5  36.5  56.7
    ## 2 world  -180 180   -90    90

Retrieve one or more regions by name as a list of vector in
`[xmin, xmax, ymin, ymax]` order.

``` r
cofbb::get_bb(c("world", "nwa2"), form = "bb")
```

    ## $world
    ## xmin xmax ymin ymax 
    ## -180  180  -90   90 
    ## 
    ## $nwa2
    ##  xmin  xmax  ymin  ymax 
    ## -77.0 -42.5  36.5  56.7

Or retrieve just one as a vector

``` r
cofbb::get_bb("gom", form = "bb")
```

    ## xmin xmax ymin ymax 
    ##  -72  -63   39   46

### Ancillary Functions

There are also functions for making `[-180, 180]` \<-> `[0,360]`
longitude transformations (`to_180BB()`, `to_360BB()`), splitting
bounding boxes (`bb_split()`) and determining if a box straddles a
particular line of longitude (`bb_straddles()`).

### [sf](https://CRAN.R-project.org/package=sf)

You can also retrieve bounding boxes as a data frame of one or more
[sf](https://CRAN.R-project.org/package=sf) POLYGON objects.

``` r
x <- cofbb::get_bb(c("gosl", "gom", "nwa2"), form = "sf")
x
```

    ## Simple feature collection with 3 features and 1 field
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -77 ymin: 36.5 xmax: -42.5 ymax: 56.7
    ## Geodetic CRS:  WGS 84
    ##   name                           geom
    ## 1 gosl POLYGON ((-67 44.4, -56.5 4...
    ## 2  gom POLYGON ((-72 39, -63 39, -...
    ## 3 nwa2 POLYGON ((-77 36.5, -42.5 3...

If you have [leaflet](https://CRAN.R-project.org/package=leaflet)
installed you can draw a pretty map (otherwise a boring map is drawn.)

    plot_bb(x)

![leaflet](inst/images/leaflet.png)
