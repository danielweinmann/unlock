class ApplicationController < ActionController::Base

  include Pundit
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :namespace, :add_headline_and_article!, :suppress_headline_and_article!, :add_headline_and_article?, :add_logo!, :suppress_logo!, :add_logo?, :locale_country

  after_action :verify_authorized, unless: -> {devise_controller? || self.class == HighVoltage::PagesController}
  after_action :verify_policy_scoped, unless: -> {devise_controller? || self.class == HighVoltage::PagesController}
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # This will send the current_user to the view and instantiate UserDecorator for it
  before_action :current_user

  before_filter :set_locale

  force_ssl if: :in_production?

  responders :flash, :location

  def in_production?
    Rails.env.production?
  end
    
  def add_headline_and_article?
    !@suppress_headline_and_article
  end

  def add_headline_and_article!
    @suppress_headline_and_article = false
  end

  def suppress_headline_and_article!
    @suppress_headline_and_article = true
  end

  def add_logo?
    !@suppress_logo
  end

  def add_logo!
    @suppress_logo = false
  end

  def suppress_logo!
    @suppress_logo = true
  end

  def namespace
    names = self.class.to_s.split('::')
    return "null" if names.length < 2
    names[0..(names.length-2)].map(&:downcase).join('_')
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) << :image
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:alert] = t('flash.not_authorized')
    redirect_to(request.referrer || root_path)
  end

  def set_locale
    if params[:locale]
      I18n.locale = params[:locale]
      current_user.try(:update, {locale: params[:locale]})
    elsif request.method == "GET"
      new_locale = current_user.try(:locale) || I18n.default_locale
      redirect_to url_for(params.merge(locale: new_locale, only_path: true))
    end
  end

  def locale_country(locale = nil)
    country = (locale || I18n.locale).to_s.split('-')
    country.size > 1 ? country[1].downcase : country[0]
  end

end
