# Earthfile

Dockerfileのようにimageのinstructionsを書く

## Example

### Node

```Dockerfile

source:
    FROM scratch
    GIT CLONE --branch=main https://github.com/ymgyt/foo.git foo
    SAVE ARTIFACT foo

deps:
    FROM node:20
    COPY +source/foo/package.json .
    COPY +source/foo/yarn.lock .
    RUN yarn install
    
build:
    FROM +deps
    COPY +source/foo/src ./src

    RUN yarn build

    SAVE ARTIFACT ./dist

image:
    FROM +deps
    COPY +build/dist ./dist

    EXPOSE 8080

    CMD [ "npm", "start" ]
    SAVE IMAGE --push ${IMAGE_NAME}
```
