# Ratatui Test

1. `ratatui::backend::TestBackend`が用意されている
  * `rataui::backend::CrosstermBackend`の代わりに使う
2. 期待するbufferを`ratatui::buffer::Buffer::with_lines()`等で用意する
3. `ratatui::Terminal<ratatui::backend::TestBackend>::draw()`で描画する
4. `terminal.backend().assert_buffer()`でassertする
