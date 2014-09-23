#coding: utf-8

class Initiative < ActiveRecord::Base
  
  belongs_to :user
  has_many :contributions

  validates_presence_of :user, :name
  
  require 'redcloth'

  AutoHtml.add_filter(:redcloth).with({}) do |text, options|
    result = RedCloth.new(text).to_html
    if options and options[:target] and options[:target].to_sym == :_blank
      result.gsub!(/<a/,'<a target="_blank"')
    end
    result
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

  before_create do
    self.permalink = self.name unless self.permalink.present?
  end

  def to_param
    "#{self.id}-#{self.permalink.parameterize}"
  end

end
