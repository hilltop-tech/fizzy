# Upstream Sync Workflow

このドキュメントでは、Basecampの公式Fizzyリポジトリ（アップストリーム）からの変更を取り込む方法を説明します。

## ブランチ戦略

- **`main`**: 本番環境で使用するカスタマイズ版
- **`upstream-main`**: Basecampの公式版を追跡する専用ブランチ

## 現在の状態

- 分岐点: `9b1dd0bcd990339835f596ed52a11d530f5230ed`
- `main`ブランチ: 18コミット先行（カスタマイズ）
- アップストリーム: 9コミット先行（新機能・バグフィックス）

## 定期的なアップストリーム同期

### 1. アップストリームの最新変更を取得

```bash
# アップストリームの最新状態を取得
git fetch upstream

# upstream-mainブランチに切り替え
git checkout upstream-main

# アップストリームの変更をマージ
git merge upstream/main

# originにプッシュ
git push origin upstream-main
```

### 2. 変更内容を確認

```bash
# upstream-mainとmainの差分を確認
git log main..upstream-main --oneline

# 詳細な差分を確認
git diff main..upstream-main
```

### 3. mainブランチへの統合

アップストリームの変更をmainに取り込む方法は2つあります。

#### オプションA: 選択的なCherry-pick（推奨）

特定のコミットのみを取り込む：

```bash
git checkout main

# 取り込みたいコミットを個別にcherry-pick
git cherry-pick <commit-hash>

# コンフリクトがある場合は解決して続行
git cherry-pick --continue

# テスト後にプッシュ
git push origin main
```

#### オプションB: Merge（大規模な変更の場合）

```bash
git checkout main

# アップストリームの変更をマージ
git merge upstream-main

# コンフリクトを解決
# 特にカスタマイズしたファイルに注意：
# - config/puma.rb (メモリ最適化)
# - config/queue.yml (Solid Queue設定)
# - config/database.mysql.yml (コネクションプール)
# - app/models/account.rb (サインアップ制御)
# - config/locales/*.yml (日本語化)

# テスト
bin/rails test
bin/rails test:system

# プッシュ
git push origin main
```

## カスタマイズファイル一覧

以下のファイルはカスタマイズしているため、アップストリームとマージする際は注意：

### 設定ファイル
- `config/puma.rb` - メモリ最適化（WEB_CONCURRENCY対応）
- `config/queue.yml` - Solid Queue最適化
- `config/database.mysql.yml` - 動的コネクションプール

### モデル
- `app/models/account.rb` - `accepting_signups?`メソッド追加

### ローカライゼーション
- `config/locales/ja.yml` - 日本語翻訳
- その他 `config/locales/*.ja.yml` ファイル

## コンフリクト解決のガイドライン

1. **設定ファイル**: カスタマイズを優先し、アップストリームの新機能も取り込む
2. **モデル・コントローラー**: アップストリームの変更を取り込み、カスタムメソッドは追加で維持
3. **日本語化**: カスタマイズを維持
4. **新機能**: アップストリームの実装をそのまま採用

## Railway環境変数

アップストリームから取り込む際も、以下の環境変数は維持：

```bash
# メモリ最適化
WEB_CONCURRENCY=2
JOB_CONCURRENCY=2
RAILS_MAX_THREADS=2
MALLOC_ARENA_MAX=2
RUBY_GC_HEAP_GROWTH_FACTOR=1.1

# 機能制御
ALLOW_SIGNUPS=false
DATABASE_ADAPTER=mysql
MULTI_TENANT=true
```

## 緊急時のロールバック

問題が発生した場合：

```bash
# mainブランチをアップストリーム統合前の状態に戻す
git checkout main
git reset --hard origin/main@{1}
git push origin main --force
```

## 参考リンク

- Basecamp公式リポジトリ: https://github.com/basecamp/fizzy
- Pull Requests: https://github.com/basecamp/fizzy/pulls
- Issues: https://github.com/basecamp/fizzy/issues
