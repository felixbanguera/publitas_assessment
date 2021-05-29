require 'nokogiri'
require 'pry'
require 'json'
require 'objspace'
require_relative 'external_service.rb'

class Assignment

  def run
    # Reading and parsing the feed.xml file
    doc = File.open("data/feed.xml") { |f| Nokogiri::XML(f) }

    # Getting the batches of parsed items
    parsed_items = get_parsed_items_from_doc(doc)

    # Calling the external service
    call_external_service(parsed_items)
  end

  private

  def get_parsed_items_from_doc(doc)
    {}.tap do |itm_ary_objs|
      # Using counters of batches and sizes to keep track
      counter = 1
      itm_ary_objs[counter] = {ary: [], aprox_size: 0}

      # Iterarting all items in the doc
      doc.xpath('//item').each do |item|
        # Parsing items to hash using the method in the FeedParser Module
        parsed_item = parse_item(item)

        # Calculating size of new item
        parsed_item_size = get_js_size(parsed_item)

        # Creating a nother batch in case the size goes over 5MB
        counter += 1 unless (parsed_item_size + itm_ary_objs[counter][:aprox_size]) < 5_000_000
        itm_ary_objs[counter] ||= {ary: [], aprox_size: 0}

        # Adding the parsed item to the batch
        itm_ary_objs[counter][:ary].push(parsed_item)
        itm_ary_objs[counter][:aprox_size] += parsed_item_size
      end
    end
  end

  def parse_item(item)
    {
      id: get_content_for_child(item, "g:id"),
      title: get_content_for_child(item, "title"),
      description: get_content_for_child(item, "description")
    }
  end
  
  def get_content_for_child(item, child)
    item.at_xpath(child)&.content
  end

  def get_js_size(obj)
    obj.to_json.size
  end

  def call_external_service(parsed_items)
    # Creating a single instance of ExternalService
    ext_service = ExternalService.new

    # Iterarting the batches to call the external service's call method

    parsed_items.values.each do |items_info| 
      ext_service.call(items_info[:ary].to_json)
    end
  end
end

Assignment.new.run


