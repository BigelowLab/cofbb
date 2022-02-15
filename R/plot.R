#' Plot one or more bounding boxes
#' 
#' Suggests leaflet package, but will do simple plot if not available
#' 
#' @export
#' @param x sf data frame of bounding boxes
plot_bb <- function(x){
  stopifnot(inherits(x, "sf"))
  
  if (requireNamespace("leaflet", quietly = TRUE)) {
    pal <- leaflet::colorFactor("Dark2", x$name)
    leaflet::leaflet(data = x) |>
      leaflet::addTiles() |>
      leaflet::addPolygons(color = ~pal(name))
  } else {
    plot(x['name'])
  }
}