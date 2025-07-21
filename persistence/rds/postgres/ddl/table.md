# Table

## CREATE TABLE


```sql
CREATE TABLE example (
    a1            varchar(80) NOT NULL,
    --- NULLをつけるとdefault NULL
    a2            varchar(80) NULL
    b numeric,
    c numeric,

    PRIMARY KEY (a)
    --- CONSTRAINT const_a CHECK (a > b)
    CHECK (a > b),

    --- ユニーク制約
    --- CONSTRAINT must_be_unique UNICUE(b,c)
    UNIQUE(b, c)

    -- 外部キー
    FOREIGN KEY (x) REFERENCES other (c1)
);
```

* `PRIMARY KEY`
  * `UNIQUE NOT NULL`相当
  * `PRIMARY KEY (a,b)`


## DROP TABLE

```sql
DROP TABLE mytable;
```
