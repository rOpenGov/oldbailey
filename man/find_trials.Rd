\name{find_trials}
\alias{find_trials}
\title{Find Old Bailey Trials}
\usage{
find_trials(
  n_results = "all",
  cat = NA,
  term = NA
  )
}
\arguments{
\item{n_results}{The number of results to return. By default, all results are returned.}

\item{cat}{Find trials pertaining to a category. (optional).}

\item{term}{Find trials pertaining to a term. (optional).}
}

\value{
Dataframe containing API pull of XML addresses for Old Bailey Trials corresponding with the search criteria.
}
\description{
For finding Old Bailey trial data.
}
\examples{
# Return a dataframe with 5 trials.
trials <- find_trials(n_results = 5)
head(trials)

# Return a dataframe with 5 trials on deception. 
trials <- find_trials(n_results = 5, cat = "offcat", term = "deception")
head(trials)
}
