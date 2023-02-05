# PlantUML CLI

```
FROM openjdk:19-jdk-slim-bullseye

RUN apt-get update \
    && apt-get install --assume-yes --quiet \
    fonts-takao \
    graphviz \
    wget

RUN mkdir /plantuml \
    && wget --output-document - https://github.com/plantuml/plantuml/releases/download/v1.2021.16/plantuml-1.2021.16.jar > /plantuml/plantuml.jar

WORKDIR /home

ENTRYPOINT ["/usr/local/openjdk-19/bin/java", "-jar", "/plantuml/plantuml.jar"]

CMD ["-help"]
```

みたいに使う。
`docker run --rm -v $(pwd):/home ymgyt/plantuml:latest example.puml`
