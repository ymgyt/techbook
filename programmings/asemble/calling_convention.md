# Calling Convention

| 関数A             | 関数B             |
| ---               | ---               |
| Caller Saved 退避 | -                 |
| Call 関数B        | -                 |
| -                 | Callee Saved 退避 |
| -                 | 処理              | 
| -                 | Callee Saved 復元 |
| -                 | RET               |
| Caller Saved 復元 | -                 |