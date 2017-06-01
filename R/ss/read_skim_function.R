read_skim <- function(path, type = c("demand", "time", "distance", "fares", "tolls")) {
    skim <- readr::read_csv(path)
    col <- ncol(skim)
    
    if (col <= 4) {
        stop("Insuffcient Data")
    }
    
    else {
        names_1_3 <- c("orig", "dest", "user_class")
        num_p <- (1:(col - 3))
        tp_names <- lapply(num_p, function(x) {
            paste("tp", x, "_", tolower(type), sep = "")
        })
        names(skim) <- c(names_1_3, unlist(tp_names))
    }
    
    return(skim)
}

