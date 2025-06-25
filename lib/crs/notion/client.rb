# frozen_string_literal: true

require_relative "client/version"
require "httparty"

module Crs
  module Notion
    # Notion APIを操作する際に利用するクライアントクラス
    class Client
      attr_accessor :headers
      attr_reader :api_version

      API_BASE_URL = "https://api.notion.com/v1"

      def initialize(notion_token: nil)
        @headers = {
          "Authorization" => "Bearer #{notion_token}",
          "Notion-Version" => "2021-05-13",
          "Content-Type" => "application/json"
        }
      end

      def get_page(id:)
        request(:get, "pages/#{id}")
      end

      def create_database_item(database_id:, properties:)
        body = {
          parent: { database_id: database_id },
          properties: properties
        }

        request(:post, "pages", body)
      end

      # データベースアイテムを更新するメソッド
      # @param item_id [String] 更新するアイテム（ページ）のID
      # @param properties [Hash] 更新するプロパティの情報
      # @return [Hash] 更新されたアイテムの情報
      def update_database_item(item_id:, properties:)
        body = {
          properties: properties
        }

        request(:patch, "pages/#{item_id}", body)
      end

      # データベースから条件を満たすアイテムを検索するメソッド
      # @param database_id [String] データベースのID
      # @param filter [Hash] フィルタリング条件
      # @param page_size [Integer] 取得するアイテム数（デフォルト10件）
      # @return [Hash] 検索結果
      def search_database(database_id:, filter: nil, page_size: 10)
        body = {}
        body[:filter] = filter if filter
        body[:page_size] = page_size

        request(:post, "databases/#{database_id}/query", body)
      end

      private

      # 共通の API リクエスト処理メソッド
      def request(method, endpoint, body = nil)
        url = "#{API_BASE_URL}/#{endpoint}"

        response = case method
                   when :get
                     ::HTTParty.get(url, headers: headers)
                   when :post
                     ::HTTParty.post(url, headers: headers, body: body.to_json)
                   when :patch
                     ::HTTParty.patch(url, headers: headers, body: body.to_json)
                   end

        handle_response(response)
      end

      # レスポンス処理の共通メソッド
      def handle_response(response)
        raise "Notion API Error: #{response.code}, #{response.message}" if response.code != 200

        JSON.parse(response.body)
      end
    end
  end
end
