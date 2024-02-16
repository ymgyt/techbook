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


## switch 

```typescript
switch (env.identifier()) {
	case "prod":
		break;
	case "staging":
		break;
	case "dev":
    console.log("Dev");
    break;
  default:
    console.log("default")
    break;
}
```
