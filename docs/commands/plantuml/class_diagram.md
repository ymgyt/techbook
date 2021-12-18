# Class Diagram

[specification](https://plantuml.com/class-diagram)

* aggregation: class間に全体と部分の関係がある
* composition: 全体instanceが部分instanceを所有(生成/消滅の責務をもつ)



## Note

```puml
entity Device {
    Code string
    Name string
    -- ubiquitous --
    端末
}
note left of Device::Code
    Sigfox上の識別子
end note
```

特定のfiledにnoteを生やす
