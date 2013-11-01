# add gems

#gem 'devise'
gem 'simple_form'
gem 'whenever'
gem 'kaminari'
gem 'hpricot'
gem 'ruby_parser'
gem 'jquery-rails'

gem "rspec-rails", :group => [ :development, :test ]
gem "ffaker", :group => :test
gem "autotest", :group => :test
#gem 'twitter-bootstrap-rails'
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
                          :github => 'anjlab/bootstrap-rails',
                          :branch => '3.0.0'
# install gems
run 'bundle install'

#generate "bootstrap:install", "static"
#generate "bootstrap:layout", "application", "fluid"

# Development only

file 'config/database.yml', <<-DB
development:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000
DB

run 'rm config/environments/production.rb config/environments/test.rb'


# Templates
file 'app/views/shared/_errors.html.erb', <<-ERRORS
<% if object.errors.any? %>
  <div class="alert alert-error">
    <a class="close" data-dismiss="alert">&#215;</a>
    <ul>
      <% object.errors.full_messages.each do |msg| %>
        <%= content_tag :li, msg %>
      <% end %>
    </ul>
  </div>
<% end %>
ERRORS


rake "db:create"

generate 'simple_form:install'
generate 'rspec:install'

inject_into_file "config/application.rb", :after => "config.filter_parameters += [:password]" do
  <<-eos

    # Customize generators
    config.generators do |g|
      g.stylesheets false
    end
  eos
end

# setup devise
#generate "devise:install"
#generate "devise User"
#generate "devise:views"
rake "db:migrate"


# remove defaults files
remove_file 'public/index.html'
remove_file 'rm app/assets/images/rails.png'



# add database.yml to .gitignore
run "echo 'config/database.yml' >> .gitignore"


# create pages
run "rails generate controller pages index home about contact help"


# Route
route "root to: 'pages#index'"

# add nav bars links

inject_into_file "app/views/layouts/application.html.erb", :after => '<body>' do
  <<-eos

<nav class="navbar navbar-default" role="navigation">
  <!-- Brand and toggle get grouped for better mobile display -->
  <div class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
      <span class="sr-only">Toggle navigation</span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand" href="#">Brand</a>
  </div>

  <!-- Collect the nav links, forms, and other content for toggling -->
  <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
    <ul class="nav navbar-nav">
      <li class="active"><a href="#">Link</a></li>
      <li><a href="#">Link</a></li>
      <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
        <ul class="dropdown-menu">
          <li><a href="#">Action</a></li>
          <li><a href="#">Another action</a></li>
          <li><a href="#">Something else here</a></li>
          <li class="divider"></li>
          <li><a href="#">Separated link</a></li>
          <li class="divider"></li>
          <li><a href="#">One more separated link</a></li>
        </ul>
      </li>
    </ul>
    <form class="navbar-form navbar-left" role="search">
      <div class="form-group">
        <input type="text" class="form-control" placeholder="Search">
      </div>
      <button type="submit" class="btn btn-default">Submit</button>
    </form>
    <ul class="nav navbar-nav navbar-right">
      <li><a href="#">Link</a></li>
      <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
        <ul class="dropdown-menu">
          <li><a href="#">Action</a></li>
          <li><a href="#">Another action</a></li>
          <li><a href="#">Something else here</a></li>
          <li class="divider"></li>
          <li><a href="#">Separated link</a></li>
        </ul>
      </li>
    </ul>
  </div><!-- /.navbar-collapse -->
</nav>

  eos
end

#injecting twitter bootstrap links to js
inject_into_file "app/assets/javascripts/application.js", :after => '//= require jquery_ujs' do
  <<-eos

//= require twitter/bootstrap
  eos
end


#injecting twitter bootstrap links to css
inject_into_file "app/assets/stylesheets/application.css", :after => '*= require_tree .' do
  <<-eos

*= require twitter/bootstrap
  eos
end
# setup git and initial commit
git :init
git :add => "."
git :commit => "-a -m 'initial commit'"

say <<-eos
  ============================================================================
  Your app is now available.
eos