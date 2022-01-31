
<!-- README.md is generated from README.Rmd. Please edit that file -->

# proverbs <img src="https://github.com/bradlindblad/proverbs/blob/master/man/figures/logo.png?raw=true" align="right" alt="" width="120" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/bradlindblad/proverbs/workflows/R-CMD-check/badge.svg)](https://github.com/bradlindblad/proverbs/actions)
[![Codecov test
coverage](https://codecov.io/gh/bradlindblad/proverbs/branch/master/graph/badge.svg)](https://app.codecov.io/gh/bradlindblad/proverbs?branch=master)
[![pkgdown](https://github.com/bradlindblad/proverbs/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/bradlindblad/proverbs/actions/workflows/pkgdown.yaml)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

A simple package to grab a Bible proverb corresponding to the day of the
month.

## Installation

Install the released version of proverbs from CRAN:

``` r
install.packages("proverbs")
```

You can install the development version of proverbs like so:

``` r
# install.packages("devtools")
devtools::install_github("bradlindblad/proverbs")
```

## Usage

The proverbs package was built to do one thing: print out a daily
proverb to your R console. There are 31 proverbs, and up to 31 days in
each month.

Many people like to read a proverb for each day of the month, so they
end up reading proverbs once a month, twelve times a year.

This package prints the chapter of proverbs that corresponds to that day
of the month; ie. on the 21st of June proverbs will print Proverbs 21.

### proverb()

This is the main function:

``` r
proverbs::proverb()
```

``` text
Proverbs 30
For Sunday, January 30 2022
 
1 The words of Agur the son of Jakeh; the revelation:
the man says to Ithiel,
to Ithiel and Ucal:
2 “Surely I am the most ignorant man,
and don’t have a man’s understanding.
3 I have not learned wisdom,
neither do I have the knowledge of the Holy One.
...
```

### translations()

You can also change the Bible translation to one of many open
source/public versions. Check these out with this function:

``` r
proverbs::translations()
```

``` text
── Bible Translations Available ────────────
• bbe: Bible in Basic English
• kjv: King James Version
• web: World English Bible (default)
• webbe: World English Bible, British Edition
• almeida: João Ferreira de Almeida (portuguese)
• rccv: Romanian Corrected Cornilescu Version

── Pass the Bible translation you choose above to proverb(), like: 
proverb(translation = 'kjv')
proverb(translation = 'bbe')
```

You can pass those translation codes to `proverbs::proverb()`

``` r
proverbs::proverb(translation = "kjv")
```

## Credit

The proverbs package takes advantage of the awesome free Bible api
<https://bible-api.com/>, maintained by [Tim
Morgan](https://timmorgan.org/). Thanks, Tim!

## Contact me

I can be reached at my website
[technistema.com](https://technistema.com)
