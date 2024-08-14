require 'open-uri'
require 'nokogiri'
require 'faker'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# Clear existing data
Booking.destroy_all
Experience.destroy_all
User.destroy_all

# Real image URLs
image_url = {
  "Tokyo Sakura Festival" => "https://images.pexels.com/photos/4151484/pexels-photo-4151484.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "Gion Matsuri" => "https://images.pexels.com/photos/1876568/pexels-photo-1876568.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "Osaka Night Food Tour" => "https://images.pexels.com/photos/2070033/pexels-photo-2070033.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "Hiroshima Peace Memorial Tour" => "https://images.pexels.com/photos/14331552/pexels-photo-14331552.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "Nara Deer Park and Temple Tour" => "https://images.pexels.com/photos/18848732/pexels-photo-18848732/free-photo-of-a-deer-standing-next-to-old-stone-statues-in-the-nara-park-nara-japan.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "Sapporo Snow Festival" => "https://images.pexels.com/photos/20187381/pexels-photo-20187381/free-photo-of-sapporo-fushimi-inari-shrine-in-winter.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "Okinawa Cultural and Historical Tour" => "https://images.pexels.com/photos/19658288/pexels-photo-19658288/free-photo-of-ceramic-traditional-japanese-dog-statue.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "Nagano Zenko-ji Temple Tour" => "https://images.pexels.com/photos/25526698/pexels-photo-25526698/free-photo-of-five-storied-pagoda-in-tokyo.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "Nikko World Heritage Tour" => "https://images.pexels.com/photos/18848548/pexels-photo-18848548/free-photo-of-part-of-the-rinno-ji-temple-nikko-japan.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "Fukuoka Hakata Gion Yamakasa" => "https://images.pexels.com/photos/7968193/pexels-photo-7968193.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
}

