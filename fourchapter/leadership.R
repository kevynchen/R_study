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

#变量的重编码
leadership$age[leadership$age == 99] <- NA
leadership$agecat[leadership$age > 75] <- "Elder"
leadership$agecat[leadership$age >= 55 & leadership$age <= 75] <- "Middle Aged"
leadership$agecat[leadership$age < 55] <- "Young"

#紧凑的重编码
# leadership <- within(leadership,{
#   agecat <- NA
#   agecat[age > 75] <- "Elder"
#   agecat[age >= 55 & age <= 75] <- "Middle Aged"
#   agecat[age < 55] <- "Young"
# })

#变量的重命名
#fix(leadership)
#names(leadership)[2] <- "testdate"
#names(leadership)[6:10] <- c("item1","item2","item3","item4","item5")

#缺失值
is.na(leadership[,6:10])
newdata <- na.omit(leadership)

today <- Sys.Date()
format(today,format="%B %d %Y")
format(today,format="%B")

#日期值的转换
myformat <- "%m/%d/%Y"
leadership$testdate <- as.Date(leadership$testdate,myformat)

#日期的算数运算
startdate <- as.Date("1995-10-08")
enddate <- as.Date("2017-04-24")
days <- enddate - startdate
difftime(enddate,startdate,units = "weeks")
difftime(enddate,startdate,units = "hours")
dob <- as.Date("1956-10-12")
format(dob,format="%A")

#我多大了
startdate <- as.Date("1995-10-08")
enddate <- Sys.Date()
days <- enddate - startdate
weeks <- difftime(enddate,startdate,units = "weeks")
hours <- difftime(enddate,startdate,units = "hours")

#将日期转换为字符型变量
strDates <- as.character(date)

#数据排序
# attach(leadership)
# newdata <- leadership[order(gender,age),]
# detach(leadership)
# 
# attach(leadership)
# newdata <- leadership[order(gender,-age),]
# detach(leadership)
newdata <- leadership[order(leadership$gender,leadership$age),]

#数据集取子集
newdata <- leadership[,c(6:10)]

#数据集取子集（剔除变量）
myvars <- names(leadership) %in% c("q3","q4")
newdata <- leadership[!myvars]
#注意这里的leadership后面是[]这种符号而不是()号

#选入观测(即选入行)
newdata <- leadership[c(1:3),]

newdata <- leadership[leadership$age > 30 & leadership$gender == "M",]

attach(leadership)
newdata <- leadership[age > 30 & gender== "M",]
detach(leadership)

#选取09年1月1日至09年12月
leadership$date <- as.Date(leadership$date,"%m/%d/%y")
startdate <- as.Date("2009-01-01")
enddate <- as.Date("2009-10-31")
newdata <- leadership[leadership$date >= startdate & leadership$date <= enddate,]

#subset函数
newdata <- subset(leadership,age >= 35 | age < 24,select = c("q1","q2","q3","q4"))
newdata <- subset(leadership, gender == "M" & age > 25,select = gender:q4)

#样本选取
mysample <- leadership[sample(1:nrow(leadership),3,replace = FALSE),]







