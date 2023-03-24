#' @noRd
term_handler <- function(cat, term) {
  n <- 0
  terms_api_pattern <- list()
  for(t in term) {
    clean_term <- paste0("term", as.character(n), "=", cat, "_", t)
    n <- n + 1
    terms_api_pattern <- append(terms_api_pattern, clean_term) }
  
  return(paste0(terms_api_pattern, collapse = "&")) }


#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_split
#' @export
find_trials <- function(n_results = "all", cat = NA, term = NA) {
  # comments
  
  if((is.na(cat) == TRUE & is.na(term) == FALSE) | (is.na(term) == TRUE) & (is.na(cat) == FALSE )) {
    stop("Parameters \"cat\" (category) and \"term\" must be specified together. Else, return results without specifying key terms.") }
  
  base_url <- "https://www.oldbaileyonline.org/obapi/ob?"
  base_trial_url <- "https://www.oldbaileyonline.org/obapi/text?div="
  
  return_count <- 500
  start <- 0
  
  xml_addresses <- list()
  
  if(is.na(term) == FALSE & is.na(cat) == FALSE) { 
    term_api_pattern <- term_handler(cat, term) } 
  else {
    term_api_pattern <- ""}
  
  if(n_results == "all") {
    raw_data <- GET(paste0(base_url, term_api_pattern, "&count=", return_count, "&start=", start))
    data <- fromJSON(rawToChar(raw_data$content), flatten = TRUE)
    
    page_hits <- str_split(data$hits, " ")
    
    total_hits <- page_hits # loop appends to this list
    
    n_total_hits <- data$total 
    
    while(length(total_hits) < n_total_hits) {
      start <- start + return_count
      
      raw_data <- GET(paste0(base_url, term_api_pattern, "&count=", return_count, "&start=", start))
      data <- fromJSON(rawToChar(raw_data$content), flatten = TRUE)
      
      Sys.sleep(.2)
      
      page_hits <- str_split(data$hits, " ")
      total_hits <- append(total_hits, page_hits) } } 
  
  else {
    total_hits <- list()
    
    if (n_results > return_count) {
      
      n_results <- n_results - 500
      raw_data <- GET(paste0(base_url, term_api_pattern, "&count=", return_count, "&start=", start))
      data <- fromJSON(rawToChar(raw_data$content), flatten = TRUE)
      
      page_hits <- str_split(data$hits, " ")
      
      total_hits <- page_hits  # loop appends to this list 
      
      while(n_results - return_count > 0 & n_results > 500) {
        n_results <- n_results - return_count
        
        raw_data <- GET(paste0(base_url, term_api_pattern, "&count=", return_count, "&start=", start))
        data <- fromJSON(rawToChar(raw_data$content), flatten = TRUE) 
        Sys.sleep(.2)
      
        page_hits <- str_split(data$hits, " ")
        total_hits <- append(total_hits, page_hits) } }
    
    if(n_results <= return_count) {
      raw_data <- GET(paste0(base_url, term_api_pattern, "&count=", n_results, "&start=", start))
      data <- fromJSON(rawToChar(raw_data$content), flatten = TRUE)
      Sys.sleep(.2)
      
      page_hits <- str_split(data$hits, " ")
      total_hits <- append(total_hits, page_hits) } }
  
  for(hit in total_hits) {
    xml_addresses <- append(xml_addresses, paste0(base_trial_url, hit)) }
  
  return(xml_addresses) }
  
#xml_address <- find_trials(n_results = 520)
  