# Event details
experiences = [
  { location: "Tokyo", title: "Tokyo Sakura Festival", content: "Enjoy the **enchanting** cherry blossom season with a guided tour through Ueno Park. Begin your journey with an early morning stroll beneath the blooming sakura trees, where the air is filled with the sweet scent of cherry blossoms. The tour includes a traditional tea ceremony, where you'll learn about the art of Japanese tea making and experience the serene ritual firsthand. As the day progresses, you'll explore hidden corners of the park, discovering local street food vendors offering a variety of seasonal treats such as sakura mochi and matcha-flavored sweets. The tour concludes with a breathtaking evening illumination, where the cherry blossoms are lit up, creating a magical atmosphere that is truly unforgettable." },
  { location: "Kyoto", title: "Gion Matsuri", content: "Experience the **vibrant** Gion Matsuri, one of Japan's most famous festivals, with a guided walk through the historical streets of Kyoto. The festival, which dates back over a thousand years, is a celebration of the city's rich cultural heritage. As you walk through the streets, you'll encounter the grand **Yamaboko floats**, which are intricately decorated with tapestries, carvings, and other ornate details. These floats are a testament to the city's craftsmanship and artistic tradition. Your guide will take you behind the scenes, where you'll meet local artisans and learn about the painstaking process of creating these floats. In the evening, you'll have the rare opportunity to visit a traditional tea house, where you'll be treated to an exclusive performance by a geisha, offering a glimpse into Kyoto's storied past." },
  { location: "Osaka", title: "Osaka Night Food Tour", content: "Explore Osaka's renowned food scene with a night tour that takes you through the bustling streets of Dotonbori. Begin your culinary adventure by sampling **delicious** Takoyaki, a popular street food made from batter and filled with diced octopus, green onions, and pickled ginger. As you continue your tour, you'll try Okonomiyaki, a savory pancake filled with a variety of ingredients, and other local delights that showcase Osaka's diverse food culture. The tour also includes a visit to a hidden **Izakaya**, where you'll taste rare **sake** and learn about the history and tradition behind this beloved Japanese drink. The evening ends with a sweet treat, as you sample some of Osaka's famous desserts while taking in the vibrant night atmosphere of the city." },
  { location: "Hiroshima", title: "Hiroshima Peace Memorial Tour", content: "Join a **deeply moving** guided tour of the Hiroshima Peace Memorial Park and Museum. Begin your visit with a solemn walk through the park, where you'll see the iconic **A-Bomb Dome**, a powerful reminder of the devastation caused by the atomic bombing. The tour includes a visit to the museum, where you'll learn about the history and impact of the bombing through exhibits that include personal stories, photographs, and artifacts from the time. You'll also have the opportunity to meet with survivors, known as hibakusha, who will share their experiences and insights on the importance of peace and nuclear disarmament. The tour concludes with a reflective moment at the **Cenotaph for the A-bomb Victims**, where you can pay your respects to those who lost their lives." },
  { location: "Nara", title: "Nara Deer Park and Temple Tour", content: "Spend a day visiting Nara's famous Todai-ji Temple and feeding the **friendly** deer in Nara Park. Your tour begins with a guided visit to Todai-ji, home to the world's largest bronze statue of Buddha, known as Daibutsu. As you explore the temple grounds, your guide will provide insights into the history and significance of this UNESCO World Heritage site, which dates back to the 8th century. After visiting the temple, you'll have the opportunity to interact with the free-roaming deer in Nara Park, which are considered sacred in Japanese culture. The deer are known for bowing to visitors in exchange for food, a behavior that has become a beloved tradition. The tour concludes with a peaceful stroll through the park, where you can enjoy the natural beauty of the area and learn more about Nara's role as the ancient capital of Japan." },
  { location: "Sapporo", title: "Sapporo Snow Festival", content: "Witness the **incredible** snow and ice sculptures at the Sapporo Snow Festival with a guided tour. This world-famous event, held annually in February, attracts visitors from all over the globe. Begin your tour with a visit to **Odori Park**, the festival's main site, where you'll see towering snow sculptures that depict everything from famous landmarks to characters from popular culture. As you walk through the park, your guide will share stories about the history of the festival and the artists who create these stunning works of art. The tour also includes a visit to the **Susukino** site, known for its impressive ice sculptures. In the evening, you'll enjoy a relaxing soak in a nearby hot spring, where you can warm up and unwind after a day of exploring. The tour concludes with a visit to a local restaurant, where you'll sample Hokkaido's famous seafood, including fresh crab and scallops." },
  { location: "Okinawa", title: "Okinawa Cultural and Historical Tour", content: "Discover Okinawa's unique culture and history with a comprehensive tour that takes you to some of the region's most iconic sites. Begin your journey with a visit to **Shurijo Castle**, a UNESCO World Heritage site that was once the center of the Ryukyu Kingdom. As you explore the castle's grounds, your guide will explain the significance of this historic site and its role in Okinawa's history. Next, you'll visit a local market, where you can sample traditional Okinawan foods and browse for unique souvenirs. The tour also includes a visit to a traditional Ryukyu village, where you'll have the opportunity to watch a **Ryukyu dance performance** and learn about the island's cultural traditions. The day concludes with a visit to a serene beach, where you can relax and enjoy the stunning ocean views." },
  { location: "Nagano", title: "Nagano Zenko-ji Temple Tour", content: "Explore the ancient Zenko-ji Temple in Nagano with a guided tour that offers both cultural insights and opportunities for personal reflection. Begin your visit with a **meditative** session led by a local monk, who will guide you through the principles of Zen meditation and mindfulness. After the session, you'll have the chance to explore the temple's extensive grounds, which include a number of historic buildings and sacred sites. Your guide will share stories about the temple's history and the legends associated with it, providing a deeper understanding of its significance. The tour also includes a walk through the temple's **underground passage**, known as the O-kaidan, where visitors can experience total darkness and seek the 'key to paradise.' The day concludes with a visit to a nearby **onsen**, where you can relax and soak in the natural hot spring waters while taking in views of the surrounding mountains." },
  { location: "Nikko", title: "Nikko World Heritage Tour", content: "Visit the UNESCO World Heritage sites in Nikko with a guided tour that showcases the region's natural beauty and historical significance. Begin your journey with a visit to the **magnificent** Toshogu Shrine, a mausoleum dedicated to Tokugawa Ieyasu, the founder of the Tokugawa shogunate. The shrine is known for its lavish decorations and intricate carvings, which your guide will explain in detail. After exploring the shrine, you'll take a scenic drive through the mountains to visit **Kegon Falls**, one of Japan's most famous waterfalls. The tour also includes a visit to **Lake Chuzenji**, where you can enjoy a peaceful boat ride and take in the stunning views of the surrounding mountains. As you travel through the region, your guide will share stories about the area's history and its importance in Japanese culture. The day concludes with a visit to a traditional ryokan, where you can relax and enjoy a kaiseki meal, a multi-course dinner that highlights local ingredients and seasonal flavors." },
  { location: "Fukuoka", title: "Fukuoka Hakata Gion Yamakasa", content: "Experience the **thrilling** Hakata Gion Yamakasa festival with a guided tour that takes you deep into the heart of Fukuoka's cultural traditions. The festival, which dates back over 700 years, is known for its elaborate races, where teams of men carry massive floats through the streets at breakneck speeds. Your tour begins with a visit to a local shrine, where you'll learn about the rituals and preparations that go into the festival. As you walk through the city, your guide will take you to key sites related to the festival, including the **Kushida Shrine**, where the main events take place. You'll also have the opportunity to meet with festival participants, who will share their experiences and the significance of this event in their lives. The tour includes a stop at a traditional **yatai**, or food stall, where you can sample local dishes such as Hakata ramen and mentaiko, a spicy cod roe. The day concludes with a visit to a local museum, where you can view historic artifacts related to the festival and gain a deeper understanding of its cultural importance." }

]

# create two users - guide and traveller

10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '123123' # needs to be at least 6 characters
  )
end

puts "Creating experience!"

experiences.each do |experience|
  exp = Experience.create!(
    location: experience[:location],
    title: experience[:title],
    content: experience[:content],
    photo_url: image_url[experience[:title]],
    price: rand(2000..5000),
    duration: rand(2..10),
    user: User.all.sample,
    latitude: 48.8649574 + rand(0.1..0.6),
    longitude: 2.380061 + rand(0.1..0.6),
  )
  file = URI.open(image_url[experience[:title]])
  exp.photo.attach(io: file, filename: "#{experience[:title].parameterize}.jpeg", content_type: 'image/jpeg')
end
puts "Seed data created!"

10.times do
  Booking.create!(
    experience: Experience.all.sample,
    user: User.all.sample,
    date: Date.today,
    status: rand(1..3) # needs to be at least 6 characters
  )
end

puts "Created #{Booking.count} bookings!"
