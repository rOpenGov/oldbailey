#' @noRd
detect_tagging_convention <- function(xml_address) {
  newer_tagging_convention <- FALSE
  
  flat_html <- readLines(con = xml_address)
  
  for(line in flat_html) { 
    if(grepl("type=\"witnessName\"", line) == TRUE) {
      newer_tagging_convention <- TRUE 
      break } }
  
  return(newer_tagging_convention) }


#' @importFrom rvest html_text
#' @importFrom rvest read_html
strip_tags <- function(body_text) {
  html_text(read_html(body_text)) }



#' @importFrom stringr str_trim
#' @importFrom stringr str_replace
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_match
#' @importFrom stringr str_extract
#' @noRd
xml_parser <- function(xml_address, newer_tagging_convention, n_xml_addresses, cycle) {
  print(paste0("Parsing ", xml_address))
  print(paste0(cycle, " out of ", n_xml_addresses, " trials."))
  
  flat_html <- readLines(con = xml_address)
  
  speaker_name_id <- "" # test
  
  # Define variables
  grab_defendant_name <- FALSE
  list_defendant_name <- list()
  defendant_surname <- ""
  defendant_given_name <- ""
  defendant_gender <- ""
  list_defendant_gender <- list()
  
  grab_victim_name <- FALSE
  list_victim_name <- list()
  victim_surname <- ""
  victim_given_name <- ""
  victim_gender <- ""
  list_victim_gender <- list()
  
  opened_person_name <- "<persName"
  closed_person_name <- "</persName"
  
  end_speaker <- FALSE
  grab_name <- FALSE
  
  current_speaker_name <- ""
  
  speaker_name <- ""
  speaker_surname <- ""
  speaker_given_name <- ""
  speaker_gender <- ""
  
  list_speaker_name <- list()
  list_speaker_gender <- list()
  list_body_text <- list()
  
  trial_account_id <- ""
  offence_category <- ""
  date <- ""
  #year <- ""
  list_offence_category <- list()
  list_offence_subcategory <- list()
  list_punishment_category <- list()
  list_punishment_subcategory <- list()
  list_verdict <- list()
  list_verdict_subcategory <- list()
  
  speaker_name_in_body_text_circa_1700 <- "^[[:alpha:]]+\\. "
  speaker_name_in_body_text_circa_1800 <- "^[[:upper:]]+ [[:upper:]]+(?=\\. )"
  
  list_crime_location <- list()
  place_name_id <- ""
  
  # if the paragraph ends in a period that is not preceded by an honorific
  # optional (e.g. ?) quotation mark, close parentheses
  honorifics <- "Mr\\. |MR\\. |Mrs\\. |MRS\\. |Sir\\. |SIR\\. |Dr\\. |DR\\.|Hon\\. |HON\\."
  paragraph_end <- "(?<!Mr|Sir|Dr|Miss|Mrs|Hon)\\.\"?\\)?$" # \\?? add question marks
  courtroom_delimiters <- "Acquitted|^Prisoner's Defence\\.$|^For the Prisoner\\.$|^Cross-examined\\.$|^GUILTY\\.?$"
  
  speech_id <- 0
  list_speech_id <- list()
  
  preprocess_remove_symbols <- c("(rs id=\").*(?=type)",
                                 "</rs>",
                                 "<hi rend=\"(.*)\">",
                                 "</hi>",
                                 "<lb>",
                                 "</lb>",
                                 "<p>",
                                 "</p>",
                                 "\\+",
                                 "<join(.*)join>",
                                 "<xptr(.*)>")
  
  #for(line in flat_html) {
  #  newer_tagging_convention <- detect_tagging_convention(line) }
  
  # start parsing 
  for(line in flat_html) {
    stripped_line <- str_trim(line, side = "both")

    # get rid of unwanted tags and misc. symbols 
    for(symbol in preprocess_remove_symbols) {
      stripped_line <- str_replace_all(stripped_line, symbol, "") }
    
    stripped_line <- str_replace_all(stripped_line, "\"$", "")# test
  
    stripped_line <- str_trim(stripped_line, side = "right")
    
    # skip lines that are blank
    if(stripped_line == "" ) {
      next }
    
    #print(stripped_line)
    
    if(grepl("type=\"trialAccount\"", stripped_line)) {
      trial_account_id <- str_match(stripped_line, "(?<=id=\").*(?=\")") } 
  
    #if(grepl("type=\"year\"", stripped_line)) {
    #  year <- str_match(stripped_line, "(?<=value=\").*(?=\")") } 
  
    if(grepl("type=\"date\"", stripped_line)) {
      date <- str_match(stripped_line, "(?<=value=\").*(?=\")") }
  
    if(grepl("type=\"verdictCategory\"", stripped_line)) {
      verdict <- str_match(stripped_line, "(?<=value=\").*(?=\")") 
      list_verdict <- append(list_verdict, verdict) }
    
    if(grepl("type=\"verdictSubcategory\"", stripped_line)) {
      verdict_subcategory <- str_match(stripped_line, "(?<=value=\").*(?=\")") 
      list_verdict_subcategory <- append(list_verdict_subcategory, verdict_subcategory) }
    
    if(grepl("type=\"offenceCategory\"", stripped_line)) {
      offence_category <- str_match(stripped_line, "(?<=value=\").*(?=\")") 
      list_offence_category <- append(list_offence_category, offence_category)}
  
    if(grepl("type=\"offenceSubcategory\"", stripped_line)) {
      offence_subcategory <- str_match(stripped_line, "(?<=value=\").*(?=\")") 
      list_offence_subcategory <- append(list_offence_subcategory, offence_subcategory) }
  
    if(grepl("type=\"punishmentCategory\"", stripped_line)) {
      punishment_category <- str_match(stripped_line, "(?<=value=\").*(?=\")") 
      list_punishment_category <- append(list_punishment_category, punishment_category) } 
  
    if(grepl("type=\"punishmentSubcategory\"", stripped_line)) {
      punishment_subcategory <- str_match(stripped_line, "(?<=value=\").*(?=\")") 
      list_punishment_subcategory <- append(list_punishment_subcategory, punishment_subcategory) } 
  
  
    # find placename and ID
    if(grepl("type=\"placeName\"", stripped_line) == TRUE) {
      place_name <- str_match(stripped_line, "(?<=value=\").*(?=\")") 
      place_name_id <- str_match(stripped_line, "(?<=inst=\").*(?=\" type)") }
  
    # match by ID to determine if the placename and is a crime location
    if(grepl(place_name_id, stripped_line) == TRUE) {
      if(grepl("value=\"crimeLocation\"", stripped_line) == TRUE) {
        crime_location <- str_match(stripped_line, "(?<=value=\").*(?=\")") 
        list_crime_location <- append(list_crime_location, place_name) } }
  
    
    if(grepl("<persName", stripped_line)) {
      # if the text is a person name tag but not the defendant introduced in the opening words
      if(grepl("type=\"defendantName\"|type=\"victimName\"", stripped_line) == FALSE) {
        grab_name <- TRUE
        #speaker_name_id <- str_match(stripped_line, "(?<=id=\").*(?= type)")
        speaker_name_id <- str_match(stripped_line, "(?<=id=\").*(?=\")") } 
      # if the text is a person name tag and is the defendant introduced in the opening words
      if(grepl("type=\"defendantName\"", stripped_line) == TRUE){
        grab_defendant_name <- TRUE }
      # if the text is a person name tag and is the victim introduced in the opening words
      if(grepl("type=\"victimName\"", stripped_line) == TRUE) {
        grab_victim_name <- TRUE } }
    
    if(grab_defendant_name == TRUE) {
      if(grepl("type=\"surname\"", stripped_line)) {
        defendant_surname <- str_extract(stripped_line, "(?<=value=\").*(?=\")") } 
    
      if(grepl("type=\"given\"", stripped_line)) {
        defendant_given_name <- str_extract(stripped_line, "(?<=value=\").*(?=\")") }
    
      if(grepl("type=\"gender\"", stripped_line)) {
        defendant_gender <- str_extract(stripped_line, "(?<=value=\").*(?=\")") }
    
      # if the defendant surname, given name, and gender have been captured, stop searching for the defendant
      if(defendant_surname != "" & defendant_given_name != "" & defendant_gender != "") {
        
        defendant_name <- paste(defendant_given_name, defendant_surname, sep = " ")
        list_defendant_name <- append(list_defendant_name, defendant_name)
        defendant_given_name <- ""
        defendant_surname <- ""
        
        list_defendant_gender <- append(list_defendant_gender, defendant_gender)
        defendant_gender <- ""
        
        grab_defendant_name <- FALSE } }
    
    
    if(grab_victim_name == TRUE) {
      if(grepl("type=\"surname\"", stripped_line)) {
        victim_surname <- str_extract(stripped_line, "(?<=value=\").*(?=\")") } 
      
      if(grepl("type=\"given\"", stripped_line)) {
        victim_given_name <- str_extract(stripped_line, "(?<=value=\").*(?=\")") }
      
      if(grepl("type=\"gender\"", stripped_line)) {
        victim_gender <- str_extract(stripped_line, "(?<=value=\").*(?=\")") }
      
      # if the victim surname, given name, and gender have been captured, stop searching for the victim
      if(victim_surname != "" & victim_given_name != "" & victim_gender != "") {
        victim_name <- paste(victim_given_name, victim_surname, sep = " ")
        list_victim_name <- append(list_victim_name, victim_name)
        
        victim_given_name <- ""
        victim_surname <- ""
        
        list_victim_gender <- append(list_victim_gender, victim_gender)
        victim_gender <- ""
        
        grab_victim_name <- FALSE } }
    
    
    if(newer_tagging_convention==FALSE) {
      # if the text is not a person name tag
      if(grepl("</persName", stripped_line) == TRUE) {
        if(grepl("type=\"given\"", stripped_line) == TRUE) { 
          speaker_given_name <- str_extract(stripped_line, "(?<=value=\").*(?=\")") } 
        grab_name <- FALSE } } 
    
    if(newer_tagging_convention == TRUE) {
        if(grepl(speaker_name_id, stripped_line)) {
          grab_name <- FALSE } }

    # if the text is a body paragraph or name
    if(grepl("^<", stripped_line) == FALSE) { 
    
      # if the text ends with a period
      if(grepl(paragraph_end, stripped_line, perl = TRUE) == TRUE) {
        end_speaker <- TRUE  }
    
      # if the text does not end with a period and is not one contiguous word (e.g. a name)
      if(grepl(paragraph_end, stripped_line, perl = TRUE) == FALSE & grepl("^[[:alpha:]]+$", stripped_line) == FALSE) {
        end_speaker <- FALSE }
    
      # if the text is a body paragraph or untagged name
      if(!(grab_name == TRUE & end_speaker == TRUE)) {
        
        if(grepl(speaker_name_in_body_text_circa_1800, stripped_line, perl = TRUE) == TRUE) {
          speaker_name <- str_match(stripped_line, speaker_name_in_body_text_circa_1800) }

        if(grepl(speaker_name_in_body_text_circa_1700, stripped_line) == TRUE) {
          if(grepl(honorifics, stripped_line) == FALSE) {
            speaker_name <- str_extract(stripped_line, speaker_name_in_body_text_circa_1700)
            stripped_line <- str_replace(stripped_line, speaker_name, "") } }

        if(grepl(courtroom_delimiters, stripped_line) == TRUE) {
          speaker_name <- "" }
      
        list_speaker_name <- append(list_speaker_name, speaker_name) 
        list_speaker_gender <- append(list_speaker_gender, speaker_gender)
        list_body_text <- append(list_body_text, stripped_line) } }
  
    # if the text is a speaker name
    if(grab_name == TRUE & end_speaker == TRUE) {
      
      if(grepl("type=\"surname\"", stripped_line)) {
        speaker_surname <- str_extract(stripped_line, "(?<=value=\").*(?=\")") } 
    
      if(grepl("type=\"given\"", stripped_line)) {
          speaker_given_name <- str_extract(stripped_line, "(?<=value=\").*(?=\")") } 
    
      if(grepl("type=\"gender\"", stripped_line)) {
        speaker_gender <- str_extract(stripped_line, "(?<=value=\").*(?=\")") }
      
      if(speaker_surname != "" & speaker_given_name != "" & speaker_gender != "") {
        speaker_name <- paste(speaker_given_name, speaker_surname, sep = " ")
        
        speaker_surname <- ""
        speaker_given_name <- ""
        speaker_gender <- "" } 
      } 
  }
  
  return(list(xml_address, list_body_text, list_speaker_name, list_crime_location, date, list_offence_category, list_offence_subcategory, trial_account_id, list_verdict, list_verdict_subcategory, list_defendant_name, list_defendant_gender, list_victim_name, list_victim_gender, list_punishment_category, list_punishment_subcategory)) } 


