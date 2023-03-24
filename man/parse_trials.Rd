\name{parse_trials}
\alias{parse_trials}
\title{Parse Old Bailey Trials}
\usage{
xml_address(
  xml_address = ""
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
# Return a dataframe with 50 parsed trials.
trials <- parse_trials(find_trials(n_results = 50))
head(trials)

}