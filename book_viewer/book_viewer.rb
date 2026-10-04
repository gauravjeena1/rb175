require "tilt/erubi"
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapter/:number" do
  number = params[:number].to_i

  #guard for out of bound chapter numbers
  redirect "/" unless (1..@contents.size).include?(number)
  
  @chapter = File.read("data/chp#{params[:number]}.txt")

  chapter_index = params[:number].to_i - 1
  @title = "Chapter #{params[:number]}: #{@contents[chapter_index]}"

  erb :chapter
end

get "/search" do
  search_for = params[:query]
  @found = {}

  if !search_for.nil? && search_for != ""
    (1..@contents.size).each do |number|
      @chapter = File.read("data/chp#{number}.txt")
      if @chapter.include?(search_for)
        @found[number] = paragraphs_found
      end
    end
  end

  erb :search
end

helpers do
  #used by chapter.erb
  def in_paragraphs(content)
    paragraphs = content.split("\n\n")

    paragraphs.map.with_index do |paragraph, index|
      "<p id= \"paragraph-#{index}\">#{paragraph}</p>"
    end.join
  end

  #used by search.erb
  def highlight_query(paragraph)
    paragraph.gsub(params[:query], %(<strong>#{params[:query]}</strong>))    
  end
end

not_found do
  redirect "/"
end

def paragraphs_found
   paragraphs = @chapter.split("\n\n")
   result = []
        
    paragraphs.each_with_index do |paragraph, id|
      if paragraph.include?(params[:query])
        result << [paragraph, id]
      end
    end
    result
end