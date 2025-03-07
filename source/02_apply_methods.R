library(broom)
library(tidyverse)


# Wald confidence intervals
standard_wald = function(simulated_data, alpha = 0.05){
  fit_lm = lm(y ~ x, simulated_data)
  
  tidy(fit_lm, conf.int = TRUE) %>%
    filter(term == "x") %>%
    mutate(method = "wald") %>%
    rename(beta_hat = estimate) %>%
    dplyr::select(beta_hat, std.error, conf.low, conf.high, method)
}



# Nonparametric bootstrap percentile intervals
boot_quantile = function(simulated_data, beta_hat, nboot, alpha = 0.05){
  
  boot_beta <- rep(NA, nboot)
  sample_size <- nrow(simulated_data)
  
  ## bootstrap ***********************
  for(b in 1:nboot){
    # get the sample for each bootstrap
    sample_index = sample(1:sample_size, size = sample_size, replace = TRUE)
    boot_sample = simulated_data[sample_index, ]
    
    # run linear regression
    fit_lm = lm(y ~ x, boot_sample)
    
    # get estimated beta
    boot_beta[b] = fit_lm$coefficients[["x"]]
  }
  
  ## output    ***********************
  tibble(beta_hat = beta_hat, 
         std.error = sd(boot_beta, na.rm = T),
         conf.low = quantile(boot_beta, alpha/2, na.rm = T),
         conf.high = quantile(boot_beta, 1 - alpha/2, na.rm = T),
         method = "boot"
  )
}


