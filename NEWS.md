

# proverbs 0.4.0
* Upgraded to {httr2} for all API work
* Added more verbose error trapping
* Switched from %>% to native pipe |>
* Used {checkmate} to validate inputs


Added support for ESV version

# proverbs 0.2.0



Added two new arguments to `proverbs::proverb()`

* main_color
* accent_color

These allow you to specify the actual colors printed to the terminal. They use the colors from the [crayon package](https://github.com/r-lib/crayon#readme).
