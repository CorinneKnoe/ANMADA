# server-project :chart_with_upwards_trend:

This folder contains the files used to to pull millions of futures data points from Quandl to an SQL database on a server with only a few lines of python code. As the futures are listed at different exchanges, which all come with different table structures, we create one table for each exchange. This can later be rearranged into a more tall structure.

First, have a look at the [server_setup_documentation](https://github.com/CorinneKnoe/ANMADA/blob/master/server-project/server_setup_documentation.pdf), which contains the steps we took to set up our personal data server from scratch (using DigitalOcean).

[sort_codes.py](https://github.com/CorinneKnoe/ANMADA/blob/master/server-project/sort_codes.py) contains the function `codes_per_exchange`, which reads in a csv file and returns a dictionary that maps all codes needed to read from Quandl to their respective exchange.

[make_tables.py](https://github.com/CorinneKnoe/ANMADA/blob/master/server-project/make_tables.py) connects to the SQL database and creates one table per exchange, with the columns corresponding to that specific exchange.

[quandl_write](https://github.com/CorinneKnoe/ANMADA/blob/master/server-project/quandl_write.py) is the heart of our project. It loops through all 15 exchanges, and for each pulls the data from Quandl and writes it directly into the SQL database on our server. 

After all of this, our database looks like the following:

[Image](https://github.com/CorinneKnoe/ANMADA/blob/master/server-project/screenshots/tables.png)

On a second server, we set up a cron demon that pulls the future data daily (at a set time on weekdays) and stores it in the respective table. 
