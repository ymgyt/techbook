# Visualization

dataのvisualization関連。

## Plotting functions

### 関数をplotする

```R
library(ggplot2)

# provide dummy dataset
p <- ggplot(data = data.frame(x = 0), mapping = aes(x = x))

# define function
fun.1 <- function(x) x^2 + x

# minimum setting
p + stat_function(fun = fun.1) + xlim(-5,5)
```

### 複数の関数をplotする

```R
library(ggplot2)

# define functions
fun.1 <- function(x) x^2
fun.2 <- function(x) (x - 2)^2
fun.3 <- function(x) (x - 2)^2 + 3

# base
base <- ggplot(data.frame(x = c(-5, 5)), aes(x))

base + 
  stat_function(fun = fun.1, color = "red") + 
  stat_function(fun = fun.2, color = "blue") + 
  stat_function(fun = fun.3, color = "green")
```

### 二項分布をplotする

```R
library(ggplot2)

x1 <- 0:10
df <- data.frame(x = x1, y = dbinom(x1, size = 10, prob = 0.5))

ggplot(data = df, aes(x = x, y = y)) + geom_bar(stat = "identity")
```

### 正規分布をplotする

`tibble`でdataframeを作成してそれをplotしている。  

```R
library(tidyverse)

dat <-
  tibble(x = rnorm(n = 10000, mean = 0, sd = 1))

dat %>%
  ggplot(aes(x = x, y = ..density..)) +
  geom_histogram(bins = 50)
```

## 参考

* The Layered Grammar of Graphics  
  http://vita.had.co.nz/papers/layered-grammar.pdf
