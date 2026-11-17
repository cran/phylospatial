## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
fig.dim = c(6, 4)
)

## ----setup, message=FALSE, warning=FALSE--------------------------------------
library(phylospatial); library(terra)
ps <- moss()

## ----beta, message=FALSE, warning=FALSE---------------------------------------
ps <- ps_add_dissim(ps, method = "sorensen", endemism = TRUE, normalize = TRUE)
ps

## ----focal, message=FALSE, warning=FALSE, fig.dim = c(8, 4.4), out.width = "100%"----
focal <- sf::st_as_sf(data.frame(site = c("Sierra Nevada", "Mojave Desert"),
                                 lon = c(-119.6, -116), lat = c(37.8, 34.6)),
                      coords = c("lon", "lat"),
                      crs = 4269) # longitude/latitude on the same datum (NAD83) as the moss data
focal$site <- factor(focal$site, levels = focal$site) # keep panels in this order

map_focal <- function(r, pts){
      pts <- project(vect(pts), crs(r))
      plot(r, col = hcl.colors(100, "YlGnBu", rev = TRUE), range = c(0, 1),
           nc = nlyr(r), axes = FALSE,
           # with several focal sites, show each site's point only in its own panel
           fun = function(i) points(pts[min(i, nrow(pts))], col = "red", pch = 19, cex = 1.2))
}

fd <- ps_dissim_focal(ps, focal, method = "sorensen")
names(fd) <- levels(focal$site)
map_focal(fd, focal)

## ----focal_partition, message=FALSE, warning=FALSE, fig.dim = c(8, 4.4), out.width = "100%"----
fp <- c(ps_dissim_focal(ps, focal[1, ], method = "sorensen_turnover"),
        ps_dissim_focal(ps, focal[1, ], method = "sorensen_nestedness"))
names(fp) <- c("turnover", "nestedness")
map_focal(fp, focal[1, ])

## ----focal_difference, message=FALSE, warning=FALSE, fig.dim = c(8, 4.4), out.width = "100%"----
fdiff <- ps_dissim_focal(ps, focal, method = "focal_difference")
names(fdiff) <- levels(focal$site)
map_focal(fdiff, focal)

## ----paired_data, message=FALSE, warning=FALSE--------------------------------
comm1 <- ps_get_comm(ps)
comm2 <- shift(comm1, dy = 60000)          # shift ranges 60 km north
comm2 <- crop(extend(comm2, comm1), comm1) # back onto the original grid
comm2 <- cover(comm2, comm1)               # keep original communities where nothing shifts in
comm2 <- mask(comm2, comm1[[1]])           # restrict to the study area

range_size <- terra::global(comm1, "sum", na.rm = TRUE)[, 1]
extinct <- order(range_size)[1:20]
comm2[[extinct]] <- comm2[[extinct]] * 0

ps2 <- phylospatial(comm2, ps$tree)

## ----paired, message=FALSE, warning=FALSE, fig.dim = c(8, 4.4), out.width = "100%"----
map_change <- function(r){
      plot(r, col = hcl.colors(100, "YlGnBu", rev = TRUE), range = c(0, 1),
           nc = nlyr(r), axes = FALSE)
}

chg <- c(ps_dissim_paired(ps, ps2, tree = ps$tree),
         ps_dissim_paired(ps, ps2, tree = ps$tree, tips_only = TRUE))
names(chg) <- c("phylogenetic", "terminal taxa only")
map_change(chg)

## ----paired_direction, message=FALSE, warning=FALSE, fig.dim = c(8, 4.4), out.width = "100%"----
dirn <- c(ps_dissim_paired(ps, ps2, method = "loss", tree = ps$tree),
          ps_dissim_paired(ps, ps2, method = "gain", tree = ps$tree))
names(dirn) <- c("loss", "gain")
map_change(dirn)

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

## ----ordinate, message=FALSE, warning=FALSE, fig.dim = c(7, 5)----------------
ord <- ps_ordinate(ps, method = "pca", k = 4)
lim <- max(abs(minmax(ord)))  # common, symmetric color scale for all axes
plot(ord, col = hcl.colors(100, "PiYG"), range = c(-lim, lim), axes = FALSE)

## ----rgb, message=FALSE, warning=FALSE----------------------------------------
rgb <- ps_rgb(ps, method = "cmds")
plotRGB(rgb, scale = 1, smooth = FALSE, mar = c(0, 0, 2, 0),
        main = "Phylogenetic community ordination")

## ----k, message=FALSE, warning=FALSE------------------------------------------
ps_regions_eval(ps, k = 1:15, plot = TRUE, method = "average")

## ----regions, message=FALSE, warning=FALSE------------------------------------
regions <- ps_regions(ps, k = 4, method = "average")
plot(regions, type = "classes", col = palette.colors(4, "Dark 2"), legend = FALSE,
     axes = FALSE, main = "Phylogenetic regions")

