# Troubleshoot

## `gcc: error: unrecognized command-line option ‘-ftrivial-auto-var-init=zero`

Makefileに

```
ccflags-remove-y += -ftrivial-auto-var-init=zero 
```
