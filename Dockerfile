FROM ruby:3.3.4

# 必要なパッケージのインストールと、Node.jsセットアップスクリプトの取得
RUN apt-get update -qq && \
    apt-get install -y default-mysql-client && \
    curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# アプリケーションディレクトリの作成
WORKDIR /myapp

# Bundlerの更新
RUN gem install bundler

# GemfileとGemfile.lockのコピー
COPY Gemfile Gemfile.lock ./

# bundle installの実行
RUN bundle config set --local force_ruby_platform false && \
    bundle lock --add-platform aarch64-linux x86_64-linux && \
    bundle install

# RubyGemsの更新
RUN gem update --system

# アプリケーションコードのコピー
COPY . .

# エントリーポイントスクリプトの実行権限付与
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

# コンテナ起動時に公開するポート
EXPOSE 3000

# Railsサーバー起動コマンド
CMD ["./bin/dev"]