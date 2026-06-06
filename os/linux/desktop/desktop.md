# Desktop Tmp

* GUI描画までの流れ
  1. applicationが描画命令を発行
    * ここでwayland protocolが使われる
  1. window managerがwindowを管理
  1. compositorが画像を合成
  1. compositorがDRIを返してrendering
  1. 画面に表示

[ アプリケーション ]
        |
        V
[ X11 or Wayland (描画要求を受け付ける) ]
        |
        V
[ Window Manager (位置・サイズ管理) ]
        |
        V
[ Compositor (画像合成、エフェクト処理) ]
        |
        V
[ Mesa 3D (グラフィックスAPI提供: OpenGL/Vulkan) ]
        |
        V
[ DRI (Direct Rendering Infrastructure) ]
        |
        V
[ DRM (Direct Rendering Manager、Linuxカーネル内) ]
        |
        V
[ GPU ハードウェア (描画実行) ]
        |
        V
[ モニターに表示 ]

app -> Qt, GTK+ -> Mesa -> libdrm -> render node -> 共有メモリ


* DRI
  * Direct Rendering Infrastructure
  * MesaがGPUを抽象化している
  * KernelのDirect Rendering Managerとやり取り

* DRM
  * Primary nodeとRender nodeがいる
  * Render node
    * /dev/dri/renderD128
    * GPUのメモリを確保したり、計算できる
    * 表示はできない
    * 複数プロセスが同時に開ける
  * /dev/dri/card0
    * Render nodeの機能はできる
    * 表示もできる
    * 1プロセスだけが開ける
    * compositorが占有している

* Mesa
  * HW非依存のAPIで特定のGPU向けのコマンドをrender nodeに投げる

* Wayland
  * CompositorとWindowManagerの機能が統合されている

* GNOME
  * Mutterというcompositor(WM)を利用
    * Mutterはwaylandの実装?
  * defaultでwayland


```sh
# Check if you are using Wayland
$env.XDG_SESSION_TYPE
wayland
```

* Display Manager
  * Wayland compositorを起動する
  * GUIのログイン画面を表示
  * GNOMEではGDM(GNOME Display Manager)
