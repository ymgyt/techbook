# Control Flow

## loop

### for-of

```typescript
const arr = ["a", "b", "c"];
for (const value of arr) {
  console.log(value);
}

// rustでいうenumerate()
for (const [idx, item] of ary.entries()) {}
```

* `Array.prototype.entries()`でenumerate()できる
