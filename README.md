# oldbailey: Accessing Old Bailey API Data

oldbailey fetches historical trial data from the Old Bailey API (April 13, 1674 - April 1, 1913). It [parses and resolves](#parsing-old-bailey-xml) ambiguous and inconsistent XML while adding valuable metadata, such as the name of the first-person speaker. It returns an analysis-ready data frame with fields for: 

- Trail Account ID: The unique ID assigned to a trial.
- Defendant Name: The name of the defendant(s).
- Defendant Gender: The recorded gender(s) of the defendant(s).
- Victim Name: The name(s) of the victim(s).
- Victim Gender: The recorded gender(s) of the victim(s).
- Crime Location: The location(s) where the crime took place.
- Offence Category: The Old Bailey uses eight high-level categories of crime: "breaking peace," "damage," "deception," "kill," "miscellaneous," "royal offences," "sexual," "theft," and "violent theft." 
- Offence Subcategory: For narrowing the high-level category. The Old Bailey uses [fifty-six subcategories](#crime-subcategories) of crime. 
- Punishment Category: The Old Bailey uses five categories of punishment: "corporal," "death," "imprison," "misc. punishment," "no punishment," and "transport." 
- Punishment Subcategory: For narrowing the punishment category. The Old Bailey uses [twenty-six subcategories](#punishment-subcategories) of punihsment. 
- Verdict: Guilt or not guilty.
- Speech ID: A unique ID given to each speech, where a speech is considered a continuous recording until reaching a new speaker. The Speech ID starts at 0 for every trial.
- Speaker Name: The first-person speaker of the written trial record. 
- Body Text: The written trial record.
- Date: The year, month, and day of the trial. 
- XML Address: The address to the original XML file hosted by Old Bailey online. 

Note: Not all trials mention the proper names of defendants or victims, or contain first-person speakers. 

Optional parameters allow users to specify the number of results, the dates of the trials, and whether they contain key terms.

## Install

Install from CRAN: (forthcoming)

```
install.packages("oldbailey")
```

Install from the [rOpenGov universe](https://ropengov.r-universe.dev/ui#builds):
```
# Enable repository from ropengov
options(repos = c(
  ropengov = 'https://ropengov.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))
  
# Download and install oldbailey
install.packages("oldbailey")
```

## Return Old Bailey Trials in Two Steps

1. Use `find_trials()` to return a list of XML addresses for the trials coresponding to the search parameters. By default, `find_trials()` will return the addresses for all 197,752 trials. 

```
xml_addresses <- find_trials() 
```

2. Pass the XML addresses to `parse_trials()` to return an analysis-ready data frame with the Old Bailey trial data. 

```
trials_df <- parse_trials(xml_addresses)
```

### Examples

Users can choose the number of trials to return. 

```
find_trials(n_results = 200)
```

Users can also search for trials that contain key terms. This requires the user to supply: a) the term's category; and b) the term itself. 

```
find_trials(cat = "offcat", term = "deception")
```

Several categories and terms can be provided. 

```
find_trials(n_results = 200, cat = c("offcat", "offcat"), term = c("deception", "theft"))
```

Users can combine both steps in a single line of code.

```
parse_trials(find_trials(n_results = 15, cat = "offcat", term = "deception"))
```

Old Bailey only recognizes specific terms in relation to a category. Use `old_bailey_api_terms()` to see every possible term and its category name.

If you know the category name, you can supply it to `old_bailey_api_terms()` and see every term that belongs to it. Below is a list of all the categories recongized by Old Bailey: 

- `defgen` - Defence Gender
- `offcat` - Offence Category
- `offsubcat` - Offencive Subcategory
- `vicgen` - Victim Gender
- `vercat` - Verdict Category 
- `versubcat` - Subcategory of Verdict
- `puncat` - Punishment Category
- `punsubcat` - Punishment Subcategory 
- `date` - The dates on which trials were held, in YYYYMMDD format. 

The following code returns all the terms pertaining to "defgen" (for defendant gender) and "offcat" (for offence category).

```
old_bailey_api_terms(cat = c("defgen", "offcat"))
```

```
# A tibble: 12 × 3
   name   type   terms        
   <chr>  <chr>  <chr>        
 1 defgen select female       
 2 defgen select indeterminate
 3 defgen select male         
 4 offcat select breakingPeace
 5 offcat select damage       
 6 offcat select deception    
 7 offcat select kill         
 8 offcat select miscellaneous
 9 offcat select royalOffences
10 offcat select sexual       
11 offcat select theft        
12 offcat select violentTheft 
```

### Usage

**find_trials()**

| Argument | Description | 
| ------------- | ------------- |
| `n_results` | Any positive number. To return all results, keep this empty or pass "all." (optional). |
| `cat` | Find trials pertaining to a category. (optional). |
| `term` | Find trials pertaining to a term. (optional). |

Note: "cat" and "term" must be specified together. (In otherwords, a category cannot be specified without a term, and vice-versa.)

**parse_trials()**

| Argument | Description | 
| ------------- | ------------- |
| `xml_address` | One or more XML addresses. |

**old_bailey_api_terms()**

| Argument | Description | 
| ------------- | ------------- |
| `cat` | Specify results for one or more categories. (optional). |

## Parsing Old Bailey XML

The XML parser handles issues with the XML tags while adding valuable metadata to the records. Many XML tags are ambiguous or inconsistent, and tagging conventions change for different periods. XML tags often miss person names, and they don't make a distinction between the names of people speaking and the names of people mentioned by others.

## Crime Subcategories
- Animal Theft
- Arson
- Assault
- Assault with Intent
- Assault with Sodomitical Intent
- Bankrupcy
- Barratry
- Bigamy
- Burglary
- Coining Offences
- Concealing a Birth
- Conspiracy
- Embezzlement
- Extortion
- Forgery
- Fraud
- Game Law Offence
- Grand Larceny
- Habitual Criminal
- Highway Robbery
- House Breaking
- Illegal Abortion
- Indecent Assault
- Infanticide
- Keeping a Brothel
- Kidnapping
- Libel
- Mail
- Manslaughter
- Murder
- Other
- Perjury
- Perverting Justice
- Petty Larceny
- Petty Treason
- Piracy
- Pocketpicking
- Rape
- Receiving
- Religious Offences
- Return from Transportation
- Riot
- Robbery
- Seditious Libel
- Seditious Words
- Seducing Allegiance
- Shop Lifting
- Simple Larceny 
- Sodomy
- Stealing from Master
- Tax Offences
- Theft from Place
- Threatening Behaviour
- Treason
- Vagabond
- Wounding

## Punishment Subcategories

- Branding
- Branding on Cheek
- Burning
- Death and Dissection
- Drawn and Quartered
- Executed
- Fine
- Forfeiture
- Hanging in Chains
- Hard Labour
- House of Correction
- Insanity 
- Military Naval Duties
- Newgate
- Other Institution
- Pardon
- Penal Servitude
- Pillory
- Preventive Detention
- Private Whipping
- Public Whipping
- Respited
- Respited for Pregnancy
- Sentence Respited
- Sureties
- Whipping

### Citation

Please cite the package as follows: 

Buongiorno S (2023). oldbailey: For Accessing The Old Bailey Open Data. https://github.com/stephbuon/usdoj, https://ropengov.github.io/usdoj/, https://github.com/rOpenGov/usdoj.

BibTeX: 

```
@Manual{,
  title = {oldbailey: For Accessing The Old Bailey Open Data.},
  author = {Steph Buongiorno},
  year = {2023},
  note = {https://github.com/stephbuon/oldbailey,
https://ropengov.github.io/oldbailey/, https://github.com/rOpenGov/oldbailey},
}
```

**Disclaimer**

This package is not officially related to or endorsed by Old Bailey Online or the Government of the United Kingdom. 
