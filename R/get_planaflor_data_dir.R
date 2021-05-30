#' @title Check/get the data folder for the PlanaFlor project
#' @return a path to the data folder of the PlanaFlor project

#' @details The \code{get_planaflor_data_dir()} function check the
#'   existence of the enviromental variable PLANAFLOR on the global
#'   \code{.Renviron} file, and offer instructions on how to set that
#'   variable. The main objective of this function is to offer a
#'   concise way to get to planaflor data irrespective the computer
#'   which the data will be accessed.

#' @examples
#' \dontrun{
#' if (interactive()) {
#'   get_planaflor_data_dir()
#'   # If you get an error, don't worry.
#'   # Follow the instructions provided by the error message
#'   # and rerun get_planaflor_data_dir.
#' }
#' }
#'
#' @seealso
#'  \code{\link[glue]{glue}}
#'  \code{\link[usethis]{ui}}
#'  \code{\link[here]{here}}
#' @rdname get_planaflor_data_dir
#' @export
#' @importFrom glue glue
#' @importFrom usethis ui_stop
#' @importFrom here here
get_planaflor_data_dir <- function() {
  data_env <- Sys.getenv("PLANAFLORDATA")

  is_windows <- function() {
    .Platform$OS.type == "windows"
  }

  is_macos <- function() {
    unname(Sys.info()["sysname"] == "Darwin")
  }

  is_linux <- function() {
    unname(Sys.info()["sysname"] == "Linux")
  }

  if (data_env == "") {
    if (is_windows()) {
      home <- Sys.getenv("USERPROFILE")
      data_home <- Sys.getenv("APPDATA")
      message_set <-
        glue::glue("PLANAFLORDATA=\"{home}/google-drive/fbds1992/projeto-planaflor-norad\"\nRENV_PATHS_LIBRARY_ROOT=\"{data_home}/renv/library\"")
    }
    else if (is_macos()) {
      home <- Sys.getenv("HOME")
      message_set <-
        glue::glue("PLANAFLORDATA=\"{home}/google-drive/fbds1992/projeto-planaflor-norad\"\nRENV_PATHS_LIBRARY_ROOT=\"~/Library/Application Support/renv/library\"")
    } else {
      home <- Sys.getenv("HOME")
      data_home <- Sys.getenv("XDG_DATA_HOME")
      message_set <-
        glue::glue("PLANAFLORDATA=\"{home}/google-drive/fbds1992/projeto-planaflor-norad\"\nRENV_PATHS_LIBRARY_ROOT=\"{data_home}/renv/library\"")
    }

    usethis::ui_stop(
      "PLANAFLORDATA enviromental variable is empty!
    Please, use {usethis::ui_code('usethis::edit_r_environ()')} and paste to following code into it:
    {usethis::ui_field(message_set)}
    After this, you can run {usethis::ui_code('get_planaflor_data_dir()')} again to accessing our project data."
    )
  }

  data_dir <- here::here(data_env)

  return(data_dir)
}
