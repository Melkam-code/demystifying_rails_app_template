class ApplicationController < ActionController::Base
    def hello_world
        render inline: '<em>"Hello World!"</em>'
    end
end
