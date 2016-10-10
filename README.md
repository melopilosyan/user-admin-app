# UserAdminApp

Welcome to kind a user-admin-app.

This demo application operates with User objects with two roles: admins & general users. Simple login/logout system controles users enters into the app. Admins can be added anly with ```rake``` task.

General users can be registered with login form including full name, email, short bio and optional logo image. They can view & update specified info and save it as a PDF file.

Admins can do the same as regular users plus add, view, update and delete regular users.

#### System dependencies
Ruby 2.3.1

Rials 4.2.6

PostgreSQL database


#### Configuration
Copy `config/database.yml` to `config/database.template.yml` providing your postgres username and password.


#### Deployment instructions
```
bundle install && rake db:create db:migrate && rails s
```
###### Adding admin users
```
rake admin:create full_name='Your Name' email=your@email.com password=yourpassword
```

#### Author
[Meliq Pilosyan](https://github.com/melopilosyan)
