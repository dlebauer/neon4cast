## grab data 
#project = "phenology"
#dir = "~/efi_neon_challenge/forecasts/"

#' Download forecasts for NEON sites from the EFI server
#'  
#' @param theme string of the theme
#' @param date start date for the forecast
#' @param dir storage location.  Use tempdir unless you want to keep this 
#' data around on your computer, in which case, `neonstore::neon_dir()` might
#' be a convenient choice.
#' @export
#' @examples 
#' download_forecast("phenology")
download_forecast <- function(theme,
                         date = Sys.Date()-2, 
                         dir = tempdir()){
  lapply(theme, download_forecast_, date, dir)
  invisible(dir)
}
download_forecast_ <- function(theme, 
                          date = Sys.Date()-2, 
                          dir = tempdir()){
  
  dir.create(dir, FALSE, TRUE)
  parent_theme <- unlist(stringr::str_split(theme, "_"))[1]
  prefix <- paste(parent_theme, paste0(theme,"-", date), sep="/")
  object <- aws.s3::get_bucket("forecasts",
                               prefix = prefix,
                               region = "data",
                               base_url = "ecoforecast.org")
  
  for(i in seq_along(object)){
    aws.s3::save_object(object[[i]], 
                        bucket = "forecasts", 
                        file = file.path(dir, object[[i]]$Key),
                        region = "data",
                        base_url = "ecoforecast.org")
  }
}