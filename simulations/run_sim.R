####################################################################
# Xiaxian Ou
# Mar 07 2025
#
# Homework 3 HPC 
####################################################################


pacman::p_load(tidyverse, tictoc)

source(here::here("source", "01_simulate_data.R"))
source(here::here("source", "02_apply_methods.R"))
source(here::here("source", "03_summarise.R"))


###############################################################
## set simulation design elements
###############################################################

# Parameters for 4 scenarios
nsim = 475
n = c(20)
nboot = 1000
beta_true = c(0, 0.5)
error_distribution = c("Normal", "Gamma")


params.all = expand.grid(
  n = n,
  beta_true = beta_true,
  error_distribution = error_distribution
)



scenario <- as.numeric(commandArgs(trailingOnly=TRUE))
params = params.all[scenario,]


###############################################################
## start simulation code
###############################################################

seed = floor(runif(nsim, 1, 10000))
results = as.list(rep(NA, nsim))

for(i in 1:nsim){
  set.seed(seed[i])
  
  ####################
  # simulate data
  simdata = get_simdata(
    n = params$n,
    beta_treat = params$beta_true,
    error_distribution = params$error_distribution
  )
  
  
  ####################
  # apply method(s)
  
  # Wald 
  tic()
  est_wald = standard_wald(simdata, alpha = 0.05)
  time_wald = toc()
  
  
  # boot quantile
  tic()
  est_boot = boot_quantile(simdata, beta_hat = est_wald$beta_hat, nboot, alpha = 0.05)
  time_boot = toc()
  
  
  ####################
  # summarise estimates
  summary_wald = summarise_est(est_wald, params, time_wald)
  summary_boot = summarise_est(est_boot, params, time_boot)
  
  estimates = bind_rows(summary_wald, summary_boot)
  
  ####################
  # results, including estimates, speed, parameter scenarios
  estimates = estimates %>% mutate(seed  = seed[i])
  
  results[[i]] = estimates
}

scenario_results <- bind_rows(results)


###############################################################
## store results
###############################################################
Date = gsub("-", "", Sys.Date())
dir.create(file.path(here::here("results"), Date), showWarnings = FALSE)

filename = paste0(here::here("results", Date), "/scenario", scenario, ".RDA")
save(scenario_results, file = filename)



