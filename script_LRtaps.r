library(GenomicAlignments)
library(Rsamtools)
library(seqTools)
library(RColorBrewer)
library(stringr)
library(dplyr)
library(zoo)

cmd.help <- function() {
  cat("\nUsage: ")
  cat("-b BAM (alignment files)")
  cat("-l filter reads by alignment length ")
  cat("-a CG position in the reference (0-based)") 
  cat("\n## methylation on Long reads\n")
  cat("\n")
}

##### Functions #####
parseArgs <- function(args, manditories) {
  if (length(args) %% 2 == 1 || length(args) == 0) {
    cat('Unpaired argument and value.\n')
    return(NULL)
  }
  n.i <- seq(1, length(args), by = 2)
  v.i <- seq(2, length(args), by = 2)
  args.name <- args[n.i]
  args.value <- args[v.i]
  
  # Check if required argument values are supplied.
  miss_tag <- F
  man.bool <- manditories %in% args.name
  if (!all(man.bool)) {
    cat(paste(
      'Missing argument: ',
      paste(manditories[!man.bool],
            collapse = ','),
      '.',
      sep = ''
    ))
    miss_tag <- T
  }
  if (miss_tag) {
    res <- NULL
  } else{
    res <- args.value
    names(res) <- args.name
  }
  res
}


.unlist <- function (x) {
  ## do.call(c, ...) coerces factor to integer, which is undesired
  x1 <- x[[1L]]
  if (is.factor(x1)) {
    structure(unlist(x), class = "factor", levels = levels(x1))
  } else {
    do.call(c, x)
  }
}

cigar2df <- function(cigar){
  # create dataframe for cigar
  #
  # Args:
  #   cigar: CIGAR string, the cigar should only contain M/D/I/S
  #
  # Returns:
  #   cigarDf: shown as following
  
  #   cigar: "18S19M2D2M2I39M"
  #   cigarDf:
  #   start end width ops
  #        1  18    18   S
  #       19  37    19   M
  #       38  37     2   D
  #       38  39     2   M
  #       40  41     2   I
  #       42  80    39   M
  cigarDf <- cigarRangesAlongQuerySpace(cigar)[[1]] %>% as.data.frame()
  cigarDf$ops <- strsplit(cigar, "[0-9]+")[[1]][-1]
  nums <- strsplit(cigar, "[A-Z,=]+")[[1]] %>% as.numeric()
  cigarDf[cigarDf$ops == "D", 3] <- nums[cigarDf$ops == "D"]
  return(cigarDf)
}

readConvert <- function(cigar, inseq) {
  # Extract alignment sequence based on cigar
  #
  # Args:
  #   cigar: CIGAR string, the cigar should only contain M/D/I/S
  #   inseq: Segment sequence
  #
  # Returns:
  #   outseq: the cigar-I/S sub-sequence was removed from original sequence, 
  #           while cigar-D was replaced with D and cigar-M was keeped.
  
  # create cigar dataframe
  cigarDf <- cigar2df(cigar)
  # extract sequence based on cigar
  outseq <- c("")
  for (i in 1:nrow(cigarDf)) {
    if (cigarDf$ops[i] == "M") {
      seqtmp <- substring(inseq, cigarDf$start[i], cigarDf$end[i])
      outseq <- c(outseq, seqtmp)
    } else if (cigarDf$ops[i] == "D") {
      seqtmp <- rep("D", cigarDf$width[i])
      outseq <- c(outseq, seqtmp)
    } else if (cigarDf$ops[i] == "I") {
      outseq <- c(outseq)
    } else if (cigarDf$ops[i] == "S") {
      outseq <- c(outseq)
    } else
      cat("unknown character in cigar")
  }
  outseq <- paste(outseq, collapse = "")
  return(outseq)
}

qualConvert <- function(cigar, inqual) {
  # Extract alignment quality based on cigar
  #
  # Args:
  #   cigar: CIGAR string, the cigar should only contain M/D/I/S
  #   inqual: ASCII of base QUALity plus 33
  #
  # Returns:
  #   outqual: the cigar-I/S sub-sequence was removed from original sequence, 
  #           while cigar-D was replaced with D and cigar-M was keeped.
  
  # create cigar dataframe
  cigarDf <- cigar2df(cigar)
  
  # extract quality based on cigar
  outqual <- c("")
  for (i in 1:nrow(cigarDf)) {
    if (cigarDf$ops[i] == "M") {
      seqtmp <- substring(inqual, cigarDf$start[i], cigarDf$end[i])
      outqual <- c(outqual, seqtmp)
    } else if (cigarDf$ops[i] == "D") {
      seqtmp <- rep("!", cigarDf$width[i])
      outqual <- c(outqual, seqtmp)
    } else if (cigarDf$ops[i] == "I") {
      outqual <- c(outqual)
    } else if (cigarDf$ops[i] == "S") {
      outqual <- c(outqual)
    } else
      cat("unknown character in cigar")
  }
  outqual <- paste(outqual, collapse = "")
  return(outqual)
}

