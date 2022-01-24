# Example

```yaml
openapi: 3.0.3
info:
  title: Ymgyt API
  description: |
    # Markdownがかける

    ## 認証
    HTTP HeaderにAPI Keyをセットすることで行います。
    Headerは`Authorization`を利用します。  例えばAPI Keyが`ABC`の場合、Request Headerは以下のようになります。

    `Authorization: Bearer ABC`

    詳細については[RFC6750](https://tools.ietf.org/html/rfc6750#section-2.1)を参照してください。

  contact:
    name: Ymgyt Support
    email: contact@example.com
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0.html
  version: 0.1.0
servers:
  - url: https://api.ymgyt.io/v1
    description: Production endpoint
  # 変数かける。
  - url: https://api.{env}.ymgyt.io/vi
    description: development endpoint(s)
    variables:
      env:
        enum: [dev,stg]
        default: dev
        description: environment

paths:
  /locations:
    post:
      tags: [location]
      operationId: postLocation
      summary: locationをpostする
      description: |
        location post desc...
      requestBody:
        required: true
        description: desc...
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/Locations"
      responses:
        '200':
          description: リクエスト成功。
          content:
            application/json:
              schema:
                type: object
                properties:
                  ErrorLocations:
                    description: validationに違反する位置情報。
                    type: array
                    items:
                      type: object
                      properties:
                        Location:
                          $ref: "#/components/schemas/Location"
                        Error:
                          oneOf:
                            - $ref: "#/components/schemas/InvalidLocationError"
        '400': {$ref: '#/components/responses/400'}
        '401': {$ref: '#/components/responses/401'}

components:
  schemas:
    Locations:
      type: object
      required:
        - locations
      properties:
        locations:
          type: array
          items:
            $ref: "#/components/schemas/Location"
          minItems: 1
    Location:
      type: object
      description: Location desc
      required:
       - lat
       - lng
       - timestamp
      properties:
        lat:
          type: number
          format: double
          description: 緯度
        lng:
          type: number
          format: double
          description: 経度
        timestamp:
          type: integer
          description:  UNIXタイム(UTC 1970/1/1からの経過秒数)
          format: int64
    InvalidLocationError:
      type: object
      properties:
        Fields:
          type: array
          items:
            type: object
            properties:
              Name:
                type: string
                description: フィールド名。
              Reason:
                type: string
                description: エラーとなった理由。

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer

security:
  # components/securitySchemasで定義されたentryと同じ名前にする。
  # valueはscopeだが、bearerには対応する概念がないので空arrayでよい。
  - bearerAuth: []

# tag定義
tags:
  - name: location
    description: 位置情報。
```
