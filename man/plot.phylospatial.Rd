% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/phylospatial-methods.R
\name{plot.phylospatial}
\alias{plot.phylospatial}
\title{Plot a \code{phylospatial} object}
\usage{
\method{plot}{phylospatial}(x, y = c("tree", "comm"), max_taxa = 12, ...)
}
\arguments{
\item{x}{\code{phylospatial} object}

\item{y}{Either \code{"tree"} or \code{"comm"}, indicating which component to plot.}

\item{max_taxa}{Integer giving the maximum number of taxon ranges to plot if \code{y = "tree"}.}

\item{...}{Additional arguments passed to plotting methods, depending on \code{y} and the class
of \code{x$spatial}. For \code{y = "tree"}, see \link[ape]{plot.phylo}; for \code{y = "comm"},
see \link[terra]{plot} or \link[sf]{plot.sf}.}
}
\value{
A plot of the tree or community data.
}
\description{
Plot a \code{phylospatial} object
}
\examples{
ps <- ps_simulate()
plot(ps, "tree")
plot(ps, "comm")
}
