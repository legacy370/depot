# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.delete_all
Product.create!(title: 'Build Chatbot Interactions',
  description:
    %{<p><em>Responsive, intuitive interfaces with Ruby</em>
    The next step in the evolution of user interfaces in here.  Chatbots let your users interact with your service in their own natural language.  </p>},
    image_url: 'dpchat.jpg',
    price: 20.00)
