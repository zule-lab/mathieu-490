####PACKAGES####
    #p <- c("tidyverse", "data.table", "anytime")
    #lapply(p, install.packages, character.only = T)
    #install.packages("car")
    #install.packages("AICcmodavg")
    #install.packages("ggplot2")
    #install.packages("epiDisplay")
    #install.packages("ggplot2")
    #install.packages("ggpubr")
    
    library(ggplot2)
    library(ggpubr)
    library("epiDisplay")
    library(AICcmodavg)
    library(car)
    library(tidyverse)
    library(anytime)
    library(data.table)


####DATA INPUT AND CLEAN UP####
buffers <- read.csv("input/buffers.csv")
trees <- read.csv("input/trees_all.csv")
trees[trees==0] <- NA
trees
trees2<-trees[complete.cases(trees),]
trees2


colnames(buffers)[1] <- "buffer_ID" 
colnames(buffers)[6] <- "count" 
colnames(buffers)[7] <- "sum" 
colnames(buffers)[8] <- "low_green" 
colnames(buffers)[9] <- "canopy" 
colnames(buffers)[10] <- "total_green" 


####BUFFERS REGRESSION ANALYSIS####
    #4 regressions included in the model

    regression.canopy <- lm(formula = buffers$mean_temp ~ buffers$canopy)
    print(regression.canopy)
    sum.canopy <- summary(lm(buffers$mean_temp ~ buffers$canopy))
    

    regression.low_green <- lm(formula = buffers$mean_temp ~ buffers$low_green)
    print(regression.low_green)
    summary(lm(buffers$mean_temp ~ buffers$low_green))

    regression.SLA <- lm(formula = buffers$mean_temp ~ buffers$mean_SLA_weighted)
    print(regression.SLA)
    summary(lm(buffers$mean_temp ~ buffers$mean_SLA_weighted))


    regression.shann <- lm(buffers$mean_temp ~ buffers$shann_div)
    summary(regression.shann)

    #full model including the 4 previous regressions

    regression.full <- lm(formula = buffers$mean_temp ~ buffers$mean_SLA_weighted + buffers$canopy 
                          + buffers$low_green + buffers$shann_div)
    print(regression.full)
    summary(regression.full)

    #other stuff

    regression.total_green <- lm(formula = buffers$mean_temp ~ buffers$total_green)
    print(regression.total_green)
    summary(lm(buffers$mean_temp ~ buffers$total_green))
    
    regression.DBH <- lm(formula = buffers$mean_temp ~ buffers$mean_DBH)
    print(regression.DBH)
    summary(lm(buffers$mean_temp ~ buffers$mean_DBH))
    
    
    plot(buffers$mean_temp, buffers$mean_SLA)
    plot(buffers$mean_temp, buffers$mean_SLA_weighted)
    
    
    
    
    regression.null <- lm(buffers$mean_temp ~ 1)
    summary(regression.null)
    
    regression.SLA_canopy <- lm(buffers$mean_temp ~ buffers$mean_SLA_weighted + buffers$canopy)
    summary(regression.SLA_canopy)
    anova(regression.SLA_canopy)
    
    regression.SLA_canopy_int <- lm(buffers$mean_temp ~ buffers$mean_SLA_weighted*buffers$canopy)
    summary(regression.SLA_canopy_int)
    
    
    
    #checking the models. 1 and 6 (canopy and all 3) seem to be the best models, so checking those first
    plot(regression.canopy)
    plot(regression.full)
    #residualPlots(model = regression.full)
    #this doesnt work and idk why
    
    
    
    yhat.1 <- fitted.values( object = regression.canopy )
    plot( x = yhat.1, 
          y = buffers$mean_temp,
          xlab = "Fitted Values",
          ylab = "Observed Values" )
    
    yhat.2 <- fitted.values( object = regression.full )
    plot( x = yhat.2, 
          y = buffers$mean_temp,
          xlab = "Fitted Values",
          ylab = "Observed Values" )

    
