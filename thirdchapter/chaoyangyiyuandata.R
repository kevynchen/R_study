#读入excel数据
library(openxlsx)
library(stringr)
readfilepath <- "G:/程序猿世界/大数据分析/闯关游戏课程《从零学会大数据核心：数据分析》/第3关：简单数据处理和分析/源代码和数据/朝阳医院2016年销售数据.xlsx"
excelData <- read.xlsx(readfilepath,sheet = 1)

#变量重命名
names(excelData) <- c("time","IDcard","drugID","drugname","salenumber","virtualmoney","actualmoney")

#删除所有的缺失行
excelData <- excelData[!is.na(excelData$time),]

#日期的处理
timesplit <- str_split_fixed(excelData$time," ",2)
excelData$time <- timesplit[,1]

excelData$time <- as.Date(excelData$time,"%Y-%m-%d")
class(excelData$time)

#转换数据类型
excelData$salenumber <- as.numeric(excelData$salenumber)
excelData$virtualmoney <- as.numeric(excelData$virtualmoney)
excelData$actualmoney <- as.numeric(excelData$actualmoney)

#日期数据降序排序
excelData <- excelData[order(excelData$time,decreasing = FALSE),]


#指标1：月均消费次数
#总消费次数
kpi1 <- excelData[!duplicated(excelData[,c("time","IDcard")]),]
consumenumber <- nrow(kpi1)

#月份数
startdate <- kpi1$time[1]
enddate <- kpi1$time[nrow(kpi1)]
days <- enddate - startdate
#days <- as.numeric(days)
month <- days %/% 30

#月均消费次数
monthconsume <- consumenumber %/% month

#指标2：月均消费金额
totalmoney <- sum(excelData$actualmoney,na.rm = TRUE)
monthmoney <- totalmoney %/% month

#指标3：客单价
everyone_price <- totalmoney %/% consumenumber

#指标4：消费趋势
week <- tapply(excelData$actualmoney,format(excelData$time,"%Y-%U"),sum)

#plot每周消费金额趋势图
week <- as.data.frame.table(week)
names(week) <- c("time","actualmoney")

week$time <- as.character(week$time)
week$timenumber <- c(1:nrow(week))

plot(week$timenumber,week$actualmoney,xlab = "时间-年份（第几周）",ylab = "消费金额",xaxt = "n",
     main = "2016年朝阳医院消费曲线",
     col = "blue",
     type = "b")

axis(1,at=week$timenumber,labels = week$time,cex.axis=1.5)












