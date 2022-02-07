se <- function(x, na.rm=FALSE) {
  if (na.rm) x <- na.omit(x)
  sqrt(var(x)/length(x))
}

# determine bifurcation points
determine_BP <- function(df, xvar, yvar, res = "y") {
  sf <- splinefun(df[[yvar]], df[[xvar]], method = "natural", ties = mean)
  roots  <- rootSolve::uniroot.all(sf, interval = c(min(df[[yvar]]), max(df[[yvar]])), deriv = 1)
  if(res == "y") return(roots)
  else if(res == "x") return(sf(roots))
  else stop("invalid option for res")
}
bp_to_tibble <- function(bp) {
  tibble(value = bp) %>% 
    mutate(name = paste0("BP", seq_along(bp))) %>%
    pivot_wider()
}
# read copasi
read_copasi <- function(x) {
  suppressMessages(suppressWarnings(read_tsv(x, col_types = cols()))) %>% 
    dplyr::select(where(is.numeric))
}
bp_to_tibble <- function(bp) {
  tibble(value = bp) %>% 
    mutate(name = paste0("BP", seq_along(bp))) %>%
    pivot_wider()
}