find_unique_speeches <- function(old_bailey_df) {
  # where a speech is defined as continuous text where the speaker column stays the same
  
  row <- 0
  list_speech_id <- list()
  last_speaker <- ""
  speech_id <- 0
  
  for(i in 1:nrow(old_bailey_df)) {
    row <- row + 1
    current_speaker <- old_bailey_df$speaker_name[row]
    if(current_speaker != last_speaker) {
      speech_id <- speech_id + 1 }
    list_speech_id <- append(list_speech_id, speech_id)
    last_speaker <- old_bailey_df$speaker_name[row] }
  
  return(list_speech_id) }

#' @importFrom dplyr %>%
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom dplyr group_by
#' @importFrom dplyr summarise
#' @importFrom dplyr left_join
#' @noRd
clean_returned_trial <- function(xml_address, 
                                 list_body_text,
                                 list_speaker_name,
                                 list_crime_location,
                                 date,
                                 list_offence_category,
                                 list_offence_subcategory,
                                 trial_account_id,
                                 list_verdict,
                                 list_verdict_subcategory,
                                 list_defendant_name,
                                 list_defendant_gender,
                                 list_victim_name,
                                 list_victim_gender,
                                 list_punishment_category,
                                 list_punishment_subcategory) {
  # make and export data frame with relevant fields
  
  # Visible bindings for global variables 
  speech_id <- ""
  speaker_name <- ""
  body_text <- ""
  defendant_name <- ""
  defendant_gender <- ""
  victim_name <- ""
  victim_gender <- ""
  crime_location <- ""
  offence_category <- ""
  offence_subcategory <- ""
  punishment_category <- ""
  punishment_subcategory <- ""
  verdict <- ""
  verdict_subcategory <- ""
  ########
  
  old_bailey_df <- data.frame(speaker_name = unlist(list_speaker_name), body_text = unlist(list_body_text))
  
  list_speech_id <- find_unique_speeches(old_bailey_df)
  
  old_bailey_df <- old_bailey_df %>%
    mutate(speech_id = list_speech_id) 
  
  unique_speakers <- old_bailey_df %>%
    select(speech_id, speaker_name) %>%
    unique()
  
  collapsed_body_text <- old_bailey_df %>%
    group_by(speech_id) %>%
    summarise(body_text = paste(body_text, collapse = " "))
  
  collapsed_body_text$body_text <- str_replace(collapsed_body_text$body_text, "^\\. ", "")
  
  collapsed_old_bailey_df <- left_join(unique_speakers, collapsed_body_text, by = "speech_id")
  
  
  
  old_bailey_df_and_metadata <- collapsed_old_bailey_df %>%
    mutate("xml_address" = xml_address,
           "trial_account_id" = trial_account_id,
           #"speech_id" = list_speech_id,
           #"crime_date" = crime_date,
           "date" = date,
           #"year" = year,
           "defendant_name" = paste(list_defendant_name, collapse = ", "),
           "defendant_gender" = paste(list_defendant_gender, collapse = ", "),
           "victim_name" = paste(list_victim_name, collapse = ", "),
           "victim_gender" = paste(list_victim_gender, collapse = ", "),
           "offence_category" = paste(list_offence_category, collapse = ", "),
           "offence_subcategory" = paste(list_offence_subcategory, collapse = ", "),
           "punishment_category" = paste(list_punishment_category, collapse = ", "),
           "punishment_subcategory" = paste(list_punishment_subcategory, collapse = ", "),
           "verdict" = paste(list_verdict, collapse = ", "), 
           "verdict_subcategory" = paste(list_verdict_subcategory, collapse = ", "),
           "crime_location" = paste(list_crime_location, collapse = ", ")) %>%
    select(trial_account_id,
           defendant_name,
           defendant_gender,
           victim_name,
           victim_gender,
           crime_location,
           offence_category,
           offence_subcategory,
           punishment_category,
           punishment_subcategory,
           verdict,
           verdict_subcategory,
           speech_id,
           speaker_name,
           body_text,
           date,
           xml_address)
  
  return(old_bailey_df_and_metadata) }

