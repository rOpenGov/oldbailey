\name{parse_trials}
\alias{parse_trials}
\title{Parse Old Bailey Trials}
\usage{
old_bailey_api_terms(
  cat = NULL
  )
}
\arguments{
\item{old_bailey_api_terms}{Return a list of terms corresponding to a category of crime. By default, the terms for all categories are returned.}
}

\value{
Dataframe containing API pull of terms and their categories.
}
\description{
For viewing terms and their categories.
}
\examples{
# Return a dataframe with the terms corresponding to the categories defendant gender, or defgen, and offense category, or offcat.
terms <- old_bailey_api_terms(cat = c("defgen", "offcat"))
head(terms)

}
