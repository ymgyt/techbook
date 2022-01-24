# apt

## apt-get

* `apt-get install --assume-yes --quiet --no-install-recommends`
  * これがscript(docker file)とかでオススメ
* `/var/lib/apt/lists/*`にpackageのcacheが残るので、Dockerfileでは消しておく
