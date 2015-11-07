context("Get notice")

test_that("Retrieve A Notice", {
    (n <- ldnotice(1))
    expect_equal(class(n), "lumen_notice")
})

test_that("Print Notice Summary", {
    n <- ldnotice(1)
    summary(n)
})

test_that("Retrieve Entities", {
    (e <- ldentities(list(term = "joe")))
    expect_equal(class(e), "lumen_search")
    expect_equal(class(e$entities[[1]]), "lumen_entity")
})

test_that("Retrieve Topics", {
    e <- ldtopics()
    expect_equal(class(e[[1]]), "lumen_topic")
})

test_that("Search Works", {
    (s <- ldsearch(list(term = "youtube")))
})
