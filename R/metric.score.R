#' Score metrics
#'
#' This function calculates metric scores based on a Thresholds data frame.
#' Can generate scores for 1/3/5 (ScoreRegime="135") or 0-100 (ScoreRegime="100").
#
#' @param MetricName metric abbreviation
#' @param MetricValue calculated metric value
#' @param IndexName name of index (e.g., MBSS.2005.Bugs)
#' @param IndexRegion relevant bioregion or site class for given index
#' @param Thresh Data frame of Scoring Thresholds (Index.Name, Index.Region, Metric, Direction, Thresh.Lo, Thresh.Hi, ScoreRegime)
#' @return vector of scores
#' @examples
#' ## Load thresholds
#' thresh <- metrics_scoring
#' View(thresh)
#' ## Define Index
#' IndexName <- "MBSS.2005.Bugs"
#'
#' ## Score Single Value
#' MetricName <- "nt_total"
#' MetricValue <- 18
#' IndexRegion <- "CP"
#' metric.score(MetricName,MetricValue,IndexName,IndexRegion,thresh)
#'
#' ## Score Data Frame of Values
#' # get metrics to score
#' myMetrics <- as.character(droplevels(unique(thresh[thresh[,"Index"]==IndexName,"Metric"])))
#' for (i in myMetrics){##FOR.i.START
#'   i.sc.nam <- paste0("Sc_",i)
#'   i.val <- Metrics.Bugs[,i]
#'   Metrics.Bugs[,i.sc.nam] <- metric.score(i,i.val,Metrics.Bugs$Index,Metrics.Bugs$Region,thresh)
#'   #
#' }##FOR.i.END
#' #
#' ## View Results
#' View(Metrics.Bugs)
##############
#' @export
metric.score <- function(MetricName, MetricValue, IndexName, IndexRegion, Thresh) {##FUNCTION.metric.score.START
  #Define Inputs
  # @param MetricName metric abbreviation
  # @param MetricValue calculated metric value
  # @param IndexName name of scoring regime (e.g., MBSS Fish)
  # @param IndexRegion relevant bioregion or site class for given index
  # @param Thresh Data frame of Scoring Thresholds (Index.Name, Index.Region, Metric, Direction, Thresh.Lo, Thresh.Hi, ScoreRegime)
  #
  #if(missing(myRegion)) {print "Error; Missing 'region'."}
  #if(missing(myValue)) {print "Error; Missing 'value'."}
  #if(missing(myMetric)) {print "Error; Missing 'metric name'."}
  #Set Thresholds

  # call appropriate Thresholds
  #    myThresh <- thresh[thresh[,"Index"]==myIndex & thresh[,"Region"]==myRegion & thresh[,"Metric"]==myMetric,]

  fun.Thresh.myMetric <- Thresh[Thresh[,"Index.Name"]==IndexName & Thresh[,"Index.Region"]==IndexRegion & Thresh[,"Metric"]==MetricName,]
    # QC
    #stopifnot(nrow(fun.Thresh.myMetric)==1)
    if(nrow(fun.Thresh.myMetric)!=1){
      return(0)
      stop
    }
  #
  fun.Lo          <- fun.Thresh.myMetric[,"Thresh.Lo"]
  fun.Hi          <- fun.Thresh.myMetric[,"Thresh.Hi"]
  fun.Direction   <- fun.Thresh.myMetric[,"Direction"]
  fun.ScoreRegime <- fun.Thresh.myMetric[,"ScoreRegime"]

  #########
  # Function
  # default value
  fun.Result <- 0
  #
  if(fun.ScoreRegime=="100"){##IF.0100.START
    if(fun.Direction=="Decrease"){
      fun.Result <- median(c(0,100,100*((fun.Value-fun.Lo)/(fun.Hi-fun.Lo))))
    }else if (fun.Direction=="Increase") {
      fun.Result <- median(c(0,100,100*((fun.Hi-fun.Value)/(fun.Hi-fun.Lo))))
    }
  }else if(fun.ScoreRegime=="135"){
    if(fun.Direction=="Decrease")
      fun.Result <- ifelse(MetricValue>=fun.Hi,5,ifelse(MetricValue<fun.Lo,1,3))
    }else if (fun.Direction=="Increase") {
      fun.Result <- ifelse(MetricValue<=fun.Lo,5,ifelse(MetricValue>fun.Hi,1,3))
  } else if(is.na(fun.ScoreRegime)) {
    fun.Result <- 0
  } else {
    fun.Result <- 0
  }
  #
  return(fun.Result)
  ##################

  # Generate Metrics to Use
  # myMetrics <- droplevels(unique(thresh[thresh[,"Index"]=="MBSS.2005.Bugs","Metric"]))



  #
}##FUNCTION.metric.score.END
