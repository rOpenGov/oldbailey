# Parse Old Bailey Trials

For parsing Old Bailey trial data.

## Usage

``` r
parse_trials(
  xml_address
  )
```

## Arguments

- xml_address:

  One or more XML addresses. A single XML address can be passed as a
  string, or numerous XML addresses can be passed as a list.

## Value

Dataframe containing API pull of parsed Old Bailey Trials.

## Examples

``` r
# Return a dataframe with parsed trial data.
xml_address <- "https://www.oldbaileyonline.org/obapi/text?div=t17690112-9"
parsed_trial <- parse_trials(xml_address)
#> Warning: cannot open URL 'https://www.oldbaileyonline.org/obapi/text?div=t17690112-9': HTTP status was '403 Forbidden'
#> Error in file(con, "r"): cannot open the connection to 'https://www.oldbaileyonline.org/obapi/text?div=t17690112-9'
head(parsed_trial)
#> Error: object 'parsed_trial' not found
```
