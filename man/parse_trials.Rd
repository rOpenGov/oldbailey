\name{parse_trials}
\alias{parse_trials}
\title{Parse Old Bailey Trials}
\usage{
parse_trials(
  xml_address
  )
}
\arguments{
\item{xml_address}{One or more XML addresses. A single XML address can be passed as a string, or numerous XML addresses can be passed as a list.}
}

\value{
Dataframe containing API pull of parsed Old Bailey Trials.
}
\description{
For parsing Old Bailey trial data.
}
\examples{
# Return a dataframe with parsed trial data.
xml_address <- "https://www.oldbaileyonline.org/obapi/text?div=t17690112-9"
parsed_trial <- parse_trials(xml_address)
head(parsed_trial)

}