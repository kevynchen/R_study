manager <- c(1,2,3,4,5)
date <- c("10/24/08","10/28/08","10/1/08","10/12/08","5/1/09")
country <- c("US","US","UK","UK","UK")
gender <- c("M","F","F","M","F")
age <- c(32,45,25,39,99)
q1 <- c(5,3,3,3,2)
q2 <- c(4,5,5,3,2)
q3 <- c(5,2,5,4,1)
q4 <- c(5,5,5,NA,2)
q5 <- c(5,5,2,NA,1)
leadership <- data.frame(manager,date,country,gender,age,q1,q2,q3,q4,q5,stringsAsFactors = FALSE)

# #数据排序
# attach(leadership)
# newdata <- leadership[order(gender,age),]
# detach(leadership)
# 
# attach(leadership)
# newdata <- leadership[order(gender,-age),]
# detach(leadership)

#保留变量
newdata <- leadership[,c(6:10)]

#剔除变量
myvars <- names(leadership) %in% c("q3","q4")
newdata <- leadership[!myvars]

newdata_01 <- leadership[c(-8,-9)]

#选入观测
newdata_02 <- leadership[leadership$gender == "M" & leadership$age > 30,]

leadership$date <- as.Date(leadership$date,"%m/%d/%y")

startdate <- as.Date("2009-01-01")
enddate <- as.Date("2009-12-31")

newdata_03 <- leadership[leadership$date >= startdate & leadership$date < enddate,]

#随机抽样
mysample <- leadership[sample(1:nrow(leadership),3,replace = FALSE),]



