#循环语句
data < 10
for(i in data){
  i <- i-1
}

x <- 10
while(i>0){
  i <- i-1
  print(i)
}

#饭卡提示
card <- 1000
everydayeating <- 3*5
moneyextra <- 1000 %% everydayeating
if(moneyextra >= 5){
  print("你的钱还够花")
}else
{
  print("饭卡钱不够了，去充值吧。")
}

#用户自编函数
mydate <- function(type="long"){
  switch(type,
         long= format(Sys.time(),"%A %B %d %Y"),
         short = format(Sys.time(),"%m-%d-%y"),
         cat(type,"is not a recognized type\n"))
}

mydate("long")
mydate()
mydate("short")
mydate("medium")



