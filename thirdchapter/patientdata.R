patientID <- c(1,2,3,4)
name <- c("猴子","李同","王五","张三")
age <- c("29","34","28","54")
diabetes <- c("1型糖尿病","2型糖尿病","1型糖尿病","2型糖尿病")
status <- c("poor","improved","excellent","poor")
patientdata <- data.frame(patientID,name,age,diabetes,status)

#患有1型糖尿病的人数
type1 <- patientdata[patientdata$diabetes == "1型糖尿病",]
type1number <- nrow(type1)

#增加行(观测)数据
patientID <- c(5)
name <- "王思聪"
age <- "35"
diabetes <- "1型糖尿病"
status <- "poor"
newPatient <- data.frame(patientID,name,age,diabetes,status,stringsAsFactors = FALSE)

patientdata <- rbind(patientdata,newPatient)

#增加入院时间(列的变量)
inTime <- c("2015-03-01","2015-05-31","2016-07-26","2017-02-01","2015-03-04")
patientdata <- cbind(patientdata,inTime)

# barplot(patientdata[,"age"],main = "病人年龄分布",ylab = "姓名",
#         col=c("lightblue",
#               border=NA,cex.lab=1.5,las=2))
# 
# plot(patientdata,main = "病人年龄分布",ylab = "姓名")

#列表的使用
patientNumber <- nrow(patientdata)
type1 <- patientdata[patientdata$diabetes == "1型糖尿病",]
type1number <- nrow(type1)
kpi <- list(patientNumber=patientNumber,type1number=type1number)
type1.number <- kpi[["type1number"]]



