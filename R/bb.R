#' Retrieve the entire table of known bounding boxes
#'
#' @export
#' @return table of bounding boxes
get_table <- function(){
  dplyr::tribble(
    ~name,       ~xmin,   ~xmax,    ~ymin,  ~ymax,
    'maine',     -71.1,   -67,      43,     47.5,
    'gom',       -72,     -63,      39,     46,
    'nwa',       -77,     -51.5,    37.9,   56.7,
    'nwa2',      -77,     -42.5,    36.5,   56.7,
    'neac',      -74,     -59.75,   41,     48.15,
    'liac',      -74,     -59.75,   37.9,   48.15,
    'gosl',      -67,     -56.5,    44.4,   50.5,
    'world',     -180,    180,      -90,    90,
    'world360',  0,       360,      -90,    90)
}

#' Retrieve a single bounding box as either a table or vector
#'
#' @export
#' @param reg character, one or more named regions to retrieve.
#'             By default 'world'
#' @param form character, either 'bb' or 'table'
#' @return 4-element numeric vector, or a list of 4-element vectors
#'         or a table (tibble)
get_bb <- function(reg, form = c("table", "bb")[2]){
  if (missing(reg)) reg <- "world"

  if (tolower(form[1]) == 'table'){
    x <- get_table() %>%
      dplyr::filter(.data$name %in% reg)
  } else {
    if (length(reg) > 1){
      x <- sapply(reg, get_bb, form = 'bb', simplify = FALSE)
    } else {
      x <- get_table() %>%
        dplyr::filter(.data$name == reg) %>%
        dplyr::select(-.data$name) %>%
        unlist()
    }
  }
  return(x)
}


#' Convert bounding box [0,360] longitudes to [-180, 180]
#'
#' Bounding boxes are 4 element vectors of [left, right, bottom, top]
#'
#' @export
#' @param x numeric bounding box vector, no check is done for being withing 0,360 range
#' @return numeric bounding box vector
to180BB <- function(x) {
  x[1:2] <- to180(x[1:2])
  if (identical(x[1], 180)) x[1] <- -180
  if (identical(x[2], -180)) x[2] <- 180
  x
}

#' Convert [-180,180] bounding box longitudes to [0,360]
#'
#' Bounding boxes are 4 element vectors of [left, right, bottom, top]
#'
#' @export
#' @param x numeric bounding box vector, no check is done for being withing 0,360 range
#' @return numeric bounding box vector
to360BB <- function(x) {
  x[1:2] <- to360(x[1:2])
  if (identical(x[1], 360)) x[1] <- 0   # western edge
  if (identical(x[2], 0)) x[2] <- 360   # eastern edge
  x
}

#' Convert [0,360] longitudes to [-180, 180]
#'
#' @seealso \href{https://gis.stackexchange.com/questions/201789/verifying-formula-that-will-convert-longitude-0-360-to-180-to-180/201793}{gis.stackexchange}
#' @export
#' @param x numeric vector, no check is done for being withing [0, 360] range
#' @return numeric vector
to180 <- function(x) {
  x <- ((x + 180) %% 360) - 180
  x
}

#' Convert [-180,180] longitudes to [0, 360]
#'
#' @seealso \href{https://gis.stackexchange.com/questions/201789/verifying-formula-that-will-convert-longitude-0-360-to-180-to-180/201793}{gis.stackexchange}
#' @export
#' @param x numeric vector, no check is done for being within [0,3 60] range
#' @return numeric vector
to360 <- function(x) {x %% 360}

#' Split a bounding box into two at \code{at}
#'
#' @export
#' @param bb numeric, 4 element bouding box of left, right, bottom and top coordinates
#' @param at numeric, longitude to split around
#' @return list of one or two bounding box vectors
bb_split <- function(bb = c(-170,50,-60,60),
                     at = 0){
  if (bb_straddles(bb, at = at)){
    x <- list(
      bb1 = c(bb[1], at, bb[3:4]),
      bb2 = c(at, bb[2:4])
    )
  } else {
    x <- list(bb1 = bb, bb2 = NULL)
  }
  x
}

#' Test if a bounding box straddles a longitude
#'
#' @export
#' @param bb numeric, 4 element bouding box
#' @param at numeric, longitude to split around
#' @return logical
bb_straddles <- function(bb = c(-170,50,-60,60),
                         at = 0){
  bb[1] < at && bb[2] > at
}
