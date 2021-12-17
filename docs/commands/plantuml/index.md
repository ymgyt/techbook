# PlantUML

## Install

1. install Java
1. install graphviz
1. install [plantuml.jar](https://sourceforge.net/projects/plantuml/files/plantuml.jar/download)
```shell
# check java
java --version

# check graphviz
dot -V

# check plantuml
java -jar ./plantuml.jar -testdot
```

diagram.txt
```text
@startuml
Alice -> Bob: test
@enduml
```

```shell

# help
java -jar ./plantuml.jar -help
```

## Usage

```shell
# generate diagram.png
java -jar ./plantuml.jar ./diagram.txt && open diagram.png

# stdinから生成する
# svgを生成する場合 opt=-tsvg
< "${src}" sed -e "s/'__FOOTER/footer Generated at $(date)/" | \
java -jar "${plantuml_jar}" "${opt}" -pipe > "${dst}" 
```

## Theme

https://bschwarz.github.io/puml-themes/gallery.html

```shell

@startuml
!theme spacealb
@enduml
```

### skinparam

```puml
' 線が直線になる
skinparam linetype ortho
' 線が比較的直線になる
skinparam linetype polyline
```

## color

https://plantuml.com/color

## Template

```text
@startuml

' ============= Generate time substitution =============
' footer指定
'__FOOTER
' theme指定
'__THEME
' ======================================================

hide empty members
title Title
skinparam linetype polyline

'content here...

@enduml
```

```shell
< "${CWD}/${src}" sed -e "s/'__FOOTER/footer Generated at $(date)/" | \
sed -e "s/'__THEME/'!theme materia-outline/" | \
java -jar "${plantuml_jar}" "${opt}" -pipe > "${dst}"  || fail "failed to generate image"
```

生成時にsedで置換している。

## References

* [AWS構成図を作るGuideもある](https://crashedmind.github.io/PlantUMLHitchhikersGuide/index.html)
* [AWS Symbols](https://github.com/awslabs/aws-icons-for-plantuml/blob/master/AWSSymbols.md)
