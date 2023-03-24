#' @importFrom dplyr filter
#' @importFrom stringr str_detect
#' @noRd
filter_category <- function(api_terms_df, cat) {
  if(length(cat) > 1) {
    cat <- paste(category, collapse = "|") }
  
  api_terms_df %>%
    filter(str_detect(name, cat)) }

#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom tidyr unnest 
#' @export
old_bailey_api_terms <- function(cat = NULL) {
  api_terms_raw <- GET("https://www.oldbaileyonline.org/obapi/terms")
  api_terms <- fromJSON(rawToChar(api_terms_raw$content), flatten = TRUE)
  api_terms_df <- unnest(api_terms, terms)
  
  if(!(is.null(cat))) {
    api_terms_df <- filter_category(api_terms_df, cat) }
  return(api_terms_df) }