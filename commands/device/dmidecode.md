# dmidecode

Hardwareの情報を表示する。  
PCのModel名とかがわかる。

```sh
dmidecode | grep -A3 '^System Information'
```