class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @tags = Tag.where(name: tags_keywords[@category.name]) # Fetch tags for the category
    @products = @category.products

    if params[:tag]
      @products = @products.joins(:tags).where(tags: { name: params[:tag] })
    end
  end

  private

  def tags_keywords
    {
      "Skincare" => [ "moisturizers", "treatments", "cleanser", "hydrating", "serum", "spf" ],
      "Makeup" => [ "lip", "cheek", "eye", "blush", "bronzer", "highlighter", "contour" ],
      "Pencil" => [ "eyeliner", "mascara", "eye pencil", "brow pencil", "kohl", "sharpener" ],
      "Lipstick" => [ "cream", "liquid lipstick", "matte", "gloss", "lip balm", "lip stain" ],
      "Liquid" => [ "foundation", "marker", "eyeliner", "concealer", "serum", "tint" ],
      "Powder" => [ "setting powder", "foundation", "blush", "bronzer", "highlighter", "compact" ]
    }
  end
end
