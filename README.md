README
================
Xiaxian Ou

# Folder description

**simulations**

`simulations/run_sim.sh`

- Bash script to execute `run_sim.R` on HPC. 



`simulations/run_sim.R`

- set simulation design elements
- uses scenario to retrieve the JOBID in HPC.
- runs simulation codes for a specific scenario setting.
- saves results for each scenario in the  `results` folder


`simulations/sim_evaluation.R`

- combine all results from the `results` folder
- generates evaluation metrics.
- save the evaluation results in `results`


**source**

`source/01_simulate_data.R`

- `get_simdata` function generates simulation data based on input sample size and error distribution.

`source/02_apply_methods.R`

functions to calculate confidence interval by different methods

- `standard_wald`: get Wald confidence intervals after input data
- `boot_quantile`: implements nonparametric bootstrap percentile intervals (uses 1000 bootstrap samples in this homework).

`source/03_summarise.R`

- combine results, time, params together


**results**

`/20250307/`

- stores simulation results (.RDA) for each scenario.
- contains the overall evaluation results (evaluation.Rdata).


**analysis**

- Rmarkdown file to analyze the simulation results
- pdf file rendered from Rmarkdown



