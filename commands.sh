#!/bin/bash

# 使用方法を表示する関数
show_usage() {
    echo "使用方法: ./docker-commands.sh [コマンド]"
    echo "利用可能なコマンド:"
    echo "  up          - コンテナを起動"
    echo "  down        - コンテナを停止"
    echo "  bash        - Webコンテナ内でBashセッションを開始"
    echo "  bundle      - bundle installを実行"
    echo "  rails       - rails コマンドを実行 (例: ./docker-commands.sh rails db:migrate)"
    echo "  rspec       - RSpecテストを実行"
    echo "  logs        - コンテナのログを表示"
    echo "  restart     - コンテナを再起動"
    echo "  build       - イメージを再ビルド"
}

# コマンドライン引数をチェック
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

# コマンドを実行
case "$1" in
    up)
        docker-compose up -d
        ;;
    down)
        docker-compose down
        ;;
    bash)
        docker-compose exec web bash
        ;;
    bundle)
        docker-compose exec web bundle install
        ;;
    rails)
        shift
        docker-compose exec web rails "$@"
        ;;
    rspec)
        docker-compose exec web bundle exec rspec
        ;;
    logs)
        docker-compose logs -f
        ;;
    restart)
        docker-compose restart
        ;;
    build)
        docker-compose build
        ;;
    *)
        echo "不明なコマンド: $1"
        show_usage
        exit 1
        ;;
esac