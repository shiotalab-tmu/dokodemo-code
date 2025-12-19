# dokodemo-code
VS Codeの統合ターミナル以外（個人PCのTerminalなど）で研究室マシンにSSH接続したとき，`code` コマンドでVS Codeを開けるようにするスクリプト．

## インストール
1. `dokodemo-code.sh`を研究室マシンに配置してください．`/lhome/username/dokodemo-code.sh`を推奨．
2. 研究室マシンの `.bashrc` に以下を追記してください．
  ```sh
  source /path/to/dokodemo-code.sh
  ```

## 使い方

個人PCのTerminalから研究室マシンにSSH接続した状態で，VS Codeの統合Terminalと同じように `code` コマンドを使用できます．
```sh
code          # カレントディレクトリを開く
code .        # カレントディレクトリを開く（明示的）
code dir/     # ディレクトリを開く
code file.py  # ファイルを開く
```

出力されたボタン／リンクをクリック（端末によっては Ctrl+Click）すると VS Code が開きます．

## SSHホスト名の設定

Remote-SSH用リンクのホスト名は次の優先順位で決定されます．

1. `VSCODE_SSH_HOST` 環境変数（設定されている場合）
2. `hostname` コマンドの出力

研究室マシンへのSSH接続設定は[こちら](https://www.notion.so/PC-1ced54c353c880fa8860c3fa40f19733?source=copy_link#623160f7512d41838d17092e724bafb1)を参照してください．この設定を使用している場合，`VSCODE_SSH_HOST` の設定は不要です．

## 注意事項

- リンクの開き方（Click／Ctrl+Click）は使用している端末の仕様に依存します
- クリック可能なリンクとして表示するには，端末がOSC 8ハイパーリンクに対応している必要があります
