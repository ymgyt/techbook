# Render

* CellにはStyleの情報が保持されるので、描画領域が重なる場合、layer2で指定されなかった情報(modifier italic等)にlayer1のものが使われる可能性がある
  * `Clear` widgetがあるので重なる領域の情報を消去することで対応できる