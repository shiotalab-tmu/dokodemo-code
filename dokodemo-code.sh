# VS Codeのターミナルでない場合のみ，カスタムcodeコマンドを定義
if [ "$TERM_PROGRAM" != "vscode" ]; then
  code() {
    # オプション解析
    local new_window=1  # デフォルトは新しいウィンドウで開く
    local target_path=""

    while [ $# -gt 0 ]; do
      case "$1" in
        -n|--new-window)
          new_window=1
          shift
          ;;
        -r|--reuse-window)
          new_window=0
          shift
          ;;
        -*)
          echo "Error: Unknown option: $1" >&2
          return 1
          ;;
        *)
          target_path="$1"
          shift
          ;;
      esac
    done

    [ -z "$target_path" ] && target_path="."

    # 絶対パスを確定（ファイルなら :0:0 を付与）
    local abs_path_raw=""
    local is_file=0

    if [ -d "$target_path" ]; then
      abs_path_raw="$(cd "$target_path" && pwd)"
    elif [ -f "$target_path" ]; then
      abs_path_raw="$(cd "$(dirname "$target_path")" && pwd)/$(basename "$target_path")"
      is_file=1
    elif [ -e "$target_path" ]; then
      abs_path_raw="$(realpath "$target_path" 2>/dev/null || readlink -f "$target_path" 2>/dev/null)"
      [ -f "$abs_path_raw" ] && is_file=1
    else
      echo "Error: Path not found: $target_path" >&2
      return 1
    fi

    if [ -z "$abs_path_raw" ]; then
      echo "Error: Failed to resolve absolute path: $target_path" >&2
      return 1
    fi

    local abs_path="$abs_path_raw"
    [ "$is_file" -eq 1 ] && abs_path="${abs_path}:0:0"

    # SSH接続判定
    local is_ssh=0
    if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
      is_ssh=1
    fi

    # VS Code URL
    local vscode_url=""
    if [ "$is_ssh" -eq 1 ]; then
      local ssh_host="${VSCODE_SSH_HOST:-$(hostname)}"
      vscode_url="vscode://vscode-remote/ssh-remote+${ssh_host}${abs_path}"
    else
      vscode_url="vscode://file${abs_path}"
    fi

    # open in new window flag (default)
    if [ "$new_window" -eq 1 ]; then
      vscode_url="${vscode_url}?windowId=_blank"
    fi

    # OSC 8リンク生成（labelは %b で解釈させる）
    __osc8() {
      local url="$1"
      local label="$2"
      printf '\e]8;;%s\e\\%b\e]8;;\e\\' "$url" "$label"
    }

    # 青色のボタンにする（背景=青，文字=白，太字）
    local btn_label=$'\e[1m\e[44m\e[37m  Ctrl+🖱️  Open in VSCode  \e[0m'

    printf '%b\n' "$(__osc8 "$vscode_url" "$btn_label")"
  }
fi
