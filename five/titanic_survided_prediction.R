#载入包
library(ggplot2)
library(ggthemes)
library(dplyr)
library(mice)
library(scales)
library(randomForest)


#载入数据
setwd("C:/Users/Kaifan/Documents/R_study/five")
train <- read.csv("train.csv",stringsAsFactors = FALSE)
test <- read.csv("test.csv",stringsAsFactors = FALSE)
data <- bind_rows(train,test)

train.row <- 1:nrow(train)
test.row <- (1+nrow(train)):(nrow(train)+nrow(test))

#数据查看
str(data)

#特征工程之一(名字)
data$title <- gsub('(.*,)|(\\..*)','',data$Name)
#通过性别展示称呼头衔
table(data$Sex,data$title)

#将性别头衔进行整合
rare_title <- c("Capt","Col","Don","Dona","Dr","Jonkheer","Lady","Major","Rev","Sir","the Countess")
data$title[data$title == "Mlle"] <- "Miss"
data$title[data$title == "Ms"] <- "Miss"
data$title[data$title == "Mme"] <- "Mrs"
data$title[data$title %in% rare_title] <- "Rare Title"

#再次通过性别展示头衔
table(data$Sex,data$title)

#分离姓名
data$Surname <- sapply(data$Name,function(x) strsplit(x,split = '[,.]')[[1]][1])
cat(paste('我们有 <b>',nlevels(factor(data$Surname)),'</b> 特别的姓。可能接下来我会
          对这些名字非常感兴趣的'))

#考虑家庭成员间的生存率
data$Fsize <- data$SibSp + data$Parch + 1
data$Family <- paste(data$Surname,data$Fsize,sep = "_")

#可视化家庭成员数量对生存率的影响
ggplot(data[1:891,],aes(x = Fsize,fill=factor(Survived))) +
  geom_bar(stat = 'count',position = 'dodge') +
  scale_x_continuous(breaks = c(1:11)) +
  labs(x='Family Size') +
  theme_few()

#家庭成员数量大小对生存影响的另一种可视化方法
data$FsizeD[data$Fsize == 1] <- "singleton"
data$FsizeD[data$Fsize <5 & data$Fsize >1] <- "small"
data$FsizeD[data$Fsize > 4] <- "large"

mosaicplot(table(data$FsizeD,data$Survived),main = "Family size by Survival",shade = TRUE)

#查看船舱对于生存的影响
data$Cabin[1:28]
strsplit(data$Cabin[2],NULL)[[1]]
data$Deck <- factor(sapply(data$Cabin,function(x) strsplit(x,NULL)[[1]][1]))

#对缺失值进行处理，包括缺失值的替换
#先查看有哪些缺失值
# attach(data)
# missing <- list(Pclass=nrow(data[is.na(Pclass),]))
# missing$Name <- nrow(data[is.na(Name),])
# missing$Sex <- nrow(data[is.na(Sex),])
# missing$Age <- nrow(data[is.na(Age),])
# missing$SibSp <- nrow(data[is.na(SibSp),])
# missing$Parch <- nrow(data[is.na(Parch),])
# missing$Ticket <- nrow(data[is.na(Ticket),])
# missing$Fare <- nrow(data[is.na(Fare),])
# missing$Cabin <- nrow(data[is.na(Cabin),])
# missing$Embarked <- nrow(data[is.na(Embarked),])
# for(name in names(missing)){
#   if(missing[[name]] > 0){
#     print(paste('',name,'missing',missing[[name]][1],'values',sep = ' '))
#   }
# }
# detach(data)
#此种方法查看缺失值较为复杂，且不一定正确，下面这种方法较好
sapply(data,function(x) sum(is.na(x)))
sapply(data,function(x) sum(x == ""))

#把缺失登船港口地址的乘客给去掉
embark_fare <- data %>%
  filter(PassengerId != 62 & PassengerId != 830)
#使用ggplot2函数来组合乘客，其阶层还有费用与生存率的联系
ggplot(embark_fare,aes(x=Embarked,y=Fare,fill=factor(Pclass))) +
  geom_boxplot() + 
  geom_hline(aes(yintercept = 80),colour = 'red',linetype = 'dashed',lwd = 2) +
  scale_y_continuous(labels = dollar_format()) +
  theme_few()

#
data$Embarked[c(62,830)] <- 'C'
#在1044行费用缺失，查看一下具体的数值
data[1044,]
#可视化关于船舱人数的生存率
ggplot(data[data$Pclass == '3' & data$Embarked == 'S',],
       aes(x=Fare)) +
      geom_density(fill = '#99d6ff',alpha=0.4) +
      geom_vline(aes(xintercept=median(Fare,na.rm = TRUE)),
                 colour='red',lintype='dashed',lwd=1) +
      scale_x_continuous(labels = dollar_format()) +
      theme_few()

#填补缺失的船票费
data$Fare[1044] <- median(data[data$Pclass == '3' & data$Embarked == 'S',]$Fare,na.rm = TRUE)

#将其他类型的变量转换为因子类型的变量
factor_vars <- c('PassengerId','Pclass','Sex','Embarked','title',
                 'Surname','Family','FsizeD')
data[factor_vars] <- lapply(data[factor_vars],function(x) as.factor(x))
#设立一个随机种子，删掉一些没有多大用的变量
set.seed(129)
mice_mod <- mice(data[,!names(data) %in% 
                        c("PassengerId","Name","Ticket","Cabin","Family","Surname","Survived")],method = 'rf')
mice_output <- complete(mice_mod)

#
par(mfrow=c(1,2))
hist(data$Age,freq = FALSE,main = 'Age:Origin Data',col = 'darkgreen',ylim = c(0,0.04))
hist(mice_output$Age,freq = FALSE,main = 'Age:Mice Output',col = 'lightgreen',ylim = c(0,0.04))

#补充缺失的年龄值
data$Age <- mice_output$Age
sum(is.na(data$Age))

#查看年龄对生存的影响，区分性别
ggplot(data[1:891,],aes(Age,fill = factor(Survived))) +
  geom_histogram() +
  facet_grid(.~Sex) +
  theme_few()

#对不同的年龄人群进行分类
data$Child[data$Age < 18] <- 'Child'
data$Child[data$Age >= 18] <- 'Adult'
table(data$Child,data$Survived)

data$Mother <- 'Not Mother'
data$Mother[data$Age > 18 & data$Parch > 0 & data$title != 'Miss' & data$Sex == 'female'] <- 'Mother'
table(data$Mother,data$Survived)

data$Child <- factor(data$Child)
data$Mother <- factor(data$Mother)
#
md.pattern(data)

#预测
#分离数据
train <- data[1:891,]
test <- data[892:1309,]
#建立模型
set.seed(754)
rf_model <- randomForest(factor(Survived) ~ Pclass + Sex + Age + SibSp +
                           Parch + Fare + Embarked + title + 
                           FsizeD + Child + Mother,
                         data = train)

plot(rf_model,ylim = c(0,0.36))
legend('topright',colnames(rf_model$err.rate),col = 1:3,fill = 1:3)

#可视化变量的权重
importance <- importance(rf_model)
varImportance <- data.frame(Variables = row.names(importance),
                            Importance = round(importance[,'MeanDecreaseGini'],2))
rankImportance <- varImportance %>%
  mutate(Rank = paste0('#',dense_rank(desc(Importance))))

ggplot(rankImportance,aes(x=reorder(Variables,Importance),y=Importance,fill=Importance)) +
  geom_bar(stat = 'identity') +
  geom_text(aes(x=Variables,y=0.5,label=Rank),hjust = 0,vjust = 0.55,size = 4,col = 'red') +
  labs(x='Variables') +
  coord_flip() +
  theme_few()

#最终预测，得出结论
prediction <- predict(rf_model,test)
solution <- data.frame(PassengerID = test$PassengerId,Survived = prediction)
write.csv(solution,file = 'titannic_survived_prediction.csv',row.names = FALSE)





















