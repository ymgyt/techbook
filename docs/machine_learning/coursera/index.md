# Coursera Machine Learning

https://www.coursera.org/learn/machine-learning/home/welcome

## 単語

* Gradient Descent: 最急降下法
* Multivariable Liner Regression: 多変量線形回帰
* Normal Equation: 正規方程式

## octave

`/usr/local/octave/3.8.0/bin/octave`

* [Reference](https://octave.sourceforge.io/docs.php)  
* [ここも参照](https://www.coursera.org/learn/machine-learning/resources/voVNL)

* submitするときは`submit`
* `keyboard`でdebug sessionはいれる。(break point)

```octave
A = [1 2; 3 4; 5 6];

# 1から0.1単位で2までの数列を作る
v = 1:0.1:2

# 要素1/0のN x M行列を作る
ones(N,M)
zeros(N,M)

# identity
eye(N)

# 乱数
rand(N,M)

# help
help eye
help rand

# directory/file
# pwd | cd | ls 

# fileのload
load('path.ext')

# fileへの保存
save <path> <variable>
save xxx.txt -ascii

# 変数の確認
who
whos 

# 変数の削除
clear <variable>
clear

# 行列操作
A(2,:) % 2行目全部
A(:,2) % 2列目全部
A = [A, [100; 101; 102;]] % ベクトルのappend
A(:) % put all elements of A into a single vector

C = [A B] % 列として追加
C = [A; B] % 新しい行に追加

A .* B % 要素同士の掛け算
A .^ 2 要素の2乗
1 ./ A 逆数にする
A' % transpose

[val, ind] = max(a) % 最大値とindexがわかる
find(a < 3) % 3以下のindexを返す

sum(a) % 和
prod(a) % 積

max(max(A))
max(A(:))

sum(A,1) % 列の合計
sum(A,2) % 行の合計

pinv(A) % 逆行列
```

### plot

```octave
t=[0:0.01:0.98];
y1 = sin(2*pi*4*t);
y2 = cos(2*pi*4*t);
plot(t,y1);
hold on;
plot(t, y2,'r');
xlabel('time')
ylabel('value')
legend('sin,'cos')
title('my plot')
print -dpng 'myPlot.png'
close

figure(1); plot(t,y1);
figure(2); plot(t,y2);

subplot(1,2,1); % 1x2のgridに分割して最初にアクセス
plot(t, y1);
subplot(1,2,2);
plot(t,y2);
axis([0.5 1 -1 1]) x軸が0.5から1 y軸が-1から1
clf % グラフのクリア

A = magic(5)
imagesc(A)
```

### control flow

#### for loop
```octave
v=zeros(10,1);
for i=1:10,
> v(i) = 2^i;
> end;
```

#### while
```octave
i = 1;
while i <= 5,
    v(i) = 100;
    i = i + 1; 
end;
```

#### if

```octave
if i == 6,
    disp(i);
elseif i == 7,
    disp(i);
else
    disp(i);
end;
```

### function
これをmy_func.mとして保存しておくと`my_func(10)`のように呼べる。
検索directoryに追加するには`addpath('path')`
```octave
function y = my_func(x)

y = x^2;
```

```octave
function [y1, y2] = my_func(x)

y1 = x^2;
y2 = x^3;
```

```octave
function J = costFunction(X, y , theta)
m = size(X,1);
predictions = X*theta;
sqrErrors = (predictions - y) .^ 2;

J = 1/(2*m) * sum(sqrErrors);
```
### 設定

`hist()`でエラーがでるので以下の設定を追加する。

```shell
bat /usr/local/octave/3.8.0/share/octave/site/m/startup/octaverc -p
## System-wide startup file for Octave.
##
## This file should contain any commands that should be executed each
## time Octave starts for every user at this site.
setenv("GNUTERM", "qt")
```

## Week1

### Welcome

> There's a science of getting computers to learn without being explicitly programmed. 

機械学習とは明示的なプログラムをしないでコンピュータに学ばせるという科学。


### Introduction

#### Welcome

機械学習の実際の活用例等について。

#### What is Machine Learning?

実際に使えるようになることが大事でそれを教えていきたい。

### Model and Cost Function

線形回帰。
二乗誤差関数といわれる目的関数について。

目的関数の可視化。

### Parameter Learning

#### Gradient Descent


## Week2

### Environment Setup

octaveのinstall


### Multivariable Liner Regression

Multivariable Liner Regression(多変量の線形回帰)の説明。  
家の値段で考えると、広さだけでなくフロア数、築年数、ベットルームの数,...を考慮するイメージ。

Gradient Descentのアルゴリズムを多変量用に変更。  
Featureの数字に際があると収束するまでに時間がかかってしまうので同じ範囲に調整する、Feature Scalingの話。

### Computing Parameters Analytically

