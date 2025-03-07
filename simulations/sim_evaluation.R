####################################################################
# Xiaxian Ou
# Mar 07 2025
#
# Process results from simulation
# Evalution
####################################################################


library(tidyverse)

####################################################################
# Combine results from different scenarios
####################################################################

# List all .RDA files in the directory
rda_files <- list.files(here::here("results", "20250307"), pattern = "\\.RDA$", full.names = TRUE)

# Loop through each file and load the data
all_results <- list()


for (file in rda_files) {
  load(file)
  
  all_results[[file]] <- scenario_results
}

final_results <- bind_rows(all_results)



####################################################################
# Variables for evaluation
####################################################################

final_results <- final_results |> 
  mutate(
    bias = beta_hat - beta_true,
    coverage = if_else((beta_true <= conf.high) & (beta_true >= conf.low), 1, 0),
    
    # H0: beta = 0
    # H1: beta = 0.5
    # Pr(reject H0| H0 true)
    type1.error = case_when(beta_true == 0.5 ~ NA,
                            ((beta_true == 0) & (0 <= conf.high) & (0 >= conf.low)) ~ 0,
                            T ~ 1),
    
    # Pr(reject H0| H1 true)
    power = case_when(beta_true == 0 ~ NA,
                      ( (beta_true == 0.5) & ((0 > conf.high) | (0 < conf.low)) ) ~ 1,
                      T ~ 0)
  )


evaluation_results <- 
  final_results |> 
  group_by(beta_true, error_distribution, method) |> 
  summarize(
    nsim = n(),
    
    # bias
    bias = mean(bias, na.rm = T),
    se_bias = sqrt(sum((beta_hat - mean(beta_hat, na.rm = TRUE))^2)/(nsim*(nsim - 1))),
    
    # coverage
    coverage = mean(coverage, na.rm = T),
    se_coverage = sqrt(coverage * (1 - coverage)/nsim),
    
    # type I error
    type1.error = mean(type1.error, na.rm = T),
    se_type1.error = sqrt(type1.error * (1 - type1.error)/nsim),
    
    # power
    power = mean(power, na.rm = T),
    se_power = sqrt(power * (1 - power)/nsim)
    )



####################################################################
# save evaluation results
####################################################################

save(evaluation_results, file = here::here("results", "20250307", "evaluation.Rdata"))

