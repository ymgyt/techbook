# Strucutred metadata

* index labelともlog line(data)とも違うデータ構造
* cardinalityの関係でindex時には利用されないが、query時にはserverから返されるので、filter expressionでは使える
* opentelemetryのresourceのうち、index labelに使われなかったものを格納するのがusecase
  * podやcontainer idはindexするにはcardinalityが高すぎる
