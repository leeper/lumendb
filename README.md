# Lumen Database API Client #

**lumendb** is a simple client package for the [Lumen Database](http://lumendatabase.org/) (formerly Chilling Effects) [API](https://github.com/berkmancenter/lumendatabase/blob/master/doc/api_documentation.mkd). It can retrieve, as well as deposit, copyright takedown notices from the Lumen database. It may be useful for tracking who is sending copyright-related cease and desist orders and what material is being used in apparent violation of copyright.

All Lumen Database data [is released under to Public Domain (CC0)](https://www.lumendatabase.org/pages/license), though the API has additional [terms of use](https://lumendatabase.org/pages/api_terms).

## Installation ##

[![CRAN](http://www.r-pkg.org/badges/version/lumendb)](http://cran.r-project.org/package=lumendb)
[![Build Status](https://travis-ci.org/leeper/lumendb.png?branch=master)](https://travis-ci.org/leeper/lumendb) 
[![codecov.io](http://codecov.io/github/leeper/lumendb/coverage.svg?branch=master)](http://codecov.io/github/leeper/lumendb?branch=master)

This package is not yet on CRAN. To install the latest development version from GitHub, run the following:


```r
if(!require("devtools")){
    install.packages("devtools")
    library("devtools")
}
install_github("leeper/lumendb")
```

```
## Downloading GitHub repo leeper/lumendb@master
## Installing lumendb
## "C:/PROGRA~1/R/R-32~1.2/bin/x64/R" --no-site-file --no-environ --no-save  \
##   --no-restore CMD INSTALL  \
##   "C:/Users/Thomas/AppData/Local/Temp/RtmpovfUKM/devtools1b0855b055a7/leeper-lumendb-80f9b4a"  \
##   --library="C:/Program Files/R/R-3.2.2/library" --install-tests 
## 
## Reloading installed lumendb
## 
## Attaching package: 'lumendb'
## 
## The following objects are masked _by_ '.GlobalEnv':
## 
##     ldentities, ldnotice, ldsearch, ldtopics, lumenHTTP
```

```r
library("lumendb")
```

Use of the package does not require an API token, though Lumen rate limits non-authenticated requests. To request a token, contact Lumen directly at: team (at) lumendatabase.org. The token should then be stored as an environment variable:

Sys.setenv(LUMEN_TOKEN = "t1o2k3e4n5v6a7l8u9e")

Or this can be passed atomically to every API call. Setting the environment variable is simpler and more secure because it will not be recorded in R history logs.

## Code Examples ##


The key functionality of the package is to retrieve notices by their identification numbers and to search for notices. To retrieve the first notice ever sent to Chilling Effects, just query it:


```r
x <- ldnotice(1)
summary(x)
```

```
## DMCA notice (1): Web DMCA (Copyright) Complaint to Google
## Date Received: 2012-01-14T05:00:00Z
## Sender:        Faegre Baker Daniels LLP
## Principal:     Pacific Bioscience Laboratories
## Recipient:     Google, Inc.
## # of Infringing URLs:  19
## # of Copyrighted URLs: 11
```

The `summary()` method will print some essential details for each notice, as seen above.

The other major function is to search for notices by keyword. The search functionality is pretty complicated, so I have not written R-specific documentation for it. The search API is based on elastic search and [Lumen's documentation is available on GitHub](https://github.com/berkmancenter/lumendatabase/blob/dev/doc/api_documentation.mkd#search-notices-via-fulltext) for those who are interested. As a simple example, one can perform a full-text search for notices related to YouTube:


```r
x <- ldsearch(list(term = "youtube"))
```

```
## Page 1 of 7355 Returned. Response contains 10 of 73542 notices.
```

```r
print(x)
```

```
## [[1]]
## Other notice (760645): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[2]]
## Other notice (775346): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[3]]
## Other notice (786766): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[4]]
## Other notice (787238): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[5]]
## Other notice (786456): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[6]]
## Other notice (787447): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[7]]
## Other notice (771661): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[8]]
## Other notice (771755): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[9]]
## Other notice (771762): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[10]]
## Other notice (772044): Other notice to Youtube (Google, Inc.)
## Date Received: 
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Youtube (Google, Inc.)
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
```

Another example would be to retrieve 100 requests from a major takedown requester, The Publishers Association, which represents a large number of publishing companies:


```r
# query 50 notices
x <- ldsearch(list(sender_name = "The Publishers Association"), per_page = 50)
```

```
## Page 1 of 1285 Returned. Response contains 50 of 64247 notices.
```

```r
# view first two notices
summary(x[[1]])
```

```
## DMCA notice (10949388): DMCA (Copyright) Complaint to Google
## Date Received: 2015-07-09T00:00:00Z
## Sender:        The Publishers Association
## Principal:     
## Recipient:     Google
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
```

```r
summary(x[[2]])
```

```
## DMCA notice (11001538): DMCA (Copyright) Complaint to Google
## Date Received: 2015-07-24T00:00:00Z
## Sender:        The Publishers Association
## Principal:     
## Recipient:     Google
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
```

The `ldsearch()` function is, like the API it wraps, paginated and pagination details are printed by to the console by default and are available in `meta` attribute in the search result list.

Note: the notice submission API is not yet implemented in this package.

