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
