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
    httr::warn_for_status(r)
    return(httr::content(r, "parsed"))
}

#' @export
ldnotice <- function(notice, ...) {
    x <- lumenHTTP(path = paste0("/notices/", notice, ".json"), ...)
    structure(lapply(x, `class<-`, "lumen_notice")[[1]])
}

#' @export
summary.lumen_notice <- function(object, ...) {
    cat(x$type, " notice (", object$id, "): ", object$title, "\n", sep = "")
    cat("Date Received: ", object$date_received, "\n", sep = "")
    cat("Sender:        ", object$sender_name, "\n", sep = "")
    cat("Principal:     ", object$principal_name, "\n", sep = "")
    cat("Recipient:     ", object$recipient_name, "\n", sep = "")
    cat("# of Infringing URLs:  ", sum(sapply(object$works, function(a) length(a$infringing_urls))), "\n", sep = "")
    cat("# of Copyrighted URLs: ", sum(sapply(object$works, function(a) length(a$copyrighted_urls))), "\n", sep = "")
    invisible(object)
}

#' @export
ldtopics <- function(...) {
    x <- lumenHTTP(path = paste0("/topics.json"), ...)
    structure(lapply(x[[1]], `class<-`, "lumen_topic"))
}
#' @export
print.lumen_topic <- function(x, ...) {
    cat("Topic (", x$id, "): ", x$name, "\n", sep = "")
    invisible(x)
}


#' @export
ldsearch <- function(query = list(), page = 1, per_page = 10, verbose = TRUE, ...) {
    x <- lumenHTTP(path = paste0("/notices/search"), 
                   query = c(query, list(page = page, per_page = per_page)), ...)
    if (verbose) {
        message(sprintf("Page %s of %s Returned. Response contains %s of %s %s. ", 
                        x$meta$current_page, x$meta$total_pages, 
                        x$meta$per_page, x$meta$total_entries, 
                        ngettext(x$meta$total_entries, "notice", "notices")))
    }
    structure(list(entities = lapply(x$entities, `class<-`, "lumen_entity"), 
                   meta = x$meta), 
              class = "lumen_search")
}

#' @export
ldentities <- function(query = list(), page = 1, per_page = 10, verbose = TRUE, ...) {
    x <- lumenHTTP(path = paste0("/entities/search"), 
                   query = c(query, list(page = page, per_page = per_page)), ...)
    if (verbose) {
        message(sprintf("Page %s of %s Returned. Response contains %s of %s %s. ", 
                        x$meta$current_page, x$meta$total_pages, 
                        ifelse(x$meta$per_page < x$meta$total_entries, 
                               x$meta$per_page, 
                               x$meta$total_entries), 
                        x$meta$total_entries, 
                        ngettext(x$meta$total_entries, "entity", "entities")))
    }
    structure(list(entities = lapply(x$entities, `class<-`, "lumen_entity"), 
                   meta = x$meta), 
              class = "lumen_search")
}

#' @export
print.lumen_entity <- function(x, ...) {
    cat("Entity (", x$id, "): ", x$name, "\n", sep = "")
    invisible(x)
}
#' @export
print.lumen_search <- function(x, ...) {
    lapply(x[[1]], print)
    invisible(x)
}

# ldcreate <- function(query = list(), ...) {
#    lumenHTTP("POST", path = paste0("/entities/search"), query = query, ...)
# }
