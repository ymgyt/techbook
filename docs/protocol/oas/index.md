# Open Api Specification


## Data types

### Numbers

#### format
integer/floatはformatで指定する。

| type    | format | Description                                          |
| ---     | ---    | ---                                                  |
| number  | –      | Any numbers.                                         |
| number  | float  | Floating-point numbers.                              |
| number  | double | Floating-point numbers with double precision.        |
| integer | –      | Integer numbers.                                     |
| integer | int32  | Signed 32-bit integers (commonly used integer type). |
| integer | int64  | Signed 64-bit integers (long type).                  |

```yaml
type: number
format: double
```

#### minimum and maximum

min/max,境界値を指定する。
```yaml
# 1 <= value < 1000 
type: number
minimum: 0
maximum: 1000
exclusiveMinimum: false
exclusiveMaximum: true
```

### String

`minLength`と`maxLength`で長さを制限できる。  
https://swagger.io/docs/specification/data-models/data-types/#string

```yaml
type: string
minLength: 3
maxLength: 20
```

#### enum

`nullable`を`true`にした場合は明示的に選択肢に`null`が必要。

```yaml
schema:
  type: string
  nullable: true
  enum: [asc, desc, null]
description: |
  Sort order:
   * `asc` - Ascending, from A to Z
   * `desc` - Descending, from Z to A
```

## Inheritance

### composition

`allOf`で他の型のfieldをすべてもつ新しい型を定義する。

```yaml
components:
  schemas:
    Base:
      type: object
      properties:
        message:
          type: string
        code:
          type: integer
    Extended:
      allOf:
        - $ref: '#/components/schemas/Base'
        - type: object
          properties:
            field:
              # ...
```

## `$ref`

参照先の定義をその場に展開できる。したがって、siblingは無視される。   
どこでも使えるわけではなく、使える場所は仕様でref objectが使えると定義されている。

```yaml
components:
  schemas:
    Date:
      type string
      format date
    Xxx:
      $ref: '#/components/schemas/Date'
      description: this is ignored!
```

こう書いた場合、`Xxx.description`は無視される。  
`$ref: path_to_file#/json_path`として外部のfileも参照できる。
