library(withr)
library(here)

test_that("get_planaflor_data_dir correctly verify the PLANAFLORDATA environmental variable", {
  with_envvar(
    new = c("PLANAFLORDATA" = here("data_folder")),
    code = {
      data_dir <- get_planaflor_data_dir()
      expect_equal(Sys.getenv("PLANAFLORDATA"), data_dir)
    }
  )
})


test_that("get_planaflor data_dir throw an error when PLANAFLORDATA environmental variable is empty", {
  with_envvar(
    new = c("PLANAFLORDATA" = ""),
    code = {
      expect_error(get_planaflor_data_dir())
    }
  )
})
