# sklearn

## model_selection

テストデータを訓練用と評価用に分割するutil.  

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
iris_dataset = load_iris()

X_train, X_test, y_train, y_test = train_test_split(
   iris_dataset['data'], iris_dataset['target'], random_state=0)

```
