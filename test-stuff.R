library(tidyverse)
library(interp)
library(cowplot)
theme_set(theme_minimal())
text_size <- 15
label_size <- round(text_size *1.5)

twod_copasi %>% 
  drop_na() %>%
  nest_by(`Values[I (global)].InitialValue`) -> nested

nested <- nested %>%
  mutate(
    bpx = list(determine_BP(data, "# Values[S].InitialValue", "[mZ]", res = "x")),
    bpy = list(determine_BP(data, "# Values[S].InitialValue", "[mZ]", res = "y")),
  )

# sometimes too many bps are detected
wonky <- nested %>% filter(length(bpx) != 4)

# debug
wonky %>% mutate(
  data = list(data %>% mutate(interval = findInterval(`[mZ]`, bpy)))
) %>% 
  select(-bpx, -bpy) %>%
  unnest(data) %>% 
  ggplot(aes(`# Values[S].InitialValue`,`[mZ]`, color = as.factor(interval))) + 
           geom_point() +
           facet_wrap(vars(`Values[I (global)].InitialValue`))

correct_bps <- tibble(
  `Values[I (global)].InitialValue` = wonky$`Values[I (global)].InitialValue`,
  bps = list(
    c(1:4),
    c(1,2,5,6),
    c(1:4),
    c(1,2,3,6),
    c(1,2,3,6),
    c(1,2,5,6),
    c(1,2,3,6),
    c(1,2,3,6),
    c(1,2,3,6),
    c(1,2,5,6)
  )
)
  
fixed <- wonky %>% 
  left_join(correct_bps) %>%
  rowwise() %>%
  mutate(
    bpx = list(bpx[bps]),
    bpy = list(bpy[bps])
  ) %>%
  select(-bps)

# check
fixed %>% mutate(
  data = list(data %>% mutate(interval = findInterval(`[mZ]`, bpy)))
) %>% 
  select(-bpx, -bpy) %>%
  unnest(data) %>% 
  ggplot(aes(`# Values[S].InitialValue`,`[mZ]`, color = as.factor(interval))) + 
  geom_point() +
  facet_wrap(vars(`Values[I (global)].InitialValue`))

nested <- nested %>%
  rows_update(fixed)

nested %>%
  mutate(
    data = list(data %>% mutate(interval = findInterval(`[mZ]`, bpy)))
  ) %>%
  select(-bpx,-bpy) %>%
  unnest(data) %>%
  filter((interval %% 2) == 0 ) %>%
  left_join(tibble(interval = c(0,2,4), emt = c("E", "E/M", "M"))) %>%
  select(-interval) %>%
  rename(
    IFN = `Values[I (global)].InitialValue`,
    S = `# Values[S].InitialValue`
    ) -> sumtest

# take average for duplicates
sumtest %>% 
  select(IFN, S, emt, `[PM]`) %>%
  group_by(IFN, S, emt) %>% 
  summarise(across(where(is.numeric), mean)) -> simple_sum

# reduce x resolution to solve missing values and make suitable for interp
xintervals <- with(simple_sum, seq(min(S), max(S), length = 101))
xmidinterval <- xintervals + diff(xintervals)[1]
simple_sum %>% 
  ungroup() %>% 
  mutate(s_bin = findInterval(S, xintervals)) %>% 
  group_by(IFN, s_bin, emt) %>% 
  summarize(`[PM]` = mean(`[PM]`), .groups = "drop") %>%
  left_join(tibble(s_bin = seq_along(xintervals), s_bin_mid = xmidinterval), by = "s_bin") %>%
  mutate(S = s_bin_mid) %>%
  select(-starts_with("s_bin")) -> simple_sum2

simple_sum2 %>% 
  nest_by(emt) %>%
  mutate(
    data = list({
        interp(data$S / 1e5, data$IFN, data$`[PM]`, 
               xo = xmidinterval / 1e5, yo = unique(data$IFN)) %>% 
        interp2xyz(data.frame = T) %>% 
        rename(S = x, IFN = y, `[PM]` = z) %>%
        as_tibble() %>% 
        drop_na()
    }))-> interped_data

nested %>% 
  summarize(bp_to_tibble(bpx), .groups = "drop") %>%
  rename(IFN = `Values[I (global)].InitialValue`) -> sum2


BP1_sp <- spline(sum2$IFN, sum2$BP1, xmax = 0.1, n = 10*length(sum2$IFN))
BP2_sp <- spline(sum2$IFN, sum2$BP2, xmax = 0.1, n = 10*length(sum2$IFN))
BP3_sp <- spline(sum2$IFN, sum2$BP3, xmax = 0.1, n = 10*length(sum2$IFN))
BP4_sp <- spline(sum2$IFN, sum2$BP4, xmax = 0.1, n = 10*length(sum2$IFN))
BP_smooth <- tibble(IFN = BP1_sp$x, BP1 = BP1_sp$y, BP2 = BP2_sp$y, BP3 = BP3_sp$y, BP4 = BP4_sp$y)

bounds <- tibble(
  emt = c("E", "E/M", "M"), 
  bounds = list(
    sum2 %>% select(IFN, s_max = BP1) %>% add_column(s_min = 0),
    sum2 %>% select(IFN, s_min = BP2, s_max = BP3),
    sum2 %>% select(IFN, s_min = BP4) %>% add_column(s_max = Inf)
  )
)

# remove interpolation outside hull
interped_data %>% 
  left_join(bounds) %>% 
  mutate(
    data= list(data %>% 
                 left_join(bounds, by = "IFN") %>%
                 filter(S >= s_min / 1e5, S <= s_max / 1e5) %>%
                 select(-s_min, -s_max)
    )
    ) %>% 
  select(-bounds) %>%
  unnest(data) -> interped_data_corr 

interped_data_corr %>%
  group_by(IFN, S) %>%
  summarize(`[PM]` = mean(`[PM]`, na.rm =T)) -> averaged

plot_data <- bind_rows(interped_data_corr, averaged %>% add_column(emt = "Average")) %>%
  mutate(emt = factor(emt, levels = c("E", "E/M", "M", "Average")))

(pp <- plot_data %>%
    ggplot(aes(S,IFN)) + 
  geom_raster(aes(fill = `[PM]` / 1e5)) + 
    facet_wrap(vars(emt), nrow = 1) +
  scale_fill_viridis_c(limits = function(x) {x[1] <- 0; x}) +
  labs(x = bquote('SNAIL1 ('*10^5~'molecules)'),
       y = expression(paste('IFN', gamma, ' (nM)')),
       fill = bquote('PD-L1 membrane ('*10^5~'molecules)')))


(p1 <- pp + geom_path(data = BP_smooth %>% pivot_longer(cols = starts_with("BP")), 
                     aes(x = value / 1e5, y = IFN, group = name), 
                     inherit.aes = F, size = 2, color = "white"))

p1 + coord_cartesian(expand = F) + 
  theme_cowplot(text_size) + 
  panel_border() +
  theme(strip.background = element_blank()) + 
  theme(legend.position="top", 
        legend.justification = "right") 

