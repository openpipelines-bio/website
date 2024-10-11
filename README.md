# openpipelines.bio

This repository is used to build [openpipelines.bio](https://openpipelines.bio).

## Installation

* Install [quarto](https://quarto.org) v1.5.57, R >= 4.4 and Python >= 3.10.

* Clone this repo with `git clone --recursive git@github.com:openpipelines-bio/website.git`

* Run `Rscript -e 'install.packages("renv")'` if you don't have `{renv}` installed.

* Run `Rscript -e 'renv::restore()'` to install R and Python packages recorded in the renv lockfile (`renv.lock`).
  This might take a while.

## Preview

Run `quarto preview` to render a preview version of the site.

To reduce the time it takes to render the site, quarto is set to not execute runnable code by default. As such, some content may be missing -- mostly the output of code blocks. Use `quarto preview --profile evaluate_code` to evaluate runnable code blocks. 

Tip: When you already did a render or preview with or without the profile argument, you need to remove the `_site` and `_freeze` directories to see a change by executing `rm -r _site _freeze`

## Build

Run `quarto render --profile evaluate_code` to render the site.
