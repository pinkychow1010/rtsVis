#' Fill NA values in a raster time series
#'
#' @param verbose (Optional) logical. If \code{TRUE} outputs progress. Default is \code{FALSE}. 
#' @param ... additional arguments to be passed on to  \link[raster]{approxNA}. Of particular interest is the \code{rule} argument which defines how first and last cells are dealt with. 
#' @param x_list_fill a list of raster objects.
#'
#' @return A list of rasters with NAs filled.
#' @importFrom raster approxNA
#' @author Johannes Mast
#' @details Loads all layers of a specific bands into a stack and uses \link[raster]{approxNA} to fill the NAs if possible. Note that the procedure requires the entire list of raster layery for each band to be be stacked. It is therefore very memory intensive and likely to fail for very large time series.
#' @export
#' @examples 
#' \donttest{
#' 
#' #Setup
#'  library(rtsVis)
#' x_list <- MODIS_SI_ds   #A list of raster objects
#' 
#' #Fill NAs
#' x_list_filled <- ts_fill_na(x_list)
#' }

ts_fill_na <- function(x_list_fill,verbose=F,...){
  for(n_l in 1:nlayers(x_list_fill[[1]])){
    if(verbose){
      print(paste0("Filling Layer:",n_l))
    }
    #make a brick from all the layers
    x_lay <- stack( .ts_subset_ts_util(x_list_fill,n_l) )
    #fill the nas
    x_lay_filled <- raster::approxNA(x_lay,...)
    #reassign the filled layers to the list elements
    for(n_r in 1:length(x_list_fill)){
      x_list_fill[[n_r]][[n_l]] <- x_lay_filled[[n_r]]
    }
  }
  return(x_list_fill)
}


