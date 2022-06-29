# frozen_string_literal: true

module Admin
  module Products
    class BuildProducts < ApplicationService
      def call
        products = take_products
        create_structure
        build_product_object(products)
      end

      private

      def take_products
        Product.order(created_at: :desc)
      end

      def create_structure
        Struct.new(
          'Products',
          :total_products,
          :total_active_products,
          :total_inactive_products,
          :products_list,
          keyword_init: true
        )
      end

      def build_product_object(products)
        products_params =
          {
            total_products: products.count,
            total_active_products: products.where(active: true).count,
            total_inactive_products: products.where(active: false).count,
            products_list: products,
          }

        Success Struct::Products.new(products_params)
      end
    end
  end
end
