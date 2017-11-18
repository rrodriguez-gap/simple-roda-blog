database = "myapp_development"
user     = 'postgres'
password = '' # Set credentials here
DB = Sequel.connect(adapter: "postgres", 
                    database: database, 
                    host: "127.0.0.1", 
                    user: user, 
                    password: password)
