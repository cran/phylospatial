## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
comment = "#>",
fig.dim = c(6, 4)
)

## ----setup, message=FALSE, warning=FALSE--------------------------------------
library(phylospatial); library(terra); library(ape); library(sf)

# simulate data
set.seed(1234)
n_taxa <- 5
x <- y <- 10
tree <- rtree(n_taxa)
comm <- rast(array((sin(seq(0, pi*12, length.out = n_taxa * x * y)) + 1)/2, 
                   dim = c(x, y, n_taxa)))
names(comm) <- tree$tip.label

# create phylospatial object
ps <- phylospatial(comm, tree)
ps

## ----tree, message=FALSE, warning=FALSE---------------------------------------
names(ps)

ps$tree

plot(ps, "tree")

## ----comm, message=FALSE, warning=FALSE---------------------------------------
head(ps$comm)

plot(ps, "comm")

## ----ps_grid, message=FALSE---------------------------------------------------
# simulate occurrence records
set.seed(42)
occ <- data.frame(
  species = sample(tree$tip.label, 600, replace = TRUE),
  x = runif(600, 0, 10),
  y = runif(600, 0, 10)
)
 
# rasterize onto a grid (here we specify a resolution in the auto-generated CRS)
comm_grid <- ps_grid(occ, res = 50000)
comm_grid
 
# build phylospatial object
ps_from_points <- phylospatial(comm_grid, tree)
ps_from_points

## ----moss, message=FALSE, warning=FALSE---------------------------------------
moss_comm <- rast(system.file("extdata", "moss_comm.tif", package = "phylospatial"))
moss_tree <- read.tree(system.file("extdata", "moss_tree.nex", package = "phylospatial"))
ps <- phylospatial(moss_comm, moss_tree)
plot(ps, "comm")
plot(ps, "tree", type = "fan", show.tip.label = FALSE)

## ----species, message=FALSE, warning=FALSE------------------------------------
ps <- phylospatial(comm)
plot(ps, "tree", type = "fan")

## ----tree_scaling, fig.dim = c(10, 4)-----------------------------------------
moss_tree <- read.tree(system.file("extdata", "moss_tree.nex", package = "phylospatial"))
tree_01 <- rescale_tree(moss_tree, "tip1")
tree_deep <- slice_tree(tree_01, min = 0, max = 0.5, from = "root")
tree_shallow <- slice_tree(tree_01, min = 0, max = 0.5, from = "tips")
tree_clado <- uniform_tree(moss_tree)

par(mfrow = c(1, 4), mar = c(2, 1, 2, 1))
plot(moss_tree, show.tip.label = FALSE, main = "original")
plot(tree_shallow, show.tip.label = FALSE, main = "sliced (recent)")
plot(tree_deep, show.tip.label = FALSE, main = "sliced (ancient)")
plot(tree_clado, show.tip.label = FALSE, main = "cladogram")

