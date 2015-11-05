#' @title Lumen Database HTTP Requests
#' @description This is the workhorse function for executing API requests for the Lumen Database.
#' @details This is mostly an internal function for executing API requests. In almost all cases, users do not need to access this directly.
#' @param verb A character string containing an HTTP verb, defaulting to \dQuote{GET}.
#' @param path A character string with the API endpoint (should begin with a slash).
#' @param query A list specifying any query string arguments to pass to the API.
#' @param body A character string of request body data.
#' @param base A character string specifying the base URL for the API.
#' @param token A character string containing a Lumen Database API token. If missing, defaults to value stored in environment variable \env{Lumen_TOKEN}.
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}.
#' @return A list.
#' @export
lumenHTTP <- function(verb = "GET",
                      path = "", 
                      query = list(),
                      body = "",
                      base = "https://lumendatabase.org",
                      token = Sys.getenv("LUMEN_TOKEN"),
                      ...) {
    url <- paste0(base, path)
    h <- httr::add_headers("Accept" = "application/json", 
                           "AUTHENTICATION_TOKEN" = token)
    if (!length(query)) query <- NULL
    if (verb == "GET") {
        r <- httr::GET(url, query = query, h, ...)
    } else if (verb == "POST") {
        if(body == "") {
          r <- httr::PUT(url, query = query, h, ...)
        } else {
          r <- httr::PUT(url, body = body, query = query, h, ...)
        }
    } 
    return(httr::content(r, "parsed"))
}

#' @export
ldnotices <- function(notice, ...) {
    lumenHTTP(path = paste0("/notices/", notice, ".json"), ...)
}

#' @export
ldtopics <- function(...) {
    lumenHTTP(path = paste0("/topics.json"), ...)
}

#' @export
ldsearch <- function(query = list(), ...) {
    lumenHTTP(path = paste0("/notices/search"), query = query, ...)
}

#' @export
ldentities <- function(query = list(), ...) {
    lumenHTTP(path = paste0("/entities/search"), query = query, ...)
}

# ldcreate <- function(query = list(), ...) {
#    lumenHTTP("POST", path = paste0("/entities/search"), query = query, ...)
# }
