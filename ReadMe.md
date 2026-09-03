# rules

* cursor / claude code / codex のためのルール

## 自動化

このリポジトリには、複数のプロジェクトへ展開できる共通設定を含めています。

- `.pre-commit-config.yaml`: 末尾の空白、ファイル末尾、マージコンフリクト、大きな追加ファイルを確認します
- `scripts/setup-worktree.sh`: worktree 作成時に利用するソフトから自動実行されるセットアップスクリプトです
- `AGENTS.md`: エージェントの判断が必要なルールを定義します
- `.agents/skills/`: Codex CLI / Cursor / Claude Code など複数のエージェントツールで共通利用するスキルの正本です。`install.sh` はこの内容を対象リポジトリの `.agents/skills/` と `.claude/skills/` の両方へ実体コピーします(symlink ではなく `cp`)。Claude Code は `.claude/skills/` しか参照しないため、この複製で橋渡ししています。両ディレクトリとも配布物専用で、`install.sh` を実行するたびに配布元の内容で置き換えられます。独自のスキルを追加したい場合は別ディレクトリを使うか、本リポジトリへの変更として提案してください

`scripts/setup-worktree.sh` は共通のディスパッチャーです。元リポジトリのパスと worktree リポジトリのパスを必須引数として受け取り、worktree 側の `scripts/setup-worktree-*.sh` をファイル名順に実行します。各スクリプトには、元リポジトリの絶対パスと worktree リポジトリの絶対パスが同じ順序で渡されます。

共通スクリプトは固有スクリプトを実行する前に worktree の現在ブランチを検証します。`main`、`master`、detached HEAD では明確なエラーを表示して終了し、それ以外のブランチでは既存のセットアップ処理を続けます。この検証は pre-commit 設定の有無に依存しません。

```sh
scripts/setup-worktree.sh /path/to/original-repository /path/to/worktree-repository
```

プロジェクト固有の処理は、例えば `scripts/setup-worktree-example.sh` として追加します。対象ファイルがない場合、共通スクリプトは何も実行せず正常終了します。worktree setup は現在のブランチを同期したり、`main` を pull したりしません。プロジェクト固有の format、lint、build、typecheck、test は各プロジェクトの `setup-worktree-*.sh` に追加してください。

### セットアップ

`install.sh` は `.pre-commit-config.yaml` を配置した後に `pre-commit install --install-hooks` を実行します。実行環境にはあらかじめ `pre-commit` コマンドをインストールしてください。linked worktree は main worktree と Git hook を共有するため、worktree ごとの hook のインストールは不要です。

チェックを手動で全ファイルへ実行する場合は次を使います。

```sh
pre-commit run --all-files
```

### 他のリポジトリへの導入

対象リポジトリのルートで次を実行すると、CI、pre-commit、worktree セットアップ、エージェント向けルール、スキルを導入できます。既存の対象ファイル・ディレクトリは配布元の内容で置き換えられます(ディレクトリの場合、配布元で削除されたファイルも反映されます)。

```sh
curl -fsSL https://raw.githubusercontent.com/2lu3/rules/main/install.sh | sh
```

`install.sh` は内部で `2lu3/rules` を shallow clone し、対象ファイル・ディレクトリを `cp` でコピーします。実行には `git` と `pre-commit` が必要です(`curl` は install.sh 自体の取得のみに使い、内部処理では使いません)。

導入後は、worktree 作成時に利用するソフトから `scripts/setup-worktree.sh` が自動実行される構成にしてください。このスクリプトでは pre-commit のインストールを行いません。


## 参考

* https://zenn.dev/singularity/articles/stopped-reviewing-my-code
