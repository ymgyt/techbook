# Zellij

## Layout

Panelの分割を指定して新しいtabを開ける

```sh
zellij action new-tab --layout rpi.kdl
```

layoutは`~/.config/zellij/layouts/`配下に置いておくと検索pathに含まれる

### Example

```kdl
layout {
	pane_template name="ssh" {
		command "ssh"
	}

  pane size=1 borderless=true {
		plugin location="zellij:tab-bar"
	}
	pane split_direction="vertical" {
		ssh {
			args "ymgyt@192.168.10.150"
		}
		ssh {
			args "ymgyt@192.168.10.151"			
		}
	}
	pane split_direction="vertical" {
		ssh {
			args "ymgyt@192.168.10.152"
		}
		ssh {
			args "ymgyt@192.168.10.153"			
		}
	}
	pane size=2 borderless=true {
		plugin location="zellij:status-bar"
	}
}
```

* `pane_template`を宣言するとpaneとして使える。
* `plugin location="zellij:tab-bar"`を指定したpaneをいれないと他と見た目がかわってしまう。