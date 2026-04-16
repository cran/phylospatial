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

## ----setup, message=FALSE, warning=FALSE--------------------------------------
library(phylospatial); library(tmap)
ps <- moss()

## ----alpha, message=FALSE, warning=FALSE--------------------------------------
div <- ps_diversity(ps, metric = c("PD", "PE"))
tm_shape(div$PD) + 
      tm_raster(col.scale = tm_scale_continuous(values = "inferno")) +
      tm_layout(legend.outside = TRUE)
tm_shape(div$PE) + 
      tm_raster(col.scale = tm_scale_continuous(values = "inferno")) +
      tm_layout(legend.outside = TRUE)

## ----n_iter-------------------------------------------------------------------
set.seed(123)
iters <- ps_suggest_n_iter(ps, fun = "quantize", method = "curvecat", 
                           n_iter = 3e5, plot = TRUE)

## ----rand, eval=FALSE---------------------------------------------------------
# rand <- ps_rand(ps, n_rand = 1000, progress = FALSE,
#                 metric = c("PD", "PE", "CE", "RPE"),
#                 fun = "quantize", method = "curvecat",
#                 n_iter = iters, n_cores = 8)
# tm_shape(rand$qPE) +
#       tm_raster(col.scale = tm_scale_continuous(values = "inferno")) +
#       tm_layout(legend.outside = TRUE)

## ----precompute, eval=FALSE, echo=FALSE---------------------------------------
# # pre-process to avoid exceeding CRAN runtime limits -- need to manually run this when updating vignette!
# rand0 <- ps_rand(ps, n_rand = 1000, n_cores = 8, progress = TRUE,
#                  metric = c("PD", "PE", "CE", "RPE"),
#                 fun = "quantize", method = "curvecat",
#                 n_iter = iters)
# terra::writeRaster(rand0,
#                    "~/Documents/R/phylospatial/inst/extdata/alpha-diversity-rand.tif",
#                    overwrite = TRUE)

## ----postcompute, echo=FALSE--------------------------------------------------
rand <- terra::rast(system.file("extdata", "alpha-diversity-rand.tif", package = "phylospatial"))
tm_shape(rand$qPE) + 
      tm_raster(col.scale = tm_scale_continuous(values = "inferno")) +
      tm_layout(legend.outside = TRUE)

## ----rand2, message=FALSE, warning=FALSE, eval=FALSE--------------------------
# ps2 <- ps_simulate(data_type = "abundance")
# rand2 <- ps_rand(ps2, fun = "nullmodel", method = "abuswap_c", metric = "PD",
#                  n_iter = 1e6, n_rand = 999)

## ----rand_spatial, eval=FALSE-------------------------------------------------
# # Weight matrices for several alternative distance functions
# geo <- as.matrix(ps_geodist(ps_bin)) / 1000 # distance in km
# W <- dnorm(geo, sd = 100) # Gaussian decay w0th 100 km SD
# W <- exp(-geo / median(geo)) # exponential kernel
# W <- (geo < 200) + 0 #  hard distance threshold
# 
# # Weights matrix for discrete isolated regions
# island <- sample(1:5, nrow(ps$comm), replace = T)
# W <- (as.matrix(dist(island)) == 0) + 0
# 
# # Spatially constrained randomization
# iters <- ps_suggest_n_iter(ps_bin, fun = "nullcat", method = "curvecat", n_iter = 3e5)
# rand_spatial <- ps_rand(ps_bin, fun = "nullcat", method = "curvecat", n_iter = iters,
#                         n_rand = 1000, metric = c("PD", "PE"),
#                         wt_row = W)

## ----canape, message=FALSE, warning=FALSE-------------------------------------
cp <- ps_canape(rand, alpha = .05)
terra::plot(cp)

