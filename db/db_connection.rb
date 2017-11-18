database = "myapp_development" # set your DB name here
user     = '' # set your DB user here
password = '' # set your DB password here
host     = '127.0.0.1' # set your DB Host here
DB = Sequel.connect(adapter: "postgres", 
                    database: database, 
                    host: host, 
                    user: user, 
                    password: password)
