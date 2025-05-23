#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "lib/crs/notion/client"
require "httparty"
require "json"

puts "🚀 Crs::Notion::Client の動作確認を開始するよ〜！"

# Notionトークンを設定
notion_token = "secret_aJAqhVrbFnl3GgwC5kIRPyJBbUF1OaQ4htMyy2zR20b"

begin
  # Clientインスタンスを作成
  puts "\n📝 Clientインスタンスを作成中..."
  client = Crs::Notion::Client.new(notion_token: notion_token)
  puts "✅ Clientインスタンス作成完了！"

  # ヘッダー情報を表示
  puts "\n🔧 設定されたヘッダー情報:"
  client.headers.each do |key, value|
    # トークンの一部だけ表示（セキュリティのため）
    if key == "Authorization"
      token_part = value.split("_")[0] # "Bearer secret" 部分を取得
      display_value = "#{token_part}_***"
    else
      display_value = value
    end
    puts "  #{key}: #{display_value}"
  end

  # サンプルページID（実際のページIDに置き換えてください）
  # 注意：このIDは例なので、実際に存在するページIDを使ってください
  sample_page_id = "eb72cd429706412b8413595ec25c775e"

  puts "\n🔍 ページ取得テストを実行中..."
  puts "対象ページID: #{sample_page_id}"

  # get_pageメソッドをテスト
  page_data = client.get_page(id: sample_page_id)

  puts "✅ ページ取得成功！"
  puts "📄 取得したページ情報:"
  puts JSON.pretty_generate(page_data)
rescue StandardError => e
  puts "\n❌ エラーが発生しました:"
  puts "エラータイプ: #{e.class}"
  puts "エラーメッセージ: #{e.message}"

  if e.message.include?("Notion API Error")
    puts "\n💡 対処法:"
    puts "1. Notionトークンが正しいか確認してください"
    puts "2. ページIDが存在するか確認してください"
    puts "3. ページへのアクセス権限があるか確認してください"
  end
end

puts "\n🎉 動作確認テスト完了！"

# 使用例のコメント
puts <<~USAGE

  📖 使用方法:

  # 1. Clientインスタンスを作成
  client = Crs::Notion::Client.new(notion_token: "your_token_here")

  # 2. ページを取得
  page = client.get_page(id: "your_page_id_here")

  # 3. 取得したデータを使用
  puts page['properties'] # ページのプロパティ
  puts page['url']        # ページのURL

USAGE
