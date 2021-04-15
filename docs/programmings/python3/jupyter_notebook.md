# Jupyter notebook

## Usage

```
# 起動
jupyter notebook
```

## Recipe

logistic regression cost function

```
import matplotlib.pyplot as plt
import numpy as np

%matplotlib notebook

x = np.linspace(-3, 3)
y = -1 * np.log(1 / (1 + np.exp(-x)))

plt.plot(x,y)
```
