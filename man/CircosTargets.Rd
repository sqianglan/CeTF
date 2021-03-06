% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CircosTargets.R
\name{CircosTargets}
\alias{CircosTargets}
\title{Circos plot for the Transcription Factors/genes targets.}
\usage{
CircosTargets(object, file, nomenclature, selection, cond)
}
\arguments{
\item{object}{CeTF class object resulted from \code{\link{runAnalysis}} 
function.}

\item{file}{GTF file or path.}

\item{nomenclature}{Gene nomenclature: \emph{SYMBOL} or \emph{ENSEMBL.}}

\item{selection}{Specify a single or up to 4 TF/gene to be visualized for.}

\item{cond}{The options are \emph{condition1} or \emph{condition2} based on
the conditions previously defined in \code{\link{runAnalysis}} function.}
}
\value{
Returns an plot with a specific(s) TF/gene and its targets in order
to visualize the chromosome location of each one.
}
\description{
Generate an plot for Transcription Targets (TFs) or any gene 
targets. This plot consists of sorting all the chromosomes of any specie
based in GTF annotation file and showing how the selected TF(s)/gene(s) 
targets are distributed. If a target is connected to the same chromosome as 
the selected one so the connection is defined as \emph{cis}, otherwise it is
a \emph{trans} connection.
}
\details{
The black links are between different chromosomes while the red 
links are between the same chromosome.
}
\examples{
\dontrun{
CircosTargets(object = out, 
file = '/path/to/gtf/specie.gtf', 
nomenclature = 'SYMBOL', 
selection = 'TCF4', 
cond = 'condition1')
}

}
