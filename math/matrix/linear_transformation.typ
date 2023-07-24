== 線形変換の表現行列

線形変換 $f$ がどのような変換かは行列で表現できる。 \
座標 $vec(x,y)$ の変換を考える。\

$ f vec(x,y)
	&= f brace.l vec(x,0) + vec(0,y)     brace.r \
	&= f brace.l x vec(1,0) + y vec(0,1) brace.r \
	&= f x vec(1,0) + f y vec(0,1)	("線形性")   \
	&= x f vec(1,0) + y f vec(0,1) $

と表せる。\
したがって、$f vec(1,0)$と$f vec(0,1)$が決まれば$f vec(x,y)$も決まる。\
ここで \
$  f vec(1,0) = vec(a,c), f vec(0,1) = vec(b,d)  $


と仮定する。すると

$ f vec(x,y)
	&= x f vec(1,0) + y f vec(0,1) \
	&= x vec(a,c) + y vec(b,d) \
	&= vec(a x, c x) + vec(b y, d y) \
	&= vec(a x + b y, c x + d y) \
	&= mat(
		a, b;
		c, d;
	) vec(x,y) $

よって \
$ f vec(1,0) = vec(a,c), f vec(0,1) = vec(b,d) $ の場合、線形変換$f$は行列を用いて以下のように表せる。
$ f vec(x,y) = mat(a,b; c,d;) vec(x,y) $

