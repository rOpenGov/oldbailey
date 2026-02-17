# Find Old Bailey Trials

For finding Old Bailey trial data.

## Usage

``` r
find_trials(
  n_results = "all",
  cat = NA,
  term = NA
  )
```

## Arguments

- n_results:

  The number of results to return. By default, all results are returned.

- cat:

  Find trials pertaining to a category. (optional).

- term:

  Find trials pertaining to a term. (optional).

## Value

Dataframe containing API pull of XML addresses for Old Bailey Trials
corresponding with the search criteria.

## Examples

``` r
# Return a dataframe with 5 trials.
trials <- find_trials(n_results = 5)
#> Error: lexical error: invalid char in json text.
#>                                        <!doctype html> <html lang="en"
#>                      (right here) ------^
head(trials)
#> Error: object 'trials' not found

# Return a dataframe with 5 trials on deception. 
trials <- find_trials(n_results = 5, cat = "offcat", term = "deception")
#> Error: lexical error: invalid char in json text.
#>                                        <!doctype html> <html lang="en"
#>                      (right here) ------^
head(trials)
#> Error: object 'trials' not found
```
