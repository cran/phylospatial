## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
fig.dim = c(6, 4)
)

## ----setup, message=FALSE-----------------------------------------------------
library(phylospatial); library(tmap); library(magrittr)
ps <- moss()

## ----beta, message=FALSE, warning=FALSE---------------------------------------
ps <- ps_add_dissim(ps, method = "sorensen", endemism = TRUE, normalize = TRUE)
ps

## ----ordinate, message=FALSE, warning=FALSE-----------------------------------
ps %>%
      ps_ordinate(method = "pca", k = 4) %>%
      tm_shape() +
      tm_raster(palette = "PiYG", style = "cont") +
      tm_layout(title = "Phylogenetic community ordination")

## ----rgb, message=FALSE, warning=FALSE----------------------------------------
ps %>%
      ps_rgb(method = "cmds") %>%
      tm_shape() +
      tm_rgb(max.value = 1, interpolate = FALSE) +
      tm_layout(title = "Phylogenetic community ordination")

## ----k, message=FALSE, warning=FALSE------------------------------------------
ps_regions_eval(ps, k = 1:15, plot = TRUE, method = "average")

## ----regions, message=FALSE, warning=FALSE------------------------------------
ps %>%
      ps_regions(k = 3, method = "average") %>%
      tm_shape() +
      tm_raster(style = "cat", palette = "Dark2",
                title = "phylogenetic region") +
      tm_layout(legend.outside = TRUE)

