library("testthat")
library("lumendb")

if (Sys.getenv("LUMEN_TOKEN") != "") {
    test_check("lumendb")
}
