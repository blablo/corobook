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
        formated_lyric += "<span style='color:red'>"+line+"</span>" + "<br />"
      else
        prev_chords = false
        formated_lyric += line + "<br />"
      end
    end
    return raw formated_lyric
  end

end
