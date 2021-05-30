# Latex

## Install
```shell
sudo tlmgr update --self --all

# 商用OSであるMacのassetsは別管理されている
sudo tlmgr repository add http://contrib.texlive.info/current tlcontrib
sudo tlmgr pinning add tlcontrib '*'
sudo tlmgr install japanese-otf-nonfree japanese-otf-uptex-nonfree ptex-fontmaps-macos cjk-gs-integrate-macos

# ヒラギノフォントの準備
sudo cjk-gs-integrate --link-texmf --cleanup --force
sudo cjk-gs-integrate-macos --link-texmf --force
sudo mktexlsr

# ヒラギノフォントの埋め込み設定
sudo kanji-config-updmap-sys --jis2004 hiragino-highsierra-pron


# TexShopの推奨設定
defaults write TeXShop FixLineNumberScroll NO
defaults write TeXShop SourceScrollElasticity NO
defaults write TeXShop FixPreviewBlur YES
```

確認
```latex
\documentclass[dvipdfmx,autodetect-engine]{jsarticle}% autodetect-engine で pLaTeX / upLaTeX を自動判定

\begin{document}

吾輩は猫である。名前はまだ無い。

どこで生れたかとんと見当がつかぬ。
何でも薄暗いじめじめした所で
ニャーニャー泣いていた事だけは記憶している。
吾輩はここで始めて人間というものを見た。

\end{document}
```

## 論理記号

```latex
% 同値
\Leftrightarrow
```

## 数式

```latex
% Sum
\sum_{k = 0}^{n}

% product(times)
\times
```

## スペース 

```latex
% 1文字分のスペース
\quad
% 2文字分のスペース
\qquad 
```

## 文書構造

```latex
\section{節見出し}
\subsection{小節見出し}
\subsubsection{...}

\paragraph{段落見出し}
\subparagraph{サブパラグラフ見出し}

% リテラル
\begin{verbatim}
\end{verbatim}
```

## その他の記号

```latex
% 省略のdot
\dots
```

## custom command

`\newcommand{\<cmd_name>[<arg_count>]{<def_body>}`  
`#1`で第一引数を参照する。

```latex
% 数式へのコメント用のコマンド。
\newcommand{\comment}[1]{\qquad &\text{$(#1)$}}

```
