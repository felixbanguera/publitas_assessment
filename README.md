# Assessment

The assessment assigned by Publitas for Back end.

Located at: http://challenge.publitas.com/backend.html

I downloaded the XML file and stored it under the `data` folder.
Also copied the External Service class under `external_service.rb`

## The Task

  I wrote a ruby script containing a class named `Assignment` with a public method `run` , Then created an instance of that class and called the `run` method `Assignment.new.run`. I created a private methods to keep separation of concerns and things as easy to read as possible.  

- For parsing the XML file and make it easy to read I used [Nokogiri](https://nokogiri.org/tutorials/parsing_an_html_xml_document.html)

- For each product, extracting the id, title and description I used the `at_xpath` and `content` methods. (I had to use the `&.` for content given some of the products didn't have a title or a description.

- For creating the batches, I had to keep track of an approximately memory size of the batch what I did was store an accumulative value and get the size of each batch, and validate if the size was going to go over. I used `.to_json.size` to do it, maybe there are some gems that could help doing this but I preferred to use plain ruby and what I already know to keep it simple.

  
## How to run

```
bundle install
ruby assignment.rb
```
  The ruby version used was `ruby 2.6.3p62` 

## Example of Results in terminal

    Received batch   1
    Size:       4.79MB
    Products:    14084
    
    Received batch   2
    Size:       4.79MB
    Products:    14369
    
    Received batch   3
    Size:       4.79MB
    Products:    16842
    
    Received batch   4
    Size:       1.84MB
    Products:     4776

## The principles applied
- Don't repeat yourself.
- Keep it simple.
- Separation of concerns.
- Use what's already built.
