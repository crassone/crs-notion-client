# frozen_string_literal: true

require_relative "client/version"
require "httparty"

module Crs
  module Notion
    class Client
      attr_accessor :headers

      def initialize(notion_token: nil)
        @headers = {
          "Authorization" => "Bearer #{notion_token}",
          "Notion-Version" => "2021-05-13",
          "Content-Type" => "application/json"
        }
      end

      def get_page(id:)
        endpoint = "https://api.notion.com/v1/pages/#{id}"

        # HTTPartyを使ってGETリクエストを送信
        response = ::HTTParty.get(endpoint, headers:)
        raise "Notion API Error: #{response.code}, #{response.message}" if response.code != 200

        JSON.parse(response.body)
      end

      def create_database_item(database_id:, properties:)
        endpoint = "https://api.notion.com/v1/pages"

        body = {
          parent: { database_id: database_id },
          properties: properties
        }

        response = ::HTTParty.post(endpoint, headers: headers, body: body.to_json)
        raise "Notion API Error: #{response.code}, #{response.message}" if response.code != 200

        JSON.parse(response.body)
      end

      # データベースアイテムを更新するメソッド
      # @param id [String] 更新するアイテム（ページ）のID
      # @param properties [Hash] 更新するプロパティの情報
      # @return [Hash] 更新されたアイテムの情報
      def update_database_item(item_id:, properties:)
        endpoint = "https://api.notion.com/v1/pages/#{item_id}"

        body = {
          properties: properties
        }

        response = ::HTTParty.patch(endpoint, headers: headers, body: body.to_json)
        raise "Notion API Error: #{response.code}, #{response.message}" if response.code != 200

        JSON.parse(response.body)
      end
    end
  end
end
