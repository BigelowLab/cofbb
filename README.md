cofbb
================

This R package serves the spatial bounding box definitions we use in the
Record Lab.

### Requirements

- [R v4+](https://www.r-project.org/)

- [rlang](https://CRAN.R-project.org/package=rlang)

- [dplyr](https://CRAN.R-project.org/package=dplyr)

- [sf](https://CRAN.R-project.org/package=sf)

### Suggested

- [leaflet](https://CRAN.R-project.org/package=leaflet)

### Installation

    remotes::install_github("BigelowLab/cofbb")

### Usage

Retrieve a table of all known bounding boxes.

``` r
cofbb::get_table()
```

    ## # A tibble: 19 × 6
    ##    name                xmin  xmax  ymin  ymax longname                       
    ##    <chr>              <dbl> <dbl> <dbl> <dbl> <chr>                          
    ##  1 maine              -71.1 -67    43    47.5 State of Maine                 
    ##  2 gom                -72   -63    39    46   Gulf of Maine                  
    ##  3 gom_carcharodon    -74.9 -63    38.8  46   GoM for White Sharks           
    ##  4 nwa_orig           -77   -51.5  37.9  56.7 Northwest Atlantic             
    ##  5 nwa                -77   -42.5  36.5  56.7 Northwest Atlantic 2           
    ##  6 nwa2               -77   -42.5  36.5  56.7 Northwest Atlantic 2           
    ##  7 chfc               -77   -42.5  35    56.7 Cape Hatteras to Flemish Cap   
    ##  8 neac               -74   -59.8  41    48.2 New England and Atlantic Canada
    ##  9 liac               -74   -59.8  37.9  48.2 Long Island and Atlantic Canada
    ## 10 gosl               -67   -56.5  44.4  50.5 Gulf of St. Lawrence           
    ## 11 world             -180   180   -90    90   World                          
    ## 12 world360             0   360   -90    90   World 360                      
    ## 13 njgb               -74.9 -66    38.8  42.6 New Jersey to Georges Bank     
    ## 14 nefsc_carcharodon  -74.9 -65    38.8  46   NEFSC White Shark              
    ## 15 cape_cod           -69.2 -70.9  41.4  42.2 Cape Cod                       
    ## 16 cold_blob          -30   -15    42    60   North Atalantic Cold Blob      
    ## 17 warm_spot          -74   -58    36    42   Warm Spot                      
    ## 18 nh                -180     0   180    90   Northern Hemisphere            
    ## 19 sh                -180   -90   180     0   Southern Hemisphere

Retrieve one or more regions by name as a table.

``` r
cofbb::get_bb(c("world", "chfc"), form = "table")
```

    ## # A tibble: 2 × 6
    ##   name   xmin  xmax  ymin  ymax longname                    
    ##   <chr> <dbl> <dbl> <dbl> <dbl> <chr>                       
    ## 1 chfc    -77 -42.5    35  56.7 Cape Hatteras to Flemish Cap
    ## 2 world  -180 180     -90  90   World

Retrieve one or more regions by name as a list of vector in
`[xmin, xmax, ymin, ymax]` order.

``` r
cofbb::get_bb(c("world", "chfc"), form = "bb")
```

    ## $world
    ## xmin xmax ymin ymax 
    ## -180  180  -90   90 
    ## 
    ## $chfc
    ##  xmin  xmax  ymin  ymax 
    ## -77.0 -42.5  35.0  56.7

Or retrieve just one as a vector

``` r
cofbb::get_bb("gom", form = "bb")
```

    ## xmin xmax ymin ymax 
    ##  -72  -63   39   46

### Ancillary Functions

There are also functions for making `[-180, 180]` \<-\> `[0,360]`
longitude transformations (`to_180BB()`, `to_360BB()`), splitting
bounding boxes (`bb_split()`) and determining if a box straddles a
particular line of longitude (`bb_straddles()`).

### [sf](https://CRAN.R-project.org/package=sf)

You can also retrieve bounding boxes as a data frame of one or more
[sf](https://CRAN.R-project.org/package=sf) POLYGON objects.

``` r
x <- cofbb::get_bb(c("gosl", "gom", "chfc"), form = "sf")
x
```

    ## Simple feature collection with 3 features and 1 field
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -77 ymin: 35 xmax: -42.5 ymax: 56.7
    ## Geodetic CRS:  WGS 84
    ##   name                           geom
    ## 1 gosl POLYGON ((-67 44.4, -56.5 4...
    ## 2  gom POLYGON ((-72 39, -63 39, -...
    ## 3 chfc POLYGON ((-77 35, -42.5 35,...

If you have [leaflet](https://CRAN.R-project.org/package=leaflet)
installed you can draw a pretty map (otherwise a boring map is drawn.)

    plot_bb(x)

<figure>
<img src="inst/images/leaflet.png" alt="leaflet" />
<figcaption aria-hidden="true">leaflet</figcaption>
</figure>

## Updating

Pre-packaged data are stored in locally in
`/mnt/s1/projects/ecocast/coredata/cofbb/bbox_lonlat.csv` and are then
absorbed into the package. Updates to the package can happen at any
time. First, edit the source data file to suit your needs. Then run the
following…

    $ Rscript /mnt/ecocast/corecode/R/cofbb/scripts/update_package.R

If you do the above with `sudo` privileges then it will be installed
into the system-wide R package library, otherwise it will be installed
into the user R package library.

# NOTE on `nwa` and `nwa2`

As of 2025-03-10 `nwa` has been renamed `nwa_orig` but it is essentially
deprecated. `nwa` and `nwa2` now point to the same bounding box which
modified from `nwa_orig` to accommodate Flemish Cap. The point is,
calling for `nwa` and `nwa2` is now the same thing.
