
check_esv_error <- function(x) {

  msg <- httr2::last_response() |>
    httr2::resp_body_html() |>
    rvest::html_element("title") |>
    rvest::html_text()

  print(paste0("ESV API returned: ", msg))
  print("Check out https://api.esv.org/ for more info.")

}

ping_api <- function(translation = "web") {


  TODAY <- Sys.Date() |>
    as.character() |>
    substr(start = 9, stop = 11)


  BASE_URL <- 'https://bible-api.com'

  req <- httr2::request(BASE_URL) |>
    httr2::req_retry(max_tries = 5, backoff = ~ 10)

  resp <- req |>

    # add today
    httr2::req_url_path_append(glue::glue("proverb%20{ TODAY }")) |>

    # add translation
    httr2::req_url_query(`translation` = translation) |>

    httr2::req_perform()


  httr2::resp_body_json(resp) |>
    purrr::pluck("verses") |>
    purrr::map(
      purrr::pluck("text")
    )


}

ping_esv <- function() {

  TODAY <- Sys.Date() |>
    as.character() |>
    substr(start = 9, stop = 11)


  API_URL = 'https://api.esv.org/v3/passage/text/'


  API_KEY <- Sys.getenv('ESV_API_KEY')
  if (identical(API_KEY, "")) {
    stop("Please set environmental variable `ESV_API_KEY` to your esv api key. Learn more at: https://bradlindblad.github.io/proverbs/articles/esv_api_key",
         call. = FALSE)
  }



  BASE_URL <- 'https://api.esv.org/v3/passage/text/'

  req <- httr2::request(BASE_URL) |>
    httr2::req_retry(max_tries = 5, backoff = ~ 10)

  resp <- req |>
    # add today
    # httr2::req_url_path_append() |>
    httr2::req_url_query(
      q = glue::glue("Proverbs { TODAY }"),
      `include-headings` = FALSE,
      `include-footnotes` = FALSE,
      `include-verse-numbers` = TRUE,
      `include-short-copyright` = FALSE,
      `include-passage-references` = FALSE
    ) |>
    httr2::req_headers(`Authorization` = paste0("Token ", API_KEY)) |>
    httr2::req_error(body = check_esv_error) |>
    httr2::req_perform()

  httr2::resp_body_json(resp) |>
    purrr::pluck("passages")





}

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



# Check input types -------------------------------------------------------

checkmate::assert_character(translation)
  checkmate::assert_character(main_color)
  checkmate::assert_character(accent_color)


# Check versions ----------------------------------------------------------



  versions <- c(
    "bbe",
    "kjv",
    "web",
    "webbe",
    "almeida",
    "rccv",
    "esv"
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


# Colors check ------------------------------------------------------------

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
    ))

  }

  main_color <- getExportedValue('crayon', main_color)
  accent_color <- getExportedValue('crayon', accent_color)




# Run main - ping API -----------------------------------------------------


  if (translation == "esv") {
    tryCatch(
      expr = {
        f <- ping_esv()



        f <- as.character(f)

        f <- stringr::str_split(f, "\\\n", simplify = T)

        g <- f[1,]


        # color diff parts
        beginning <- purrr::map(g, stringr::str_sub, 1, 8)
        beginning[1] <- paste0(" ", beginning[1])
        body <- purrr::map(g, stringr::str_sub, 9, 99)
        full_body <- paste(body, "\n")



        output <- paste(accent_color(beginning), main_color(full_body))
        a <- lubridate::wday(Sys.Date(), label = T, abbr = F) |>  as.character()
        b <- lubridate::month(Sys.Date(), label = T, abbr = F) |>  as.character()
        c <- lubridate::day(Sys.Date())
        d <- lubridate::year(Sys.Date())

        header <- paste0("\n\nProverbs ", c, "\nFor ",  a, ", ",b, " ", c, " ", d)
        cat(crayon::bold(accent_color(header)))
        cat("\n \n")

        cat(output)

        cat(accent_color(paste0(main_color(cli::symbol$tick), " Translation: ", "esv")))


      },
      error = function(e) {
        message("The API did not return a response. It may be down momentarily.
          Try again in a few minutes!")
        # print(e)
        stop()
      }
    )
  } else {
    tryCatch(
      expr = {
        verses <- ping_api(translation = translation)



        if(translation %in% c("kjv", "bbe")) {

          verses <- gsub("\n", " ", verses)

        }



        if(translation %in% c("kjv", "bbe", "almeida", "rccv")) {
          verses <- purrr::map(verses, ~paste0(., "\n"))

        }




        n_verses <- length(verses)
        foo <- seq(1, n_verses, 1)
        output <- paste(accent_color(foo), main_color(verses), collapse = " ")

        a <- lubridate::wday(Sys.Date(), label = T, abbr = F) |>  as.character()
        b <- lubridate::month(Sys.Date(), label = T, abbr = F) |>  as.character()
        c <- lubridate::day(Sys.Date())
        d <- lubridate::year(Sys.Date())

        header <- paste0("\n\nProverbs ", c, "\nFor ",  a, ", ",b, " ", c, " ", d)
        cat(crayon::bold(accent_color(header)))
        cat("\n \n")
        cat(crayon::col_align(output, align = "center", width = 20))
        cat("\n")
        cat(accent_color(paste0(main_color(cli::symbol$tick), " Translation: ", translation)))
      },
      error = function(e) {
        message("The API did not return a response. It may be down momentarily.
          Try again in a few minutes!")
        # print(e)
        stop()
      }
    )
  }

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
      "esv: English Standard Version -requires API key",
      "kjv: King James Version",
      "bbe: Bible in Basic English",
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
