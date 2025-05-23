[![Build and Commit Gem](https://github.com/crassone/crs-notion-client/actions/workflows/build-and-commit-gem.yml/badge.svg)](https://github.com/crassone/crs-notion-client/actions/workflows/build-and-commit-gem.yml)
[![Ruby](https://github.com/crassone/crs-notion-client/actions/workflows/main.yml/badge.svg)](https://github.com/crassone/crs-notion-client/actions/workflows/main.yml)

# Crs::Notion::Client

## 📖 使用方法:

```ruby
require 'crs/notion/client'

# 1. Clientインスタンスを作成
client = Crs::Notion::Client.new(notion_token: "your_token_here")

# 2. ページを取得
page = client.get_page(id: "your_page_id_here")

# 3. 取得したデータを使用
puts page['properties'] # ページのプロパティ
puts page['url']        # ページのURL
```
