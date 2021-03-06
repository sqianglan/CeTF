#' @title Partial Correlation and Information Theory (PCIT) analysis
#'
#' @description The PCIT algorithm is used for reconstruction of gene co-expression
#' networks (GCN) that combines the concept partial correlation coefficient
#' with information theory to identify significant gene to gene associations
#' defining edges in the reconstruction of GCN.
#'
#' @param input A correlation matrix.
#' @param tolType Type of tolerance (default: 'mean') given the 3 pairwise correlations
#' (see \code{\link{tolerance}})
#'
#' @return Returns an list with the significant correlations, raw adjacency matrix
#' and significant adjacency matrix.
#'
#' @examples
#' # loading a simulated normalized data
#' data('simNorm')
#'
#' # getting the PCIT results for first 30 genes
#' results <- PCIT(simNorm[1:30, ])
#'
#' # printing PCIT output first 15 rows
#' head(results$tab, 15)
#'
#' @references
#' REVERTER, Antonio; CHAN, Eva KF. Combining partial correlation and
#' an information theory approach to the reversed engineering of gene
#' co-expression networks. Bioinformatics, v. 24, n. 21, p. 2491-2497, 2008.
#' \url{https://academic.oup.com/bioinformatics/article/24/21/2491/192682}
#'
#' @importFrom reshape2 melt
#' @importFrom stats cor
#' @importFrom crayon green
#'
#' @export
PCIT <- function(input, tolType = "mean") {
    if (!is.data.frame(input) & !is.matrix(input)) {
        stop("input must be a dataframe or a matrix")
    }
    "/" <- function(x, y) ifelse(y == 0, 0, base::"/"(x, y))
    
    message(green("######################################" %+% "\n" %+% 
        sprintf("Number of genes                 =  %s", nrow(input)) %+% 
        "\n" %+% sprintf("Number of samples in condition  =  %s", ncol(input)) %+% 
        "\n" %+% "######################################" %+% "\n"))
    
    suppressWarnings(gene_corr <- cor(t(input)))
    gene_corr[is.na(gene_corr)] <- 0
    
    gene_pcorr <- gene_corr
    gene_pcorr2 <- gene_corr
    for (i in seq_len(nrow(gene_pcorr) - 2)) {
        if (i%%10 == 0) {
            message(paste("Trios for gene", i, sep = "    "))
        }
        for (j in (i + 1):(nrow(gene_pcorr) - 1)) {
            for (k in (j + 1):nrow(gene_pcorr)) {
                rxy <- gene_pcorr[i, j]
                rxz <- gene_pcorr[i, k]
                ryz <- gene_pcorr[j, k]
                
                tol <- tolerance(rxy, rxz, ryz, tolType = tolType)
                
                if (abs(rxy) < abs(rxz * tol) & abs(rxy) < abs(ryz * tol)) {
                  gene_pcorr2[i, j] <- gene_pcorr2[j, i] <- 0
                }
                if (abs(rxz) < abs(rxy * tol) & abs(rxz) < abs(ryz * tol)) {
                  gene_pcorr2[i, k] <- gene_pcorr2[k, i] <- 0
                }
                if (abs(ryz) < abs(rxy * tol) & abs(ryz) < abs(rxz * tol)) {
                  gene_pcorr2[j, k] <- gene_pcorr2[k, j] <- 0
                }
            }
        }
    }
    
    gene_corr <- melt(gene_corr)
    gene_corr <- gene_corr[duplicated(t(apply(gene_corr, 1, sort))), ]
    rownames(gene_corr) <- paste(gene_corr$Var1, gene_corr$Var2, sep = "_")
    gene_corr <- gene_corr[order(gene_corr$Var1), ]
    
    tmp1 <- melt(gene_pcorr2)
    rownames(tmp1) <- paste(tmp1$Var1, tmp1$Var2, sep = "_")
    tmp1 <- tmp1[rownames(gene_corr), ]
    
    out <- data.frame(gene1 = gene_corr$Var1, gene2 = gene_corr$Var2, corr1 = round(gene_corr$value, 
        5), corr2 = round(tmp1$value, 5), stringsAsFactors = FALSE)
    
    return(list(tab = out, adj_raw = gene_pcorr, adj_sig = gene_pcorr2))
}
