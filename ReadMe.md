# rules

* cursor / claude code / codex のためのルール

## 自動化

このリポジトリには、複数のプロジェクトへ展開できる共通設定を含めています。

- `.pre-commit-config.yaml`: 末尾の空白、ファイル末尾、マージコンフリクト、大きな追加ファイルを確認します
- `scripts/setup-worktree.sh`: worktree 作成後に `pre-commit` hook をインストールします
- `AGENTS.md`: エージェントの判断が必要なルールを定義します

worktree setup は現在のブランチを同期したり、`main` を pull したりしません。プロジェクト固有の format、lint、build、typecheck、test は各プロジェクトの設定で追加してください。

### セットアップ

`pre-commit` をインストールした後、worktree のルートで次を実行します。

```sh
./scripts/setup-worktree.sh
```

チェックを手動で全ファイルへ実行する場合は次を使います。

```sh
pre-commit run --all-files
```

### 他のリポジトリへの導入

対象リポジトリのルートで次を実行すると、CI、pre-commit、worktree セットアップ、エージェント向けルールを導入できます。既存の対象ファイルは更新されます。

```sh
curl -fsSL https://raw.githubusercontent.com/2lu3/rules/main/install.sh | sh
```

導入後、`pre-commit` をインストールしてから `./scripts/setup-worktree.sh` を実行すると、pre-commit hook が有効になります。


## 参考

* https://zenn.dev/singularity/articles/stopped-reviewing-my-code
