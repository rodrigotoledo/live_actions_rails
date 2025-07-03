# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/channels", under: "channels"
pin "@rails/actioncable", to: "actioncable.esm.js", preload: true
pin "morphdom", to: "https://ga.jspm.io/npm:morphdom@2.6.1/dist/morphdom.js", preload: true
pin "fireworks-js", to: "https://ga.jspm.io/npm:fireworks-js@2.10.0/dist/index.es.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
