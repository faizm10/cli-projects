myapp/
  app/
    controllers/     # web endpoints (TripsController, EventsController)
    models/          # business objects (Trip, Event, Expense)
    views/           # ERB templates rendered by controllers
    javascript/      # Stimulus controllers, Turbo config (Hotwire)
    channels/        # ActionCable (real-time)
    jobs/            # background work via ActiveJob (Sidekiq)
    mailers/         # email classes (InviteMailer)
    helpers/         # small view helpers
  config/
    routes.rb        # URL → controller mapping
    environments/    # dev/test/prod config
    credentials.yml.enc # secrets (mailer keys, etc.)
  db/
    migrate/         # migration files (schema changes)
    schema.rb        # current DB shape
    seeds.rb         # seed data
  bin/               # rails, rake shims
  lib/               # custom modules/tasks
  storage/           # ActiveStorage files (local dev)
  test/ or spec/     # tests
