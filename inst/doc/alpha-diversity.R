## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
fig.dim = c(6, 4)
)

## ----setup, message=FALSE-----------------------------------------------------
library(phylospatial); library(tmap)
ps <- moss()

## ----alpha, message=FALSE, warning=FALSE--------------------------------------
div <- ps_diversity(ps, metric = c("PD", "PE"))
tm_shape(div$PD) + 
      tm_raster(palette = "inferno", style = "cont") +
      tm_layout(legend.outside = TRUE)
tm_shape(div$PE) + 
      tm_raster(palette = "inferno", style = "cont") +
      tm_layout(legend.outside = TRUE)

## ----rand, message=FALSE, warning=FALSE---------------------------------------
rand <- ps_rand(ps, n_rand = 25, progress = FALSE,
                metric = c("PD", "PE", "CE", "RPE"))
tm_shape(rand$qPE) + 
      tm_raster(palette = "inferno", style = "cont") +
      tm_layout(legend.outside = TRUE)

## ----rand2, message=FALSE, warning=FALSE, eval=FALSE--------------------------
# ps2 <- ps_simulate(data_type = "abundance", metric = "PD")
# rand2 <- ps_rand(ps2, fun = "nullmodel", method = "abuswap_c", progress = FALSE)

## ----canape, message=FALSE, warning=FALSE-------------------------------------
cp <- ps_canape(rand, alpha = .05)
terra::plot(cp)

