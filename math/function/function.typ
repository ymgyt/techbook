= 関数

== 2次関数

2次関数を$y = a(x-p)^2 + q$で表すことを考える。\
$a > 0$の場合、$(x-p)^2$は必ず0以上なので、$(x-p)$が0の時、yは最小値、qとなる。\
$a < 0$の場合、$(x-p)$が0の時、yは最大値,qとなる\
$(x-p)$は$x = p$のとき0になるので、2次関数を$y = a(x-p)^2 + q$で表せる時、その頂点は$(p,q)$となる

=== 平方完成

2次関数を$y = a(x-p)^2 + q$で表現できると頂点の情報がえられる。\
そこで、一般的な2次関数$y = a x^2 + b x + c$を上記の形に変換する方法を考える。これを平方完成という。

$ y &= a x^2 + b x + c \
  y &= a ( x^2 + frac(b,a) x ) + c \
  y &= a ((x + frac(b,2a))^2 - frac(b^2, 4 a^2)) + c \
  y &= a (x + frac(b,2a))^2 - frac(b^2, 4a) + c \
  y &= a (x + frac(b,2a))^2 + frac(-b^2 + 4 a c, 4a) \
  y &= a (x - (- frac(b, 2a))) ^2 + frac(-b^2 + 4 a c, 4a)
$

したがって、2次関数$y = a x^2 + b x + c$の頂点は\
$(- frac(b,2a), frac(-b^2 + 4 a c, 4a))$となる。 \
なお、3次関数以上はどうするかというと、微分する。

=== 解の公式

$
 a x^2 + b x + c &= 0  wide &"(ただし "a != 0")" \
 a (x^2 + frac(b,a) x) + c &= 0 wide &"(aでくくる)"\
 a ((x + frac(b,2a))^2 - frac(b^2, 4a^2)) + c &= 0 \
 a (x + frac(b,2thin a))^2 - frac(b^2,4a) + c &= 0 wide &"(aを分配)" \
 a (x + frac(b,2a))^2 + frac(-b^2+4 a c, 4a) &= 0 \
 a (x + frac(b,2a))^2 &= - frac(-b^2+4 a c, 4a)  \
   (x + frac(b,2a))^2 &= - frac(-b^2+4 a c, 4a^2)  \
   (x + frac(b,2a))^2 &= frac(b^2-4 a c, 4a^2)  \
   sqrt((x + frac(b,2a))^2) &= sqrt(frac(b^2-4 a c, 4a^2)) wide &"(両辺のrootをとる)" \
   sqrt((x + frac(b,2a))^2) &= frac(sqrt(b^2-4 a c), sqrt(4a^2)) wide & (sqrt(frac(a,b)) = frac(sqrt(a),sqrt(b))) \
   sqrt((x + frac(b,2a))^2) &= frac(sqrt(b^2-4 a c), 2a) \

  sqrt(A^2) &= abs(A) "より" \
  abs((x + frac(b,2a))) &= frac(sqrt(b^2-4 a c), 2a) \

  (x+frac(b,2a)) &>= 0 "のとき" abs((x+frac(b,2a))) = x+frac(b,2a) & "(絶対値なので場合分けする)" \
  x + frac(b,2a) &= frac(sqrt(b^2-4 a c), 2a) \ 
  x &= - frac(b,2a) + frac(sqrt(b^2-4 a c), 2a) \ 
  x &= frac(-b + sqrt(-b^2+4 a c), 2a) & "(1)" \ 
$
$
  (x+frac(b,2a)) &< 0 "のとき" abs((x+frac(b,2a))) = -(x+frac(b,2a)) &"(絶対値が負の場合)" \
  -(x + frac(b,2a)) &= frac(sqrt(b^2-4 a c), 2a) \ 
  x + frac(b,2a) &= - frac(sqrt(b^2-4 a c), 2a) \ 
  x  &= -frac(b,2a) - frac(sqrt(b^2-4 a c), 2a) \ 
  x &= frac(-b -sqrt(b^2-4 a c), 2a) & "(2)" \ 
  "(1),(2)より " x &= frac(-b +sqrt(b^2-4 a c), 2a) or 
  x = frac(-b -sqrt(b^2-4 a c), 2a) 
$

$
    <=> x &= frac(-b plus.minus sqrt(b^2-4 a c), 2a)
$

