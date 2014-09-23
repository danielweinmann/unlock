xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc root_url
    xml.priority 1.0
    xml.changefreq "daily"
  end

  @initiatives.each do |initiative|
    xml.url do
      xml.loc initiative_url(initiative)
      xml.priority 0.8
      xml.changefreq "daily"
      xml.lastmod initiative.updated_at.to_date
    end
  end

  xml.url do
    xml.loc page_url('credits')
    xml.priority 0.2
    xml.changefreq "monthly"
  end

end
