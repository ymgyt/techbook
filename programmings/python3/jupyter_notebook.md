# Jupyter notebook

## Usage

```
# 起動
jupyter notebook
```

## Recipe

### plot function

logistic regression cost function

```python
import matplotlib.pyplot as plt
import numpy as np

%matplotlib notebook

x = np.linspace(-3, 3)
y = -1 * np.log(1 / (1 + np.exp(-x)))

plt.plot(x,y)
```

円を表す関数
```python
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(-3, 3)
y1 = np.sqrt(9 - x ** 2)
y2 = -1 * np.sqrt(9 - x ** 2)
plt.plot(x,y1)
plt.plot(x,y2)
```

### import 

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

%matplotlib inline

import matplotlib

print(f"""matplotlib: {matplotlib.__version__}
pandas: {pd.__version__}
numpy: {np.__version__}""")
```

### histogram

対象のcsv dataには識別子と個数がはいっている。

```csv
target_id,count
229,501
112,34
807,32
```


```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

%matplotlib inline

# load csv
df = pd.read_csv('./target.csv')

# create numpy ndarray
counts = np.array(df['count'])

# figsizeでfigureの大きさを調整できる。
fig = plt.figure(figsize=(20,12))
ax = fig.add_subplot(111)

# binsはhistogramの階級数
freq, _, _ = ax.hist(counts, bins=50, range=(0, 50))

# グラフの説明
ax.set_xlabel("tag")
ax.set_ylabel("carrier")

# グラフメモリ
ax.set_xticks(np.arange(0, 50, 1))
ax.set_yticks(np.arange(0, freq.max()+1))

plt.show()
```

#### 相対度数

相対度数と累積を同時に描画する。

```python
# load csv
df = pd.read_csv('./target.csv')

# create numpy ndarray
counts = np.array(df['count'])

fig = plt.figure(figsize=(20,10))
ax1 = fig.add_subplot(111)
# 累積のグラフ
ax2 = ax1.twinx()

weights = np.ones_like(counts) / len(counts)
rel_freq, _, _ = ax1.hist(counts, bins=40, range=(0, 40), weights=weights,color='darkgray')
cum_rel_freq = np.cumsum(rel_freq)

ax2.plot(range(0,40), cum_rel_freq, ls='--', marker='o', color='royalblue')

# このへんissueはあった https://github.com/matplotlib/matplotlib/pull/18769
# ax2.grid(visible=False)
# ax2.grid(b=False)

ax1.set_xlabel('tag')
ax1.set_ylabel('relative freq')
ax2.set_ylabel('cummulative')

ax1.set_xticks(np.arange(0, 40, 1))
plt.show()
```

### plotの保存

```python
import matplotlib.pyplot as plt

fig = plt.figure(figsize=(20,12))

# setup...

fig.saving("plot.png")
```
