RailsAdmin.config do |config|

  config.authorize_with do
    authenticate_or_request_with_http_basic('Admin login') do |username, password|
      username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  config.model Source do
    include_all_fields
    exclude_fields :words, :articles, :occurrences
  end

  config.model Article do
    include_all_fields
    exclude_fields :words, :occurrences
  end

  config.model Word do
    include_all_fields
    exclude_fields :articles, :occurrences
  end
end
