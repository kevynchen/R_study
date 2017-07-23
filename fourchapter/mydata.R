mydata <- data.frame(x1= c(2,2,6,4),x2= c(3,4,2,8))
#mydata$sumx <- mydata$x1 + mydata$x2
#mydata$meanx <- (mydata$x1 +mydata$x2) /2

#第二种方法
# attach(mydata)
# mydata$sumx <- x1 + x2
# mydata$meanx <- (x1 + x2) /2
# detach(mydata)

#第三种方法
mydata <- transform(mydata,sumx = x1 + x2, 
                    meanx = (x1 + x2)/2)


