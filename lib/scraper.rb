require 'open-uri'
require 'pry'

class Scraper

  students = []

  def self.scrape_index_page(index_url)
    students = []
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    doc.css(".student-card").each do |student_card|
      student_data = {}
      student_data[:name] = student_card.css(".student-name").text
      student_data[:location] = student_card.css(".student-location").text
      student_data[:profile_url] = student_card.css("@href").to_s
      students << student_data
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    

    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    temp = []

    links = doc.css(".social-icon-container a @href")
    links.each{|link| temp << link.text}

    output = {}
    temp.each do |link|
      if link.include?("twitter")
          output[:twitter] = link
        elsif link.include?("linkedin")
          output[:linkedin] = link
        elsif link.include?("github")
          output[:github] = link
        else
          output[:blog] = link
      end
    end

    output[:profile_quote] = doc.css(".profile-quote").text    
    output[:bio] = doc.css(".description-holder p").text 
    output
    
  end

end

