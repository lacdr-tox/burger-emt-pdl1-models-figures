squarePlot <- function(plt){
    lim = max(abs(c(layer_scales(plt)$x$range$range, layer_scales(plt)$y$range$range)))
    return(plt+coord_equal()+
            expand_limits(x=c(-lim, lim),
                          y=c(-lim, lim)))
}


scale_shape_solid <- function(...) {
  scale_shape_manual(..., values = 21:25)
}
  
scale_shape_star <- function(...) {
  scale_shape_manual(..., values = c(16,17,15,8))
}

fill_shape_legend <- function() {
  guides(shape = guide_legend(override.aes = list(fill = "black")))
}

# Make sure some shape (21) shows up in the legend
scale_fill_OkabeIto_fillable <- function(..., size = NULL) {
  options = list(shape=21)
  if(!is.null(size)) {
    options <- c(options, size = size)
  }
  colorblindr::scale_fill_OkabeIto(...,
    guide = guide_legend(
      override.aes = options
      )
  )
}


pub_font = ""
pub_font_size = 13
pub_font_size_rel = 0.8
pub_dot_size = 4

# definitions from dviz.supp
# dviz.supp::plot_grid
plot_grid <- function (..., label_fontfamily = pub_font, label_fontface = "plain", 
                       hjust = 0, vjust = 1) 
{
  cowplot::plot_grid(..., label_fontfamily = label_fontfamily, 
                     label_fontface = label_fontface, hjust = hjust, vjust = vjust)
}

# theme_dviz_grid
theme_pub_grid <- function (font_size = pub_font_size, font_family = pub_font, line_size = 0.5, 
                            rel_small = 12/14, rel_tiny = 11/14, rel_large = 16/14, colour = "grey90") 
{
  half_line <- font_size/2
  cowplot::theme_minimal_grid(font_size = font_size, font_family = font_family, 
                              line_size = line_size, rel_small = rel_small, rel_tiny = rel_tiny, 
                              rel_large = rel_large, colour = colour) %+replace% theme(plot.margin = margin(half_line/2, 
                                                                                                            1.5, half_line/2, 1.5), complete = TRUE)
}

# theme_dviz_hgrid
theme_pub_hgrid <- function (font_size = pub_font_size, font_family = pub_font, line_size = 0.5, 
                             rel_small = 12/14, rel_tiny = 11/14, rel_large = 16/14, colour = "grey90") 
{
  half_line <- font_size/2
  cowplot::theme_minimal_hgrid(font_size = font_size, font_family = font_family, 
                               line_size = line_size, rel_small = rel_small, rel_tiny = rel_tiny, 
                               rel_large = rel_large, colour = colour) %+replace% theme(plot.margin = margin(half_line/2, 
                                                                                                             1.5, half_line/2, 1.5), complete = TRUE)
}

# theme_dviz_vgrid
theme_pub_vgrid <- function (font_size = pub_font_size, font_family = pub_font, line_size = 0.5, 
                             rel_small = 12/14, rel_tiny = 11/14, rel_large = 16/14, colour = "grey90") 
{
  half_line <- font_size/2
  cowplot::theme_minimal_vgrid(font_size = font_size, font_family = font_family, 
                               line_size = line_size, rel_small = rel_small, rel_tiny = rel_tiny, 
                               rel_large = rel_large, colour = colour) %+replace% theme(plot.margin = margin(half_line/2, 
                                                                                                             1.5, half_line/2, 1.5), complete = TRUE)
}

# theme_dviz_map
theme_pub_map <- function (font_size = pub_font_size, font_family = pub_font, line_size = 0.5, 
                           rel_small = 12/14, rel_tiny = 11/14, rel_large = 16/14) 
{
  half_line <- font_size/2
  cowplot::theme_map(font_size = font_size, font_family = font_family, 
                     line_size = line_size, rel_small = rel_small, rel_tiny = rel_tiny, 
                     rel_large = rel_large) %+replace% theme(plot.margin = margin(half_line/2, 
                                                                                  1.5, half_line/2, 1.5), complete = TRUE)
}

# theme_dviz_open
theme_pub_open <- function (font_size = pub_font_size, font_family = pub_font, line_size = 0.5, 
                            rel_small = 12/14, rel_tiny = 11/14, rel_large = 16/14) 
{
  half_line <- font_size/2
  cowplot::theme_half_open(font_size = font_size, font_family = font_family, 
                           line_size = line_size, rel_small = rel_small, rel_tiny = rel_tiny, 
                           rel_large = rel_large) %+replace% 
    theme(plot.margin = margin(half_line/2, 
                               1.5, half_line/2, 1.5), complete = TRUE,
          strip.background = element_blank())
}

