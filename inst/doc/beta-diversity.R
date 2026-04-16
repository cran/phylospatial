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
library(phylospatial); library(tmap); library(magrittr)
ps <- moss()

## ----beta, message=FALSE, warning=FALSE---------------------------------------
ps <- ps_add_dissim(ps, method = "sorensen", endemism = TRUE, normalize = TRUE)
ps

## ----geodist, message=FALSE, warning=FALSE------------------------------------
phy_beta <- as.vector(ps_dissim(ps, method = "sorensen"))
spp_beta <- as.vector(ps_dissim(ps, method = "sorensen", tips_only = TRUE))
geo_dist <- as.vector(ps_geodist(ps)) / 1000  # convert to km

# subsample for plotting (full pairwise set is huge)
ss <- sample(length(phy_beta), 5000)

plot(geo_dist[ss], phy_beta[ss],
     pch = ".", col = adjustcolor("steelblue", 0.3),
     xlab = "Geographic distance (km)",
     ylab = "Dissimilarity",
     ylim = c(0, 1))
points(geo_dist[ss], spp_beta[ss],
       pch = ".", col = adjustcolor("tomato", 0.3))
 
# loess trend lines
lo_phy <- loess(phy_beta[ss] ~ geo_dist[ss])
lo_spp <- loess(spp_beta[ss] ~ geo_dist[ss])
ox <- order(geo_dist[ss])
lines(geo_dist[ss][ox], predict(lo_phy)[ox], col = "steelblue", lwd = 2)
lines(geo_dist[ss][ox], predict(lo_spp)[ox], col = "tomato", lwd = 2)
 
legend("bottomright",
       legend = c("Phylogenetic", "Species"),
       col = c("steelblue", "tomato"),
       lwd = 2, bty = "n")

## ----ordinate, message=FALSE, warning=FALSE-----------------------------------
ps %>%
      ps_ordinate(method = "pca", k = 4) %>%
      tm_shape() +
      tm_raster(col.scale = tm_scale_continuous(values = "brewer.pi_yg"),
                col.free = FALSE) +
      tm_title("Phylogenetic community ordination")

## ----rgb, message=FALSE, warning=FALSE----------------------------------------
ps %>%
      ps_rgb(method = "cmds") %>%
      tm_shape() +
      tm_rgb(col.scale = tm_scale_rgb(max_color_value = 1), 
             interpolate = FALSE) +
      tm_title("Phylogenetic community ordination")

## ----k, message=FALSE, warning=FALSE------------------------------------------
ps_regions_eval(ps, k = 1:15, plot = TRUE, method = "average")

## ----regions, message=FALSE, warning=FALSE------------------------------------
ps %>%
      ps_regions(k = 4, method = "average") %>%
      tm_shape() +
      tm_raster(col.scale = tm_scale_categorical(values = "brewer.dark2"),
                col.legend = tm_legend(show = FALSE)) +
      tm_title("phylogenetic region")

