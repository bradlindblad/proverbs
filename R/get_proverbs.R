
#' proverb
#'
#' @return
#' @export
#'
#' @examples
proverb <- function() {

  BASE_URL <- 'https://bible-api.com/proverbs%20'

  TODAY <- Sys.Date() %>%
    as.character() %>%
    substr(start = 9, stop = 11)

  URL <- paste0(BASE_URL, TODAY)

  r <- httr::GET(
      url = URL
  )

  verses <- httr::content(r)$verses %>%
    purrr::map(purrr::pluck, "text") %>%
    purrr::as_vector()

  n_verses <- length(verses)
  foo <- seq(1, n_verses, 1)
  output <- paste(crayon::silver(foo), crayon::cyan(verses), collapse = " ")

  a <- lubridate::wday(Sys.Date(), label = T, abbr = F) %>% as.character()
  b <- lubridate::month(Sys.Date(), label = T, abbr = F) %>% as.character()
  c <- lubridate::day(Sys.Date())
  d <- lubridate::year(Sys.Date())

  header <- paste0("\n\nProverbs ", c, "\nFor ",  a, ", ",b, " ", c, " ", d)
  cat(crayon::bold(crayon::silver(header)))
  cat("\n \n")
  cat(crayon::col_align(output, align = "center", width = 20))

  # TODO add param for translation

}
