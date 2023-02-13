# Keymap

https://docs.helix-editor.com/keymap.html

## Select

### Select word

* w/W: before begiinng of the next word
* e/E: endo of the current word
* b/B: backword to begin of the word

* W/E/Bはwhite spaceのみをseparatorにする

### Select words

* s: x等でselectした状態でs押してwordいれてenter

### Select to character

* f<ch>: charまでselect
* t<ch>: charの直前までselect
* F/T<ch>: backwords
* Opt-.: repeat the selection.

### Select line

* x: select current line

### Delete selection

* d: selectionをdeleteする. cursorは1charのselectionと言える.

### Deselect

* ;: selectionを解除する

### Split into each line

* Opt+s: 複数行selectionを1行ずつのselectionに分割する. &する際に便利

## Undo/Redo

* u: undo
* U: redo

## Mode

* I: 行の先頭にinsert
* A: 行の末尾にappend
* c: selectionをdeleteしてinsert modeに移行
* v: selection mode

## Copy and Paste

* y: yank the selection
* p: paste the yanked selection after the cursor
* P: paste the yanked selection before the cursor

* Space + y/p: use system clipboard

* Cmd-d,Cmd-cをするとselectionをbufferに保持しない挙動になる

## Search

* /: search forward
* ?: search backward
* n/N: go to next/previous search match
  * '/'registerをさがしている
* *: selectionを'/'registerに登録する"/yのshortcut
 

## Multiple Cursor

* C: duplicate cursor
* ,: remove cursor

## Select command

* s: selectionある前提でsおすとpromptがでてきて単語を入力してenterおすとmatchした状態になる

## Align selection

* &: selectionをalignする

## Replace

* r<ch>: selectionをcharacterにreplaceする
* R: replace with previously yanked text

## Repeat

* .: repeat last insert
* Opt-.: repeat f / t selection

## Join lines

* J: join lines

## Indent line

* < / >: indent line.

## Increment and Decrement

* Ctrl-a/x: inc / dec. cursorが数字でない場合は直近のnumberにjumpしてくれる

## Registers

* "<ch>: yankやpasteのregisterを指定する

## Macro

* Q: start / end recording
* q: repeat macro

## Jumplist

* Ctrl-s: save current position to jumplist
* Ctrl-i / Ctrl-o: move forward and backward in jumplist

## Change Case

* ~: switch the case of selected letters
* `: to lower(Shift to upper)

## Comment

* Ctrl-c

