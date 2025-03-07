library(tidyverse)

summarise_est <- function(est_out, params, tic.toc.time){
  bind_cols(params, est_out) |> 
    mutate(
    time = tic.toc.time$toc - tic.toc.time$tic
  )
}
