# keyof

* 型を引数にとってその型のpropertyのstringのunionを返す

```typescript
interface Person {
    name: string
    age: number
    location: string
}

// SomeNewType ( "name" | "age" | "location" )
type SomeNewType = keyof Person
```
