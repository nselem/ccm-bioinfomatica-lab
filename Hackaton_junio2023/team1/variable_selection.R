#-------------------------------------------------------------------------------
# Load libraries via pacman
pacman::p_load(#ggplot2, ggthemes,                     # Plots
               dplyr, tibble, tidyr,                  # Data frame manipulation
               DESeq2, fdrtool)                       # Models
# We can use 
# library(ggplot2)
# library(ggthemes)
# library(dplyr)
# library(tibble)
# library(DESeq2)
# library(fdrtool)

#-------------------------------------------------------------------------------
# Working directory
setwd("~/camda/variable_selection/")

#-------------------------------------------------------------------------------
# differentialOtusPvalues calculates the p-values according to log2-fold change 
# for every pair of cities
# This allows us to decide if an OTU is differentially abundant
# This only works correctly at all hierarchical levels for reads 

differentialOtusPvalues <- function(db) {
    #####
    # Negative Binomial model using DESeq2
    #
    
    # Create DESeqDataSet object
    # We assume that the first column in db gives the OTU ID
    countData <- as.matrix(db[, -1])
    mode(countData) <- "integer"
    transposedData <- t(as.matrix(column_to_rownames(db, var = "X")))
    # Separate by city and year
    sampleLocations <- paste0(
        t(as.data.frame(strsplit(rownames(transposedData),"_")))[,4], 
        str_sub(
            t(as.data.frame(strsplit(rownames(transposedData),"_")))[,3], 
            -2, -1
        ),
        sep = ""
    )
    rownames(countData) <- db[, 1]
    # Create metadata (covariates) for negative binomial regression
    metaData <- data.frame(city = factor(sampleLocations),
                           logNReads = scale(log(colSums(countData))),
                           row.names = colnames(db)[-1])
    deseq <- DESeqDataSetFromMatrix(countData = countData,
                                    colData = metaData,
                                    design = ~ city + offset(logNReads))
    
    # We fit the Negative Binomial model with DESeq2
    deseq <- deseq[rowSums(counts(deseq)) > 0,]
    deseq <- estimateSizeFactors(deseq, type = "poscounts") 
    deseq <- estimateDispersions(deseq)
    deseq <- DESeq(deseq)
    
    locations <- unique(sampleLocations)
    numLocations <- length(locations)
    diffOtusList <- vector("list", numLocations * (numLocations - 1) / 2)
    
    # Compute adjusted p-values for log2-fold changes
    k <- 1
    pValues <- data.frame(OTU = character())
    for (i in 1:(numLocations - 1)) {
        loc1 <- locations[i]
        for (j in (i + 1):numLocations) {
            loc2 <- locations[j]
            tempRes <- results(deseq, contrast = c("city", loc1, loc2))
            # remove filtered out OTUs by independent filtering 
            # they have NA adj. pvals
            tempRes <- tempRes[ !is.na(tempRes$padj),]
            # with NA pvals (outliers)
            tempRes <- tempRes[ !is.na(tempRes$pvalue),]
            
            tempRes <- tempRes[, -which(names(tempRes) == "padj")]
            res_fdr <- fdrtool(tempRes$stat, statistic = "normal", plot = FALSE)
            tempRes[,"padj"] <- p.adjust(res_fdr$pval, method = "BH")
            tempPvalues <- data.frame(
                x = rownames(tempRes),
                y = tempRes$padj
            )
            names(tempPvalues) <- c("OTU", paste0(loc1, "_vs_", loc2))
            pValues <- pValues %>% 
                full_join(tempPvalues, by = join_by(OTU))
            cat(sprintf("%d of %d done\n", k, length(diffOtusList)))
            k <- k + 1
        }
    }
    pValues[is.na(pValues)] <- 1
    return(pValues)
}

#-------------------------------------------------------------------------------
# computePvaluesLevel computes a matrix of p-values for the negative binomial 
# model adjusted by differentialOtusPvalues for the count data of 
# reads for the hierarchical level hLevel
# This function may take into account a set of indices for training 
computePvaluesLevel <- function(hLevel, path_to_counts, reads = TRUE, train = NULL, 
                                path_to_pvalues = NULL) {
    # Test if the count data is for reads or for assembly data
    if (reads) {
        db <- read.csv(paste0(path_to_counts, "reads_count_",
                              hLevel, ".csv"))
    } else {
        db <- read.csv(paste0(path_to_counts, "assembly_count_",
                              hLevel, ".csv"))
    } 
    # Subsetting training data set
    if (is.null(train)) {
        train_db <- db
    } else {
        train_db <- db[, train]
    }
    # compute p-values
    tempPvalues <- differentialOtusPvalues(train_db)
    # Save p-values for further exploratory analysis
    #write.csv(
    #    tempPvalues, 
    #    file = paste0(path_to_pvalues, "train_pvalues_", hLevel, ".csv"), 
    #    row.names = FALSE
    #)
    # Add the level of the p_value
    tempPvalues <- tempPvalues %>% mutate(hlevel = hLevel)
    return(tempPvalues)
}

