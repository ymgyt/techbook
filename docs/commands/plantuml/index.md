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

## color

https://plantuml.com/color

## Class Diagram

[specification](https://plantuml.com/class-diagram)

* aggregation: class間に全体と部分の関係がある
* composition: 全体instanceが部分instanceを所有(生成/消滅の責務をもつ)

## References

* [AWS構成図を作るGuideもある](https://crashedmind.github.io/PlantUMLHitchhikersGuide/index.html)
* [AWS Symbols](https://github.com/awslabs/aws-icons-for-plantuml/blob/master/AWSSymbols.md)
