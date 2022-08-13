library(colorblindr)

time_dynamics <- tribble(
  ~type, ~experiment, ~file,
  "EMT", "ifn0", "data/emt_td_mPY/EMT no IFN fixed.txt",
  "EMT", "ifn1", "data/emt_td_mPY/EMT IFN fixed.txt",
  "MET", "ifn0", "data/emt_td_mPY/MET no IFN fixed.txt",
  "MET", "ifn1", "data/emt_td_mPY/MET IFN fixed.txt"
) %>% 
  rowwise() %>%
  mutate(data = list(read_copasi(file))) %>%
  select(-file) %>% unnest(data)

time_dynamics <- time_dynamics %>%
  mutate(
    across(all_of(c("[mP]", "[PM]","(R5).Flux")), ~ ifelse(experiment == "no_int", NA, .x)),
    time = `# Time`/24
  ) %>% select(-`# Time`)

time_dynamics %>% 
  pivot_longer(cols = c(where(is.numeric), -time)) -> test_time_dynamics_long

td_vars <- c("(R5).Flux")
td_labels <- c("mP * Y") %>% setNames(td_vars)

test_time_dynamics_long %>% 
  filter(name %in% td_vars) %>%
  mutate(experiment = factor(experiment, levels = exp_order)) %>%
  ggplot(aes(time,value * 1e10, color = experiment)) +
  geom_line(aes(linetype = experiment), size = 1.2) +
  facet_wrap(vars(type), labeller = labeller(as_labeller(td_labels))) +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(expand = expansion(mult = c(0,0.05))) +
  expand_limits(y = 0) + 
  #scale_color_OkabeIto(order = c(8,2,1), labels = exp_labels, name = NULL) +
  #scale_linetype_manual(values = c("dashed", "solid", "solid"), labels = exp_labels, name = NULL) + 
  scale_color_OkabeIto(order = c(2,1), labels = exp_labels, name = NULL) +
  scale_linetype_manual(values = c("solid", "solid"), labels = exp_labels, name = NULL) + 
  labs(x = "Time (days)", y = bquote('mP * Y (' * 10^-10 ~ 'molecules/time)')) + 
  theme_cowplot(text_size) + 
  panel_border() +
  #background_grid() + 
  theme(strip.placement = 'outside', 
        strip.background = element_blank(),
        strip.text.x = element_text(size = 1.2*text_size, face = "bold"),
        panel.spacing.x = unit(1, "lines"),
        legend.position = "top",
        legend.justification = "right")

