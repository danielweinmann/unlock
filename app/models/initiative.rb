#coding: utf-8

class Initiative < ActiveRecord::Base
  
  belongs_to :user
  has_many :contributions

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates_presence_of :user, :name
  validates_uniqueness_of :permalink, allow_nil: true
  # Permalink cannot be a number, so it can't be confused with the id
  validates_format_of :permalink, :with => /[^\d]+/, allow_nil: true
  before_save do
    self.permalink = self.permalink.gsub(/[^0-9a-z]/i, '').downcase if self.permalink
  end
  
  def self.can_contribute
    where("moip_token IS NOT NULL AND moip_token <> '' AND moip_key IS NOT NULL AND moip_key <> '' AND permalink IS NOT NULL AND permalink <> ''")
  end
  
  def self.with_contributions
    where("id IN (SELECT DISTINCT initiative_id FROM contributions WHERE state = 1 AND NOT sandbox)")
  end
  
  def self.not_sandbox
    where('NOT sandbox')
  end
  
  def self.home_page
    can_contribute.not_sandbox.order("(SELECT coalesce(sum(value), 0) FROM contributions WHERE initiative_id = initiatives.id AND state = 1 AND contributions.sandbox = initiatives.sandbox) DESC, updated_at DESC")
  end
  
  require 'redcloth'

  AutoHtml.add_filter(:redcloth).with({}) do |text, options|
    result = RedCloth.new(text).to_html
    if options and options[:target] and options[:target].to_sym == :_blank
      result.gsub!(/<a/,'<a target="_blank"')
    end
    result
  end

  AutoHtml.add_filter(:vimeo).with(:width => 440, :height => 248, :show_title => false, :show_byline => false, :show_portrait => false) do |text, options|
    text.gsub(/https?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/) do
      vimeo_id = $2
      width  = options[:width]
      height = options[:height]
      show_title      = "title=0"    unless options[:show_title]
      show_byline     = "byline=0"   unless options[:show_byline]  
      show_portrait   = "portrait=0" unless options[:show_portrait]
      frameborder     = options[:frameborder] || 0
      query_string_variables = [show_title, show_byline, show_portrait].compact.join("&")
      query_string    = "?" + query_string_variables unless query_string_variables.empty?

      %{<iframe src="https://player.vimeo.com/video/#{vimeo_id}#{query_string}" width="#{width}" height="#{height}" frameborder="#{frameborder}"></iframe>}
    end
  end

  auto_html_for :first_text do
    html_escape map: {
      '&' => '&amp;',
      '>' => '&gt;',
      '<' => '&lt;',
      '"' => '"'
    }
    image
    youtube width: 600, height: 403, wmode: "opaque"
    vimeo width: 600, height: 403
    redcloth target: :_blank
    link target: :_blank
  end

  auto_html_for :second_text do
    html_escape map: {
      '&' => '&amp;',
      '>' => '&gt;',
      '<' => '&lt;',
      '"' => '"'
    }
    image
    youtube width: 600, height: 403, wmode: "opaque"
    vimeo width: 600, height: 403
    redcloth target: :_blank
    link target: :_blank
  end

  def to_param
    (self.permalink && self.permalink.parameterize) || "#{self.id}-#{self.name.parameterize}"
  end

  def can_contribute?
    self.moip_key.present? && self.moip_token.present? && self.permalink.present?
  end
  
end