char2minPred <- function(x) {
  # Convert ASCII quality to numeric quality
  # Args:
  #   x: ASCII quality
  # Returns:
  #   qual: numeric quality
  
  qual <- char2ascii(x) %>% min() - 33
  return(qual)
}

insertPos <- function(cigar, leftmost) {
  # Extract position of insertion
  #
  # Args:
  #   leftmost: leftmost of the read; POS in bam
  #   cigar: CIGAR string
  # 
  # Returns:
  #   a string with insertion position seperated by comma
  #
  
  # get insertion position in the read
  cigar <-
    gsub("[0-9]*I", ",", gsub("[0-9]*[S,H]", "", gsub("M|D", "+", cigar))) 
  cigars <- gsub("\\+$", "", unlist(strsplit(cigar, ",")))
  ipos <- c()
  for (i in cigars) {
    ipos <- c(ipos, eval(parse(text = i)))
  }
  # get insertion position in the genome
  ipos <- cumsum(ipos) + as.numeric(leftmost)
  ipos <- paste0(" ", toString(ipos), ",")
  return(ipos)
}

bamCallMeth <- function(bam_df, sellen, allc, outfix, bq = 13) {
  # Calculate methylation for each CpG group
  #
  # Args:
  #   bam_df: dataframe form scanbam
  #   sellen: filter the alignment by length
  #   allc: CG position in the genome (0-based)
  #   outfix: prefix of the output file
  #   bq: base quality
  #
  # Write output table:
  #   CG.meth.xls: The methylation level for each CpG group.
  #   read.CG.details.xls: The CpG information in each read.
  
  # Get alignment length with cigar
  bam_df$len <-
    sapply(parse(text = paste0(gsub(
      "[0-9]*[S,H,I]", "", gsub("M|D", "+", bam_df$cigar)
    ), "-1")) , eval)  # S/H/I doesn't consume genome; while M/D consume genome.
  
  # Get position of insertion
  bam_df$ins <-
    apply(bam_df[, c(5, 8)], 1, function(x) {
      insertPos(leftmost = x[1], cigar = x[2])
    })
  
  # Filter read by flag and alignment length
  bam_df_sel <- bam_df[(bam_df$flag == 0 | bam_df$flag == 16) &
             bam_df$len > sellen, ]
  reads <- bam_df_sel[, c(1, 5, 8, 12, 13)]
  reads[, 4] <- reads[, 4] %>% as.character()
  reads[, 5] <- reads[, 5] %>% as.character()
  colnames(reads) <- c("id", "pos", "cigar", "seq", "qual")
  
  # Filter CG based on the read mapping position (not all CG are sequenced)
  allc <- allc[allc > min(bam_df_sel$pos) & 
                 allc < max(bam_df_sel$pos + bam_df_sel$len)]
  
  # Covert sequence according to cigar
  readsConvertOut <-
    apply(reads[, c(3, 4)], 1, function(x)
      readConvert(x[1], x[2])) %>% as.character()
  readsConvertOut <- as.data.frame(readsConvertOut)
  reads$seqCovert <- readsConvertOut$readsConvertOut
  reads$seqCovert <- reads$seqCovert %>% as.character()
  
  # Convert qual according to cigar
  qualConvertOut <-
    apply(reads[, c(3, 5)], 1, function(x)
      qualConvert(x[1], x[2])) %>% as.character()
  qualConvertOut <- as.data.frame(qualConvertOut)
  reads$qualCovert <- qualConvertOut$qualConvertOut
  reads$qualCovert <- reads$qualCovert %>% as.character()
  colnames(reads)[1] <- c("qname")
  
  # compact the converted sequence and convered quality to bam dataframe
  bam_df_sel <- merge(bam_df_sel, reads[, c(1, 6, 7)], by = c("qname"))
  
  # Extract converted read based on position
  for (cpos in allc) {
    # get the relative position in read
    bam_df_sel[, ncol(bam_df_sel) + 1] <- cpos + 1 - bam_df_sel$pos + 1  # cpos is 0-based
    colnames(bam_df_sel)[ncol(bam_df_sel)] <- paste0("pos", cpos) 
    
    # add position sequence into dataframe
    bam_df_sel[, ncol(bam_df_sel) + 1] <- paste(
      paste0("pos", cpos),
      substring(bam_df_sel$seqCovert,
                bam_df_sel[, ncol(bam_df_sel)],
                bam_df_sel[, ncol(bam_df_sel)] + 1),
      sep = ":"
    )
    colnames(bam_df_sel)[ncol(bam_df_sel)] <-
      paste0("pos", cpos, "_seq")
    
    # all position quality into dataframe
    bam_df_sel[, ncol(bam_df_sel) + 1] <- sapply(
        substring(bam_df_sel$qualCovert,
                  bam_df_sel[, (ncol(bam_df_sel) - 1)] ,
                  bam_df_sel[, (ncol(bam_df_sel) - 1)] + 1),
        char2minPred
    )
    colnames(bam_df_sel)[ncol(bam_df_sel)] <-
      paste0("pos", cpos, "_qual")
    
    # add insertion information into dataframe
    bam_df_sel[, ncol(bam_df_sel) + 1] <-
      sapply(bam_df_sel$ins,
             function(x) {
               ifelse(length(grep(paste0(" ", cpos + 2, ","), x)) == 1, "I", "noI")
             })  # cpos is 0-based & need to check insertion in base next to C
    
    colnames(bam_df_sel)[ncol(bam_df_sel)] <-
      paste0("pos", cpos, "_ins")
  }
  # Get methylation level on each base
  mCsta <- NULL
  for (i in grep("pos.*_seq$", colnames(bam_df_sel))) {
    # filter by minimal quality and no insertion
    countalltmp <- bam_df_sel[bam_df_sel[, i + 1] > bq & 
                              bam_df_sel[, i + 2] == "noI", i] 
    countalltmp <- gsub("pos[0-9]*:", "", countalltmp)
    # summarize context in this position
    countall <- countalltmp %>% table() %>% as.data.frame()
    colnames(countall) <- c("cxt")
    # TG & CA means methylation (also possible SNP)
    fwdmC <- ifelse(length(countall[countall$cxt == "TG", 2]) == 0, "0", 
                    countall[countall$cxt == "TG", 2])  %>% as.numeric()
    revmC <- ifelse(length(countall[countall$cxt == "CA", 2]) == 0, "0",
                    countall[countall$cxt == "CA", 2])  %>% as.numeric()
    mC <- fwdmC + revmC
    uC <- ifelse(length(countall[countall$cxt == "CG", 2]) == 0, "0",
                 countall[countall$cxt == "CG", 2])  %>% as.numeric()
    # get methylation ratio
    mCratio <-
      mC / (mC + uC)
    mCratio <-
      ifelse(length(mCratio) == 0, "0", mCratio) %>% as.character() %>% as.numeric()
    mCsta <-
      rbind(mCsta, c(
        gsub("_seq|pos", "", colnames(bam_df_sel)[i]) %>% as.numeric(),
        mCratio,
        mC,
        uC,
        fwdmC,
        revmC
      ))
  }
  mCsta <- mCsta %>% as.data.frame()
  colnames(mCsta) <- c("pos", "mods", "mC", "uC","fwdmC","revmC")
  write.table(
    mCsta[complete.cases(mCsta), ],
    paste0(outfix, ".CG.meth.xls"),
    sep = "\t",
    quote = F,
    row.names = F,
    col.names = T
  )
  write.table(
    bam_df_sel,
    paste0(outfix, ".read.CG.details.xls"),
    sep = "\t",
    quote = F,
    row.names = F,
    col.names = T
  )
}

##### Run program #####

# Input argument parser.
args <- commandArgs(T)
args.tbl <- parseArgs(args, c('-b', '-a', '-l'))
if (is.null(args.tbl)) {
  cmd.help()
  stop('Error in parsing command line arguments. Stop.\n')
}
inputbam <- args.tbl['-b']
cgall <- args.tbl['-a']
sellen <- as.numeric(args.tbl['-l'])

# create bam dataframe 
bam <- scanBam(inputbam)
bam_field <- names(bam[[1]])
list <-
  lapply(bam_field, function(y)
    .unlist(lapply(bam, "[[", y)))
bam_df <- do.call("DataFrame", list)
names(bam_df) <- bam_field
outfix <- gsub(".bam", "", inputbam)

# read CG position
cgall <- read.table(cgall, header = F)
allc <- cgall[, 2]

# run program
bamCallMeth(
  bam_df = bam_df,
  sellen = sellen,
  allc = allc,
  outfix = outfix
)
