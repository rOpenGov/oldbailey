# View Old Bailey API Terms

For viewing terms and their categories.

## Usage

``` r
old_bailey_api_terms(
  cat = NULL
  )
```

## Arguments

- cat:

  Return terms corresponding to a category of crime. By default, all
  terms and categories are returned.

## Value

Dataframe containing API pull of terms and their categories.

## Examples

``` r
# Return a dataframe with the terms corresponding to defendant gender or offensive category.
terms <- old_bailey_api_terms(cat = c("defgen", "offcat"))
#> Error: lexical error: invalid char in json text.
#>                                        <!doctype html> <html lang="en"
#>                      (right here) ------^
head(terms)
#>                     
#> 1 function (x, ...) 
#> 2 UseMethod("terms")
```
