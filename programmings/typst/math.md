# Math

## Usage

```
# ベクトル
vec(x,y)

# 行列
mat(a,b; c,d)

# sin,cos
sin (alpha + beta)
cos (theta)

# 絶対値
abs(a)

# 分数
frac(a,b)
```

## Symbol

* `brace.{l,r}`: 波括弧
* `theta`
* `<=>`: 合同


## Alignment

* `&`をつけるとそこがalignment pointになる
* `&&` のように複数もできるっぽい?

```typst
$ abs(a) &= n \ 
  abs(a) &< n \
  abs(a) &> n 
$
```
