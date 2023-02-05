# matplotlib

## pyplot

> matplotlib.pyplot is a state-based interface to matplotlib. It provides a MATLAB-like way of plotting.
  pyplot is mainly intended for interactive plots and simple cases of programmatic plot generation:

```python
import matplotlib.pyplot as plt
```

### 参考

* [matplotlib.pyplot document](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.html#module-matplotlib.pyplot)

### `Figure`

```python
import matplotlib.pyplot as plt

# 生成
fig = plt.figure(
    figsize(10,16) # width, height    
)

# add Axes to the figure
# 3つのisdfnteger n,c,iを渡してn行c列のi番目という感じで指定する。
# indexは1オリジン。
fig.subplot(111)
fig.subplot((1,1,1))

```
