#!/bin/bash

# 変数の設定
TARGET_ENV="production"  # リリース対象の環境（例: production, staging）
TARGET_BRANCH="master"  # リリース対象のブランチ名
GIT_REPO_PATH="./"  # リリース対象のGitリポジトリのパス

# 1. 作業前の確認
# （手動で実施）

# 2. リリース作業の周知
echo "@here\n\n${TARGET_ENV} 環境のリリース作業を始めます。" | slack-notification-command

# 3. サーバーに接続
# （手動で実施）

# 4. 作業ディレクトリへ移動
cd "${GIT_REPO_PATH}"

# 5. 現在のブランチを確認
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "${current_branch}" != "${TARGET_BRANCH}" ]; then
  echo "エラー: リリース対象のブランチにチェックアウトしていません。"
  exit 1
fi

# 6. ワーキングツリーの確認
if [ -n "$(git status --porcelain)" ]; then
  echo "エラー: 作業ディレクトリに変更があります。変更をコミットまたは破棄してください。"
  exit 1
fi

# 7. リモートリポジトリの最新の情報を取得
git fetch --prune

# 8. リリース対象のコミットを確認
commits=$(git log --oneline --no-merges HEAD..origin/"${TARGET_BRANCH}")
if [ -n "${commits}" ]; then
  echo "エラー: リリース対象外のコミットが存在します。"
  echo "${commits}"
  exit 1
fi

# 9. 作業内容スクリーンショット
# （手動で実施）

# 10. ソースコードのリリース
git merge origin/"${TARGET_BRANCH}"

# 11. 未リリースのコミットを確認
commits=$(git log --oneline --no-merges HEAD..origin/"${TARGET_BRANCH}")
if [ -n "${commits}" ]; then
  echo "エラー: 未リリースのコミットが存在します。"
  echo "${commits}"
  exit 1
fi

# 12. EC-CUBE のソースコード反映後に実行が必要なコマンドの実行
# （EC-CUBEに固有の処理があればここに記述）

# 13. リリースされた日時の確認（YYYYmmddHHMM）
release_date=$(date +%Y%m%d%H%M)

# 14. 表示確認
# （手動で実施）

# 15. 作業内容の共有
# （手動で実施）

# 16. リリースタグの付与（本番リリース時のみ）
if [ "${TARGET_ENV}" = "production" ]; then
  git tag -a -m "本番リリース" "${release_date}" && git push origin "${release_date}"
fi

echo "リリース作業が完了しました。"

