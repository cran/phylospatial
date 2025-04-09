## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.dim = c(6, 4)
)

## ----optim, message=FALSE-----------------------------------------------------
library(phylospatial); library(tmap); library(magrittr)

ps <- moss()
init <- seq(1, 0, length.out = nrow(ps$comm))
cost <- runif(nrow(ps$comm), 10, 1000)
priority <- ps_prioritize(ps, init = init, cost = cost, progress = FALSE)

tm_shape(priority) + 
      tm_raster(palette = "-inferno", style = "log10",
                title = "conservation\npriorities") + 
      tm_layout(legend.outside = TRUE)

## ----prob---------------------------------------------------------------------
priority <- ps_prioritize(ps, init = init, cost = cost, n_reps = 100,
                          method = "prob", max_iter = 10, progress = FALSE)

tm_shape(priority$top10) + 
      tm_raster(palette = "inferno", style = "cont",
                title = "proporiton of runs\nin which site was\ntop-10 priority") + 
      tm_layout(legend.outside = TRUE)

## ----lambda, fig.dim = c(4.5, 5)----------------------------------------------
plot_lambda()

