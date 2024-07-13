FROM ruby:3.3.4

# 必要なパッケージのインストールと、Node.jsセットアップスクリプトの取得
RUN apt-get update -qq && \
    apt-get install -y default-mysql-client && \
    curl -fsSL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs

# アプリケーションディレクトリの作成
RUN mkdir /myapp
WORKDIR /myapp

# Bundlerの更新
RUN gem install bundler

# GemfileとGemfile.lockのコピーと、bundleのインストール
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# aarch64-linuxプラットフォームの追加とbundle install
RUN bundle config set --local force_ruby_platform true && \
    bundle lock --add-platform aarch64-linux && \
    bundle install

# RubyGemsの更新
RUN gem update --system

# エントリーポイントスクリプトのコピーと実行権限の付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# コンテナ起動時に公開するポート
EXPOSE 3000

# Railsサーバー起動コマンド
CMD ["rails", "server", "-b", "0.0.0.0"]