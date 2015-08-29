module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def chordify(lyric)
    lines = lyric.split(/\n/)
    formated_lyric = ""
    prev_chords = false
    lines.each do |line|
      if line =~ /\b[CDEFGAB]m?7?\b/ and !prev_chords
        prev_chords = true
        formated_lyric += "<span style='color:red'>"+line+"</span>"
        formated_lyric += "\n" if Rails.env.development?
      else
        prev_chords = false
        formated_lyric += line
        formated_lyric += "\n" if Rails.env.development?
      end
    end
    return raw formated_lyric
  end

  def chordify2(lyric)
    return if lyric.nil?

    text = lyric.inject("") do |sum, line|
      if line[:type] == :chords
        sum += "<span style='color:red'>" + line[:line] + "</span><br />"
      else
        sum += line[:line] + "<br />"
      end
    end

    return raw text

  end

  def format_verse(verse)
    return verse.inject("") do |sum, line|
      
      if line[:type] == :chords
        sum += "<span style='color:red'>" + line[:line] + "</span><br />"
      else
        sum += line[:line] + "<br />"
      end
    end
    
  end


  def format_verse_diapo(verse)
    text = verse.inject("") do |sum, line|
      
      if line[:type] == :text
        sum += line[:line] + "<br />"
      end
    end
    return raw text
  end
  
  
  def chordify3(lyric, order)
    text = ""

    order.each_with_index do |verse, index|
      tmp_verse = Marshal.load( Marshal.dump( lyric[verse] ) )
      if  order[index] == order[index+1]
        lyric[verse].second[:line].prepend('/')
        lyric[verse].last[:line].prepend('/') 
      end
      text += "<h5>" + verse + "</h5>" if  order[index] != order[index-1]
      text += "<pre>" + format_verse(lyric[verse]) + "</pre><br />" if  order[index] != order[index-1]
      lyric[verse] = tmp_verse
    end

    return raw text
  end


end
