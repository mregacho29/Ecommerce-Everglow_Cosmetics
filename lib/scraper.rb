require "net/http"
require "nokogiri"
require "faker"

class ProactivScraper
  def self.scrape_skincare
    # URL of the Proactiv skincare page
    url = URI("https://www.getproactiv.ca/category/acq-shop")

    # Make the HTTP request
    response = Net::HTTP.get_response(url)

    # Check for a successful response
    if response.code != "200"
      puts "Error: #{response.code}"
      return []
    end

    # Parse the HTML response
    doc = Nokogiri::HTML(response.body)

    # Debugging: Output the raw HTML to verify content
    # Uncomment the following line to inspect the HTML
    # puts doc.to_html

    # Array to store scraped products
    scraped_products = []

    # Loop through each product card
    product_cards = doc.css(".mz-productlisting") # Selector for product cards
    puts "Found #{product_cards.size} product cards"

    product_cards.each do |product_card|
      # Extract product details
      name = product_card.css("h2.productlisting_title").text.strip rescue nil
      description = product_card.css("div.productlisting_desc").text.strip rescue nil
      price = Faker::Commerce.price(range: 30.0..60.0) # Generate a random price
      image_url = product_card.css("div.mz-productlisting-image img").attr("src").value rescue nil

      # Debugging output
      puts "Name: #{name}, Description: #{description}, Price: #{price}, Image URL: #{image_url}"

      # Add the product to the array
      scraped_products << {
        name: name,
        description: description,
        price: price,
        image_url: image_url
      }
    end

    scraped_products
  end
end
