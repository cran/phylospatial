## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.dim = c(6, 4)
)

if (!requireNamespace("tmap", quietly = TRUE) || grepl("devel", R.version.string)) {
  knitr::opts_chunk$set(eval = FALSE)
  message("Package 'tmap' needed for this vignette. Either it is not installed, or it is being called from R-devel where it has compatibility issues. Code will not be evaluated.")
}

## ----init, message=FALSE, warning=FALSE---------------------------------------
library(phylospatial); library(tmap); library(magrittr)

ps <- moss()
set.seed(123)
init <- seq(1, 0, length.out = ps$n_sites)
cost <- runif(ps$n_sites, 10, 1000)

## ----optim, eval=FALSE--------------------------------------------------------
# priority <- ps_prioritize(ps, init = init, cost = cost)
# 
# tm_shape(priority) +
#       tm_raster(col.scale = tm_scale_continuous_log(values = "-inferno")) +
#       tm_layout(legend.outside = TRUE)

## ----precompute, eval=FALSE, echo=FALSE---------------------------------------
# # pre-process to avoid exceeding CRAN runtime limits -- need to manually run this when updating vignette!
# priority <- ps_prioritize(ps, init = init, cost = cost, progress = FALSE)
# terra::writeRaster(priority, "~/R/phylospatial/inst/extdata/priority.tif", overwrite = TRUE)
# # performance curves require the metadata attached to `priority`, which `writeRaster()` drops
# perf <- ps_performance(ps, priority, target = c(.3, .8))
# utils::write.csv(perf, "~/R/phylospatial/inst/extdata/priority-performance.csv", row.names = FALSE)

## ----postcompute, echo=FALSE--------------------------------------------------
priority <- terra::rast(system.file("extdata", "priority.tif", package = "phylospatial"))

tm_shape(priority) + 
      tm_raster(col.scale = tm_scale_continuous_log(values = "-inferno")) + 
      tm_layout(legend.outside = TRUE)

## ----perf, eval=FALSE---------------------------------------------------------
# perf <- ps_performance(ps, priority, target = c(.3, .8))
# head(perf)
# 
# par(mfrow = c(1, 2))
# plot(perf)
# plot(perf, yvar = "cov80")

## ----postcompute_perf, echo=FALSE, fig.dim = c(7, 3.5)------------------------
perf <- utils::read.csv(system.file("extdata", "priority-performance.csv", package = "phylospatial"))
class(perf) <- c("ps_performance", "data.frame")
head(perf)

par(mfrow = c(1, 2))
plot(perf)
plot(perf, yvar = "cov80")

## ----prob, eval=FALSE---------------------------------------------------------
# priority <- ps_prioritize(ps, init = init, cost = cost, n_reps = 2500,
#                           method = "prob", max_iter = 10)
# 
# tm_shape(priority$top10) +
#       tm_raster(col.scale = tm_scale_continuous(values = "inferno"),
#                 col.legend = tm_legend(title = "proporiton of runs\nin which site was\ntop-10 priority")) +
#       tm_layout(legend.outside = TRUE)

## ----precompute2, eval=FALSE, echo=FALSE--------------------------------------
# # pre-process to avoid exceeding CRAN runtime limits -- need to manually run this when updating vignette!
# priority <- ps_prioritize(ps, init = init, cost = cost, n_reps = 2500,
#                           method = "prob", max_iter = 10)
# terra::writeRaster(priority, "~/R/phylospatial/inst/extdata/priority-prob.tif", overwrite = TRUE)

## ----postcompute2, echo=FALSE-------------------------------------------------
priority <- terra::rast(system.file("extdata", "priority-prob.tif", package = "phylospatial"))

tm_shape(priority$top10) + 
      tm_raster(col.scale = tm_scale_continuous(values = "inferno"),
                col.legend = tm_legend(title = "proporiton of runs\nin which site was\ntop-10 priority")) + 
      tm_layout(legend.outside = TRUE)

## ----lambda, fig.dim = c(4.5, 5)----------------------------------------------
plot_lambda()

## ----prioritizr, eval=FALSE---------------------------------------------------
# library(prioritizr)
# 
# prob <- ps_prioritizr(ps, init = init, cost = cost,
#                       objective = "min_set", target = .5) %>%
#       add_default_solver(gap = 0, verbose = FALSE)
# 
# solution <- solve(prob)
# 
# tm_shape(solution) +
#       tm_raster(col.scale = tm_scale_categorical(values = c("gray80", "darkred")),
#                 col.legend = tm_legend(title = "selected")) +
#       tm_layout(legend.outside = TRUE)

## ----precompute3, eval=FALSE, echo=FALSE--------------------------------------
# # pre-process because solvers are not available when building on CRAN -- need to manually run this when updating vignette!
# library(prioritizr)
# prob <- ps_prioritizr(ps, init = init, cost = cost,
#                       objective = "min_set", target = .5) %>%
#       add_default_solver(gap = 0, verbose = FALSE)
# solution <- solve(prob)
# terra::writeRaster(solution, "~/R/phylospatial/inst/extdata/priority-prioritizr.tif", overwrite = TRUE)

## ----postcompute3, echo=FALSE-------------------------------------------------
solution <- terra::rast(system.file("extdata", "priority-prioritizr.tif", package = "phylospatial"))

tm_shape(solution) + 
      tm_raster(col.scale = tm_scale_categorical(values = c("gray80", "darkred")),
                col.legend = tm_legend(title = "selected")) + 
      tm_layout(legend.outside = TRUE)

