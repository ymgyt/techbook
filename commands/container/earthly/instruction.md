# Earthly Instructions

## FROM

* 別のtargetをbase imageにする

```
deps:
    FROM node:20
    COPY +source/foo/package.json .
    RUN yarn install
    
build:
    FROM +deps
```
