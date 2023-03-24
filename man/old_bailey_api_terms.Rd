\name{old_bailey_api_terms}
\alias{old_bailey_api_terms}
\title{View Old Bailey API Terms}
\usage{
old_bailey_api_terms(
  cat = NULL
  )
}
\arguments{
\item{cat}{Return terms corresponding to a category of crime. By default, all terms and categories are returned.}
}

\value{
Dataframe containing API pull of terms and their categories.
}
\description{
For viewing terms and their categories.
}
\examples{
# Return a dataframe with the terms corresponding to defendant gender or offensive category.
terms <- old_bailey_api_terms(cat = c("defgen", "offcat"))
head(terms)

}