#-------------------------------------------------------------------------------
# Given a table of p-values, getKOtus gets the k most significant OTUs 
# for each pair of city/year, specifying the hierarchical level of said OTU
getKOtus <- function(db, k) {
    # Put all p-values into a single column, identifying them by the cities 
    # being contrasted
    pValueslong <- db %>% 
        pivot_longer(cols = -c("OTU", "hlevel"), 
                     names_to = "cities", 
                     values_to = "p-value") %>% 
        mutate(city1 = substr(cities, 1, 5), city2 = substr(cities, 10, 15))
    
    # Which comparisons were made
    comparisons <- unique(unlist(pValueslong$cities))
    # Initialize the data frame for the k most significant OTUs per 
    # city vs city contrast
    reducedK <- data.frame(
        OTU = integer(), hlevel = character(), cities = character(), 
        "p-value" = numeric(), city1 = character(), city2 = character(), 
        sign_rank = integer()
    )
    # Get the significant OTus
    for(i in 1:length(comparisons)) {
        tempData <- pValueslong %>% 
            filter(cities == comparisons[i]) %>% 
            arrange(`p-value`) %>% 
            head(n = k) %>% 
            mutate(sign_rank = 1:k)
        reducedK <- reducedK %>% 
            full_join(tempData)
    }
    
    # Add an ID for OTU - class
    reducedK <- reducedK %>% 
        mutate(OtuClass = paste(OTU, hlevel, sep = ""))
    
    return(reducedK)
}

#-------------------------------------------------------------------------------
# Given a list of significant OTUs, construct the integrated sample with only 
# these OTUs. 
constructIntegratedData <- function(sign_otus, path_to_counts, reads = TRUE) {
    hLevels <- unique(sign_otus$hlevel)
    # Initialize a list where the subsetting will be done by taxonomical levels
    dataSubsets <- vector("list", length(hLevels))
    for (i in 1:length(hLevels)) {
        if (reads) {
            tempData <- read.csv(
                paste0(path_to_counts, "reads_count_", hLevels[i], ".csv")
            )
        } else {
            tempData <- read.csv(
                paste0(path_to_counts, "assembly_count_", hLevels[i], ".csv")
            )
        }
        # Subset which significant OTUs correspond to a given taxonomical 
        # level
        tempOTUs <- sign_otus %>%  
            filter(hlevel == hLevels[i])
        # Subset those significant OTUs from the count data 
        dataSubsets[[i]] <- tempData[tempData[, 1] %in% tempOTUs$OTU, ] %>% 
            mutate(hlevel = hLevels[i])
    }
    # Merge all of the subsetted data
    retDF <- dataSubsets[[1]]
    if (length(hLevels) > 1) {
        for (i in 2:length(hLevels)) {
            retDF <- retDF %>% 
                full_join(dataSubsets[[i]])
        }
    }
    # 
    retDF <- retDF %>% 
        mutate(ID = paste0(OTU, hlevel)) %>% 
        dplyr::select(-c("OTU", "hlevel")) %>% 
        relocate(ID)
    return(retDF)
}

#-------------------------------------------------------------------------------
# The function variableSelection implements all of the steps to select a subset 
# of OTUs that allow us to differentiate between cities
variableSelection <- function(hlevels = c("_Phylum", "_Class", "_Order", "_Family", "_Genus"), 
                              path_to_counts, train_cols, kpvalues = 5, reads = TRUE) {
    # Initialize a list to save the matrices of p-values for every run
    pValuesList <- vector("list", length = length(hlevels))
    for (i in 1:length(hlevels)) {
        pValuesList[[i]] <- computePvaluesLevel(
            hlevels[i], path_to_counts, train_cols, reads
        )
    }
    # Merge all of the p-values matrices
    pValues <- pValuesList[[1]]
    if (length(hlevels) > 1) {
        for (i in 2:length(hlevels)) {
            pValues <- pValues %>% 
                full_join(pValuesList[[i]])
        }
    }
    # Given the complete list of p-values, get the k most significant for every 
    # pair of cities
    significantOtus <- getKOtus(pValues, kpvalues)
    # Construct the integrated data with the significant OTUs 
    integratedTable <- constructIntegratedData(significantOtus,
                                               path_to_counts,
                                               reads)
    return(list(pValues, significantOtus, integratedTable))
}

#-------------------------------------------------------------------------------
# Test
path_to_counts <- "~/camda/variable_selection/reads/"
train_test_set <- read.csv("./Train_Test.csv", row.names = 1)
train_cols <- train_test_set$Num_Col[train_test_set$Train == 1]
kpvalues <- 5
hlevels <- c("_Phylum", "_Class", "_Order", "_Family", "_Genus")

smth <- variableSelection(path_to_counts = path_to_counts, 
                          train_cols = train_cols, kpvalues = kpvalues)

#pValuesPh <- read.csv("./pValues/train_pvalues_Phylum.csv", row.names = 1) %>% 
#    mutate(hlevel = "Phylum")
#pValuesCl <- read.csv("./pValues/train_pvalues_Class.csv", row.names = 1) %>% 
#    mutate(hlevel = "Class")
#pValuesOr <- read.csv("./pValues/train_pvalues_Order.csv", row.names = 1) %>% 
#    mutate(hlevel = "Order")
#pValuesFa <- read.csv("./pValues/train_pvalues_Family.csv", row.names = 1) %>% 
#    mutate(hlevel = "Family")
#pValuesGe <- read.csv("./pValues/train_pvalues_Genus.csv", row.names = 1) %>% 
#    mutate(hlevel = "Genus")

#write.csv(
#    integratedTable, 
#    file = "./integrated_sample.csv",
#    row.names = FALSE
#)
