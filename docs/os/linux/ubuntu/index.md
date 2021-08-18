# Ubuntu

## version確認

```shell
cat /etc/os-release
```

## 環境構築memo

### Google Chromeのinstall

```shell
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.dep
```

### Chrome Driverのinstall

```shell
# 各version
# https://chromedriver.chromium.org/downloads
curl -O https://chromedriver.storage.googleapis.com/92.0.4515.107/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/local/bin/
chromedriver --version
```
