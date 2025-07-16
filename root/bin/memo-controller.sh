#!/usr/bin/env bash

# $1: メモのディレクトリ
# $2: 新規ファイルのサブディレクトリ、新規ファイルを特定ディレクトリに作成したい場合は末尾/で記載
# $3: サブコマンドまたは作成ファイル名(ファイル名はダブルクォート区切りで渡すこと)
# memo-contoroller.sh $1 $2 $3
if [[ -n $1 ]];then
    TARGET_DIR="$1"
else
    echo '$TARGET_DIR を指定してください'
    exit 1
fi

NEWFILE_PREFIX_DIR="$2"

if [[ -n $3 ]];then
    SUB_COMMAND=$3
else
    SUB_COMMAND="list"
fi

set -eu

_list_files() {
    local SELECTED=$(rg --files | sort | sed 's/.md//' | fzf --preview "cat $TARGET_DIR/{}.md")
    if [[ -z "$SELECTED" ]];then
        exit
    fi
    FILE_PATH="$TARGET_DIR/$SELECTED.md"
    $EDITOR "$FILE_PATH"
}

_create_new_file(){
    cd "$TARGET_DIR"
    FILE_PATH="$TARGET_DIR/${NEWFILE_PREFIX_DIR}/${SUB_COMMAND}.md"
    $EDITOR "$FILE_PATH"
}

main(){
    cd $TARGET_DIR

    # git repo か調べる
    if [[ -e "$(git rev-parse --show-toplevel)/.git" ]] ;then
        IS_GIT=1
    else
        IS_GIT=0
    fi

    # pull
    if [[ "$IS_GIT" = "1" ]];then
        git pull >> /dev/null 2>&1 &
    fi

    cd "$TARGET_DIR"
    case $SUB_COMMAND in
        list) _list_files ;;
        *) _create_new_file ;;
    esac

    # commit & push
    if [[ "$IS_GIT" = "1" ]];then
        if ! git status --porcelain >> /dev/null 2>&1; then
            exit
        fi
        git add "$FILE_PATH" \
            && git commit -m "updated" \
            && git push origin @ # >> /dev/null 2>&1
    fi
}

main
