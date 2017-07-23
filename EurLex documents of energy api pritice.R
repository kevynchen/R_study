#API练习 关于欧洲的某个节食日
library(httr)
library(jsonlite)
library(lubridate)

options(stringsAsFactors = FALSE)

url <- "http://api.epdb.eu"
path <- "eurlex/directory_code"

raw.result <- GET(url = url,path = path)
names(raw.result)

#检查元素的头部等信息
head(raw.result$content)

#把raw类型的转换为字符串的文本
this.raw.content <- rawToChar(raw.result$content)
nchar(this.raw.content)

#查看前100个字符的内容
substr(this.raw.content,1,100)

this.content <- fromJSON(this.raw.content)
this.content[[1]]
this.content[[2]]

#把列表转换成为数据框，以方便对数据进行处理
this.content.df <- do.call(what = 'rbind',args = lapply(this.content,as.data.frame))
class(this.content.df)
head(this.content.df)
dim(this.content.df)

#第二步，获取关于enery的信息，也就是列表里面的列表，
#但是首先得清洗数据，把其他不想关的数据给去掉
headclass <- substr(x = this.content.df[,"directory_code"],start = 1,stop = 2)

#enery==12开头为我们所想要的信息
isenergy <- headclass == "12"
table(isenergy)

relevant.df <- this.content.df[isenergy,]
#再次提取数据，只提取变量diretory_code
relevant.dc <- relevant.df[,"directory_code"]

#第三步：检索能源文件的元数据
#自定义函数来查询请求，关于enery主题的元数据
makequery <- function(classifier){
  this.query <- list(classifier)
  names(this.query) <- "dc"
  return(this.query)
}

#查询请求
queries <- lapply(as.list(relevant.dc),makequery)
this.raw.result <- GET(url = url,path = path,query = queries[[1]])

this.result <- fromJSON(rawToChar(this.raw.result$content))
names(this.result[[1]])
#创造一个新的列表来储存energy的元数据
all.results <- vector(mode = 'list',length = length(relevant.dc))
#利用循环函数来把每一个请求得到的数据都存到列表里
for(i in 1:length(all.results)){
  this.query <- queries[[i]]
  this.raw.answer <- GET(url = url,path = path,query = this.query)
  this.answer <- fromJSON(rawToChar(this.raw.answer$content))
  all.results[[i]] <- this.answer
  message(".",appendLF = FALSE)
  Sys.sleep(time = 1)
}

#继续数据预处理（只选取变量form,date_document,of_effect）
#变量选取函数
parseAnswer <- function(answer){
  this.form <- answer$form
  this.date <- answer$date
  this.effect <- answer$of_effect
  result <- data.frame(form = this.form,date = this.date,effect = this.effect)
  return(result)
}

#查看第一个classifier的第二篇文章
parseAnswer(all.results[[1]][[2]])

#对所有的results应用parseAnswer函数
parseAnswerS <- lapply(all.results,function(x) do.call(what = "rbind",lapply(x,parseAnswer)))
class(parseAnswerS)
length(parseAnswerS)
sapply(parseAnswerS,nrow)

#把所有的parseAnswer数据合并到一个数据框(这时parseAnswers仍然为一个列表)
final.results <- do.call("rbind",parseAnswerS)
class(final.results)

#对日期进行转换，以及得出最后的结论
final.results$date <- ymd(final.results$date)
final.results$effect <- ymd(final.results$effect)

#
final.results$effectday <- wday(final.results$effect,label = TRUE)
table(final.results$effectday)





























