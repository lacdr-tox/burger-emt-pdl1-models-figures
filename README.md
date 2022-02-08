
<!-- README.md is generated from README.Rmd. Please edit that file -->

# burger-emt-pdl1-models-figures

<!-- badges: start -->
<!-- badges: end -->

Models and code to generate figures for “Bidirectional Crosstalk Between
Epithelial-Mesenchymal Plasticity and IFNγ-Induced PD-L1 Expression
Promotes Tumor Progression.” bioRxiv.
<https://doi.org/10.1101/2022.02.03.478950> (Burger et al. 2022).

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

4.  Open `targets.Rmd` and choose *Run* > *Run All*. Figures will appear
    in the `output` folder.

------------------------------------------------------------------------

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-Burger2022_biorxiv" class="csl-entry">

Burger, Gerhard A, Daphne N Nesenberend, Carlijn M Lems, Sander C Hille,
and Joost B Beltman. 2022. “Bidirectional Crosstalk Between
Epithelial-Mesenchymal Plasticity and IFNγ-Induced PD-L1 Expression
Promotes Tumor Progression.” *bioRxiv*.
<https://doi.org/10.1101/2022.02.03.478950>.

</div>

</div>
