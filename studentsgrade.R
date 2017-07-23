# students <- c("John Davis","Angela Williams","Bullwinkle Moose","David Jones","Janice Markhammer",
#               "Cheryl Cushing","Reuven Ytzrhak","Greg Knox","Joel England","Mary Ravburn")
# Math <- c()
library(openxlsx)
readfilepath <- "G:/程序猿世界/大数据分析/学生成绩.xlsx"
gradedata <- read.xlsx(readfilepath,sheet = 1)

#变量重命名
names(gradedata) <- c("student","math","science","english")

#对分数进行标准化
gradedata$math <- as.numeric(gradedata$math)
gradedata$science <- as.numeric(gradedata$science)
gradedata$english <- as.numeric(gradedata$english)
z <- scale(gradedata[,2:4])
score <- apply(z,1,mean)
gradedata <- cbind(gradedata,score)

#求成绩的分位数
y <- quantile(gradedata$score,c(0.8,0.6,0.4,0.2))

#成绩分类
gradedata$rank[gradedata$score >= y[1]] <- "A"
gradedata$rank[gradedata$score < y[1] & gradedata$score >= y[2]] <- "B"
gradedata$rank[gradedata$score < y[2] & gradedata$score >= y[3]] <- "C"
gradedata$rank[gradedata$score < y[3] & gradedata$score >= y[4]] <- "D"
gradedata$rank[gradedata$score < y[4]] <- "F"

#对名字进行处理（排名）
student <- strsplit(gradedata$student," ")
Lastname <- sapply(student,"[",2)
Firstname <- sapply(student,"[",1)

gradedata <- cbind(Firstname,Lastname,gradedata[,-1])

#排序
gradedata <- gradedata[order(Lastname,Firstname),]

#对成绩进行排序
# gradedata$rank <- as.character(gradedata$rank)
# gradedata <- gradedata[order(rank,decreasing = TRUE),]







