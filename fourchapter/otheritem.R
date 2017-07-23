#缺失值
y <- c(1,2,3,NA)
is.na(y)

#在分析中排除缺失值
x <- c(1,2,3,NA)
y <- x[1] + x[2] + x[3] + x[4]
z <- sum(x,na.rm = TRUE)

x <- as.character(x)

