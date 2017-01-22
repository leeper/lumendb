# Lumen Database API Client

**lumendb** is a simple client package for the [Lumen Database](http://lumendatabase.org/) (formerly Chilling Effects) [API](https://github.com/berkmancenter/lumendatabase/blob/master/doc/api_documentation.mkd). It can retrieve, as well as deposit, copyright takedown notices from the Lumen database. It may be useful for tracking who is sending copyright-related cease and desist orders and what material is being used in apparent violation of copyright.

All Lumen Database data [is released under to Public Domain (CC0)](https://www.lumendatabase.org/pages/license), though the API has additional [terms of use](https://lumendatabase.org/pages/api_terms).

Use of the package does not require an API token, though Lumen rate limits non-authenticated requests. To request a token, contact Lumen directly at: team (at) lumendatabase.org. The token should then be stored as an environment variable:

```R
Sys.setenv(LUMEN_TOKEN = "t1o2k3e4n5v6a7l8u9e")
```

Or this can be passed atomically to every API call. Setting the environment variable is simpler and more secure because it will not be recorded in R history logs.

## Code Examples


The key functionality of the package is to retrieve notices by their identification numbers and to search for notices. To retrieve a single notice, just query it:


```r
library("lumendb")
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
## Page 1 of 16355 Returned. Response contains 10 of 163547 notices.
```

```r
print(x)
```

```
## [[1]]
## DMCA notice (13532500): DMCA (Copyright) Complaint to Google
## Date Received: 2016-12-13T00:00:00Z
## Sender:        MarkScan
## Principal:     Eenadu Television Pvt. Ltd.
## Recipient:     Google Inc
## # of Infringing URLs:  2278
## # of Copyrighted URLs: 10
## 
## [[2]]
## DMCA notice (1335541): DMCA (Copyright) Complaint to Google
## Date Received: 2014-08-06T04:00:00Z
## Sender:        DMCA Takedown Czar
## Principal:     Alun Hill
## Recipient:     Google, Inc.              
## # of Infringing URLs:  373
## # of Copyrighted URLs: 3
## 
## [[3]]
## Other notice (12544590): Other notice to YouTube, LLC
## Date Received: 2016-06-28T00:00:00Z
## Sender:        YouTube, LLC
## Principal:     
## Recipient:     YouTube, LLC
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[4]]
## Other notice (1307149): Legal Complaint to YouTube
## Date Received: 2014-03-12T04:00:00Z
## Sender:        REDACTED
## Principal:     REDACTED
## Recipient:     Google, Inc.
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[5]]
## Other notice (12311524): Takedown Request - Legal Complaint to YouTube
## Date Received: 2015-02-16T00:00:00Z
## Sender:        
## Principal:     Elle Royal
## Recipient:     YouTube, LLC
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
## 
## [[6]]
## DMCA notice (11326213): DMCA (Copyright) Complaint to Google
## Date Received: 2015-10-17T00:00:00Z
## Sender:        Kacper_Moskala
## Principal:     Jose Daniel Canchila
## Recipient:     Google Inc.
## # of Infringing URLs:  410
## # of Copyrighted URLs: 2
## 
## [[7]]
## DMCA notice (13465705): DMCA (Copyright) Complaint to Google
## Date Received: 2016-12-01T00:00:00Z
## Sender:        MarkScan
## Principal:     Eenadu Television Pvt. Ltd.
## Recipient:     Google Inc
## # of Infringing URLs:  201
## # of Copyrighted URLs: 9
## 
## [[8]]
## DMCA notice (12163330): DMCA (Copyright) Complaint to Google
## Date Received: 2016-04-29T00:00:00Z
## Sender:        Tikyda_Couassi-Ble
## Principal:     Amazing Academy LLC
## Recipient:     Google Inc.
## # of Infringing URLs:  53
## # of Copyrighted URLs: 1
## 
## [[9]]
## DMCA notice (1985556): DMCA (Copyright) Complaint to Google
## Date Received: 
## Sender:        aH0tUnicorn
## Principal:     Chandler Hutchins
## Recipient:     Google, Inc. [Groups
## # of Infringing URLs:  6
## # of Copyrighted URLs: 1
## 
## [[10]]
## DMCA notice (13482427): DMCA (Copyright) Complaint to Google
## Date Received: 2016-12-04T00:00:00Z
## Sender:        MarkScan
## Principal:     Eenadu Television Pvt. Ltd.
## Recipient:     Google Inc
## # of Infringing URLs:  420
## # of Copyrighted URLs: 8
```

Another example would be to retrieve 100 requests from a major takedown requester, The Publishers Association, which represents a large number of publishing companies:


```r
# query 50 notices
x <- ldsearch(list(sender_name = "The Publishers Association"), per_page = 50)
```

```
## Page 1 of 1339 Returned. Response contains 50 of 66917 notices.
```

```r
# view first two notices
summary(x[[1]])
```

```
## DMCA notice (11348901): DMCA (Copyright) Complaint to Google
## Date Received: 2015-10-23T00:00:00Z
## Sender:        The Publishers Association
## Principal:     
## Recipient:     Google Inc.
## # of Infringing URLs:  344
## # of Copyrighted URLs: 4
```

```r
summary(x[[2]])
```

```
## DMCA notice (10814172): DMCA (Copyright) Complaint to Google
## Date Received: 2015-05-29T00:00:00Z
## Sender:        The Publishers Association
## Principal:     
## Recipient:     Google, Inc.
## # of Infringing URLs:  0
## # of Copyrighted URLs: 0
```

The `ldsearch()` function is, like the API it wraps, paginated and pagination details are printed by to the console by default and are available in `meta` attribute in the search result list.

Note: the notice submission API is not yet implemented in this package.

## Installation

[![CRAN](https://www.r-pkg.org/badges/version/lumendb)](https://cran.r-project.org/package=lumendb)
![Downloads](https://cranlogs.r-pkg.org/badges/lumendb)
[![Build Status](https://travis-ci.org/leeper/lumendb.png?branch=master)](https://travis-ci.org/leeper/lumendb) 
[![codecov.io](https://codecov.io/github/leeper/lumendb/coverage.svg?branch=master)](https://codecov.io/github/leeper/lumendb?branch=master)

This package is not yet on CRAN. To install the latest development version from GitHub, run the following:

```R
if (!require("ghit")) {
    install.packages("ghit")
}
ghit::install_github("leeper/lumendb")
```

