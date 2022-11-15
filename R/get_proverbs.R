
#' proverb
#'
#' Prints out a daily proverb corresponding to the current day of the month.
#' For example, on the 27th of August, Proverbs 27 would be returned.
#'
#' @param translation A character string that is available from list returned by `translations()`
#' @param main_color A character string of a color available in the [crayon package](https://github.com/r-lib/crayon#readme). The color for the main body of text.
#' @param accent_color A character string of a color available in the [crayon package](https://github.com/r-lib/crayon#readme). The accent color for the passage.
#' @note Several open source translations are available. By default, the World English Bible version is returned.
#' To see which translations are available, use the `translations()` function.
#' @export
#'
#' @return nothing
#'
#' @examples
#' \dontrun{
#' # Return the default translation, which is "web", or World English Bible
#' proverb()
#'
#' # Return the King James version verse of the day
#' proverb(translation="kjv")
#'
#' # Custom colors
#' proverb(main_color="red", accent_color="silver")
#'
#' }
proverb <- function(translation = "web", main_color = "cyan", accent_color = "silver") {


  good_colors <- c(
    'black',
    'red',
    'green',
    'yellow',
    'blue',
    'magenta',
    'cyan',
    'white',
    'silver'
  )

  if(!main_color %in% good_colors | !accent_color %in% good_colors) {

    stop(cat(
      crayon::red("One of those colors is not available!\n"),
      cli::symbol$warning,
      crayon::green("Check the {crayon} website to see a list of supported colors: https://github.com/r-lib/crayon \n")
      )
    )

  }

  main_color <- getExportedValue('crayon', main_color)
  accent_color <- getExportedValue('crayon', accent_color)



  versions <- c(
    "bbe",
    "kjv",
    "web",
    "webbe",
    "almeida",
    "rccv"
  )

  if(!translation %in% versions) {
    stop(cat(
      crayon::red("That translation is not available!\n"),
      cli::symbol$warning,
      crayon::green("Use the"),
      crayon::italic("translations()"),
      crayon::green("function to see a list of available translations. \n")
      )
    )
  }

  BASE_URL <- 'https://bible-api.com/proverbs%20'

  TODAY <- Sys.Date() %>%
    as.character() %>%
    substr(start = 9, stop = 11)

  URL <- paste0(BASE_URL, TODAY, "?translation=", translation)

  r <- httr::GET(
      url = URL
  )

  verses <- httr::content(r)$verses %>%
    purrr::map(purrr::pluck, "text") %>%
    purrr::as_vector()


  if(translation %in% c("kjv", "bbe")) {

    verses <- gsub("\n", " ", verses)

  }

  if(translation %in% c("kjv", "bbe", "almeida", "rccv")) {
    verses <- purrr::map(verses, ~paste0(., "\n"))

  }




  n_verses <- length(verses)
  foo <- seq(1, n_verses, 1)
  output <- paste(accent_color(foo), main_color(verses), collapse = " ")

  a <- lubridate::wday(Sys.Date(), label = T, abbr = F) %>% as.character()
  b <- lubridate::month(Sys.Date(), label = T, abbr = F) %>% as.character()
  c <- lubridate::day(Sys.Date())
  d <- lubridate::year(Sys.Date())

  header <- paste0("\n\nProverbs ", c, "\nFor ",  a, ", ",b, " ", c, " ", d)
  cat(crayon::bold(accent_color(header)))
  cat("\n \n")
  cat(crayon::col_align(output, align = "center", width = 20))
  cat("\n")
  cat(accent_color(paste0(main_color(cli::symbol$tick), " Translation: ", translation)))



}


#' translations
#'
#' Lists available Bible Versions for `proverb()`
#'
#' @export
#'
#' @return nothing
#'
#' @examples
#' \dontrun{
#' translations()
#' }
translations <- function() {

  translations <- c(
      "bbe: Bible in Basic English",
      "kjv: King James Version",
      "web: World English Bible (default)",
      "webbe: World English Bible, British Edition",
      "almeida: Joao Ferreira de Almeida (portuguese)",
      "rccv: Romanian Corrected Cornilescu Version"
  )

  cli::cli_h1("Bible Translations Available")
  cli::cli_li(translations)
  cli::cli_h3("Pass the Bible translation you choose above to proverb(), like:")
  cli::cli_code("proverb('kjv')")
  cli::cli_code("proverb('bbe')")

}