#' @importFrom dplyr bind_rows
#' @export
parse_trials <- function(xml_address) {
  n_xml_addresses <- length(xml_address)
  cycle <- 0
  
  #all_parsed_xml <- list()
  out <- data.frame()
  
  for(xa in xml_address) {
    cycle <- cycle + 1
  
  # flat_html <- readLines(con = xml_address)
  # if(identical(flat_html, character(0)) == TRUE) {
  #   stop("Failed to resolve host name. Are the address(es) correct") }
  
    newer_tagging_convention <- detect_tagging_convention(xa) 
    
    parsed_xml <- tryCatch(expr = { xml_parser(xa, newer_tagging_convention, n_xml_addresses, cycle) },
                           warning = function(w) {
                             #print(paste0("Failed at ", xa))
                             Sys.sleep(300)
                             xml_parser(xa, newer_tagging_convention, n_xml_addresses, cycle) } )
    
    Sys.sleep(.2)
  
  #return(parsed_xml)
  
  # if(identical(all_parsed_xml, list()) == TRUE) {
  #   all_parsed_xml <- append(all_parsed_xml, parsed_xml) }
  # else {
  #   cols <- 1:16
  #   for(i in cols) {
  #     all_parsed_xml[[i]] <- append(all_parsed_xml[[i]], list(parsed_xml[[i]])) } } }
  
  
  xml_index <- 1:16
  for(index in xml_index) {
    if(length(parsed_xml[[index]]) == 0) {
      parsed_xml[[index]] <- "" } }
    
  cleaned_df <- clean_returned_trial(xml_address <- parsed_xml[[1]],
                                     list_body_text <- parsed_xml[[2]],
                                     list_speaker_name <- parsed_xml[[3]],
                                     list_crime_location <- parsed_xml[[4]],
                                     date <- parsed_xml[[5]],
                                     offence_category <- parsed_xml[[6]],
                                     offence_subcategory <- parsed_xml[[7]],
                                     trial_account_id <- parsed_xml[[8]],
                                     verdict <- parsed_xml[[9]],
                                     verdict_subcategory <- parsed_xml[[10]],
                                     defendant_name <- parsed_xml[[11]],
                                     defendant_gender <- parsed_xml[[12]],
                                     victim_name <- parsed_xml[[13]],
                                     victim_gender <- parsed_xml[[14]],
                                     punishment_category <- parsed_xml[[15]],
                                     punishment_subcategory <- parsed_xml[[16]])

  
  
#  cleaned_df$body_text <- strip_tags(cleaned_df$body_text)
  
  cleaned_df$body_text <- str_replace_all(cleaned_df$body_text, "<.*?>", "")
  
  cleaned_df[] <- lapply(cleaned_df, str_trim)

  out <- bind_rows(out, cleaned_df) }
  return(out) }