####TREES REGRESSION ANALYSES####
    plot(buffers$canopy, buffers$mean_SLA_weighted)
    lm(formula = buffers$canopy ~ buffers$mean_SLA_weighted)
    summary(lm(formula = buffers$canopy ~ buffers$mean_SLA_weighted))
    plot(lm(formula = buffers$canopy ~ buffers$mean_SLA_weighted))
    
    lm(formula = buffers$mean_SLA ~ buffers$mean_DBH)
    plot(buffers$mean_SLA, buffers$mean_DBH)
    summary(lm(formula = buffers$mean_SLA ~ buffers$mean_DBH))
    
    
    ggplot(df, aes(x=mean_SLA, y=mean_DBH)) +
      geom_point(size=2, shape=16) +
      geom_point()+
      geom_smooth(method=lm) 
    
    plot(trees2$SLA, trees2$DBH)
    regression.trees2.SLADBH <- lm(formula = trees2$SLA ~ trees2$DBH)
    summary(regression.trees2.SLADBH)
    plot(regression.trees2.SLADBH)
    
    ggplot(trees2, aes(x=DBH, y=SLA)) +
      geom_point(size=2, shape=16) +
      geom_point()+
      geom_smooth(method=lm) 
    
####BUFFERS MODEL SELECTION####

    #backwards elimination test
    full.model <- lm(formula = buffers$mean_temp ~ buffers$mean_SLA_weighted + buffers$canopy + 
                       buffers$low_green + buffers$shann_div)
    step( object = full.model,     # start at the full model
          direction = "backward"   # allow it remove predictors but not add them
    )
    
    
    #forward selection
    null.model <- lm( buffers$mean_temp ~ 1 )   # intercept only.
    step( object = null.model,     # start with null.model
          direction = "forward",   # only consider "addition" moves
          scope =  buffers$mean_temp ~ buffers$mean_SLA_weighted + buffers$canopy + buffers$low_green  # largest model allowed
    )
    
    
    mods <- list(regression.canopy, regression.low_green, regression.SLA, regression.full, regression.null, regression.SLA_canopy, regression.shann  )
    names(mods) <- c("canopy", "low_green", "SLA", "full", "null", "canopy_SLA", "shannon_div")
    aictab(mods)



####DESCRIPTIVES####
    summary(trees2$SLA)
    summary(trees2$SLA_weighted)
    summary(trees2$DBH)
    tab1(trees2$Functional_Group, sort.group = "decreasing", cum.percent = TRUE)
    
    tab1(trees2$ESSENCE_ANG, sort.group = "decreasing", cum.percent = TRUE)
    trees2_unique <- unique(trees2$SIGLE)
    length(trees2_unique)
    
    summary(buffers)
    
    se <- function(x) sd(x)/sqrt(length(x))
    se(buffers$canopy)
    se(buffers$low_green)
    se(buffers$mean_DBH)
    se(buffers$mean_temp)
    length(buffers$mean_temp)
####REGRESSION PLOTS####
    
    df <- data.frame(buffers)
    
    
    canopy.plot <- ggplot(df, aes(x=canopy, y=mean_temp)) +
      geom_point(size=2, shape=16) +
      geom_point()+
      geom_smooth(method=lm) +
      ylab("Mean Temperature (°C)") +
      xlab("Canopy Cover")+
      labs(tag = "A")+
      theme(text = element_text(size=16))
    
    canopy.plot
    
    SLA.plot <- ggplot(df, aes(x=mean_SLA_weighted, y=mean_temp)) +
      geom_point(size=2, shape=16) +
      geom_point()+
      geom_smooth(method=lm) +
      ylab("") +
      xlab("Mean weighted SLA")+
      labs(tag = "B")+
      theme(text = element_text(size=16))
    SLA.plot
    
    green.plot <- ggplot(df, aes(x=low_green, y=mean_temp)) +
      geom_point(size=2, shape=16)+
      ylab("Mean Temperature (°C)") +
      xlab("Low Green Cover")+
      labs(tag = "C")+
      theme(text = element_text(size=16))
    green.plot
    
    shann.plot <- ggplot(df, aes(x=shann_div, y=mean_temp)) +
      geom_point(size=2, shape=16)+
      ylab("") +
      xlab("Shannon Diversity") +
      labs(tag = "D")+
      theme(text = element_text(size=16))
    shann.plot
    
    
    ggarrange(canopy.plot, SLA.plot, green.plot, shann.plot)
    
    
    
    
    