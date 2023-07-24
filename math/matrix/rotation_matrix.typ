== 回転行列

$f vec(x,y)$を座標$vec(x,y)$を$theta$回転させる変換とする。 \
このとき変換$f$を表現行列で表したい。\
変換は$f vec(1,0), f vec(0,1)$が決まれば、定まるのでそれぞれを回転させることを考える。\

$vec(1,0)$を$theta$回転させると、定義より \
$ f vec(1,0) = vec(cos theta, sin theta) $

$vec(0,1)$の$theta$回転は、$vec(1,0)$の$theta + 90 degree$とみなせるので \

$ f vec(0,1) 
	&= vec(cos (theta + 90 degree), sin (theta + 90 degree)) \
	&= vec(- sin theta, cos theta)
$

よって \

$ f vec(x,y) = mat(cos theta, - sin theta; sin theta, cos theta) vec(x,y) $


=== 回転行列を利用した加法定理の証明

回転行列を用いて、加法定理が証明できる。\ 
$(alpha + beta)$回転させる変換は、$alpha$回転させたのち、$beta$回線させる変換と等しいと仮定する。\
すると、このことは以下の式で表現できる。  

$ mat(cos (alpha + beta), - sin(alpha + beta); sin(alpha + beta), cos(alpha + beta))
	&= mat(cos beta, - sin beta; sin beta, cos beta) mat(cos alpha, - sin alpha; sin alpha, cos alpha) \
	&= mat(
		cos alpha cos beta - sin alpha sin beta, - sin alpha cos beta - cos alpha sin beta;
		sin beta cos alpha + sin alpha cos beta, - sin alpha sin beta + cos alpha cos beta;
	)
$

等しい行列は各成分が等しいので \

$ sin(alpha + beta) &= sin alpha cos beta + cos alpha sin beta \
  cos(alpha + beta) &= cos alpha cos beta - sin alpha sin beta
$
