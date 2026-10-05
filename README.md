
<!-- README.md is generated from README.Rmd. Please edit that file -->

# burger-emt-pdl1-models-figures

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6000437.svg)](https://doi.org/10.5281/zenodo.6000437)
<!-- badges: end -->

Models and code used to generate figures for

> Burger, G. A., D. N. Nesenberend, C. M. Lems, et al. (2022).,
> “Bidirectional crosstalk between epithelial–mesenchymal plasticity
> and, IFNγ-induced PD-L1 expression promotes tumour progression”. In:
> *Royal, Society Open Science* 9.11, p. 220186.,
> <https://doi.org/10.1098/rsos.220186>.

## Usage

### Models

COPASI models can be found in `data/copasi_models`.

### Figures

Figures are generated reproducibly in R using
[`renv`](https://rstudio.github.io/renv/index.html) and
[`targets`](https://docs.ropensci.org/targets/):

1.  Download/clone this repository

2.  Open the project file (`.Rproj`) in RStudio

3.  Run

    ``` r
    renv::restore()
    ```

    to install R package dependencies.

4.  Open `targets.Rmd` and choose *Run* \> *Run All*. Figures will
    appear in the `output` folder.

------------------------------------------------------------------------
