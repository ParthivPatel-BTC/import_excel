class ProductsController < ApplicationController
  include Sidekiq::Status::Worker
  
  def index
    @product = Product.new
    @products = Product.order(:title).page(params[:page]).per(10) rescue nil

    @polling = params[:polling]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    begin
      params[:product][:file].each do |file|
        ImportProductWorker.perform_async(file.original_filename, file.path)
      end
    rescue Exception => e
      Rails.logger.error "Import products : Failed to import products"
      Rails.logger.error "#{e.backtrace.first}: #{e.message} (#{e.class})"
    end
    flash[:warning] = 'Import products process is running. Please wait...'
    redirect_to root_url(polling: params[:polling])
  end

  def check_status
    @polling_processes = Polling.where(is_running: true).count
    respond_to do |format|
      format.html
      format.js
    end
    flash[:notice] = 'Products imported'
  end
end
