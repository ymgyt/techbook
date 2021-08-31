# Protoc Gen Validate

https://github.com/envoyproxy/protoc-gen-validate

## Validation

### Strings

```protobuf

// x must be at least 3 characters long
string x = 1 [(validate.rules).string.min_len = 3];

// x must be between 5 and 10 characters, inclusive
string x = 1[(validate.rules).string = {min_len: 5, max_len: 10}];

// x must be either "foo", "bar", or "baz"
string x = 1 [(validate.rules).string = {in: ["foo", "bar", "baz"]}];
```
