require_relative "facebook_photos"

class RenderFacebookPhotos < Liquid::Tag
  def initialize(tagName, text, tokens)
    super
    @text = text
  end

  def render(context)
    config = context.registers[:site].config

    app_id         = config['facebook']['app_id']
    app_secret     = config['facebook']['app_secret']
    callback_url   = config['facebook']['callback_url']
    username       = config['facebook']['username']
    exclude_albums = config['facebook']['exclude_albums']

    fb = FacebookPhotos.new(app_id, app_secret, callback_url, username, exclude_albums)

    html = ""

    fb.albums.each do |album|
      html << "<div class='facebook-photos'>\n"
      html << "  <h2>#{album.name}</h2>\n"

      album.photos.each do |photo|
        html << "  <a href='#{photo.source}' title='#{photo.caption}'>\n"
        html << "    <img src='#{photo.thumbnail}' height='100' width='100'>\n"
        html << "  </a>\n"
      end

      html << "</div>\n"
    end

    html
  end

  Liquid::Template.register_tag "facebook_photos", self
end
