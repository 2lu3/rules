# rules

* cursor / claude code / codex のためのルール

## 自動化

このリポジトリには、複数のプロジェクトへ展開できる共通設定を含めています。

- `.pre-commit-config.yaml`: 末尾の空白、ファイル末尾、マージコンフリクト、大きな追加ファイルを確認します
- `scripts/setup-worktree.sh`: worktree 作成時に利用するソフトから自動実行されるセットアップスクリプトです
- `AGENTS.md`: エージェントの判断が必要なルールを定義します

worktree setup は現在のブランチを同期したり、`main` を pull したりしません。プロジェクト固有の format、lint、build、typecheck、test は各プロジェクトの設定で追加してください。

### セットアップ

`install.sh` は `.pre-commit-config.yaml` を配置した後に `pre-commit install --install-hooks` を実行します。実行環境にはあらかじめ `pre-commit` コマンドをインストールしてください。linked worktree は main worktree と Git hook を共有するため、worktree ごとの hook のインストールは不要です。

チェックを手動で全ファイルへ実行する場合は次を使います。

```sh
pre-commit run --all-files
```

### 他のリポジトリへの導入

対象リポジトリのルートで次を実行すると、CI、pre-commit、worktree セットアップ、エージェント向けルールを導入できます。既存の対象ファイルは更新されます。

```sh
curl -fsSL https://raw.githubusercontent.com/2lu3/rules/main/install.sh | sh
```

導入後は、worktree 作成時に利用するソフトから `scripts/setup-worktree.sh` が自動実行される構成にしてください。このスクリプトでは pre-commit のインストールを行いません。


## 参考

* https://zenn.dev/singularity/articles/stopped-reviewing-my-code
