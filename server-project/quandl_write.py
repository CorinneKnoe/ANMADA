import datetime
import time
import getpass

import pandas as pd
import quandl

import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, Float, String, MetaData, ForeignKey

from sort_codes import codes_per_exchange

date_today = datetime.date.today()

def main():
    """
    Pulls futures data from Quandl and writes it to the corresponding local
    mysql database table.

    Requires:
        existing local mysql database named "quandl_futures" .
        Existing tables with named after the 15 futures exchanges listed by Quandl.
        the tables should first be created by the code in "make_tables.py"
    """
    # get the necessary information from user 
    quandl.ApiConfig.api_key = raw_input("quandl API Key: ") 

    user = raw_input("Mysql Username: ")
    pw = getpass.getpass()
    
    #sqlalchemy uses an engine object to connect to a specific database
    engine = create_engine('mysql://%s:%s@127.0.0.1/quandl_futures' % (user, pw))
   
    codes_per_xch = codes_per_exchange('codes.csv')
    
    omitted_rows = 0

    # for every exchange
    for exchange, list_of_codes in codes_per_xch.items(): 

        # for every code in this exchange 
        for code in list_of_codes:
            
            # get the data from quandl and store it in a pandas dataframe
            df = quandl.get(code, start_date="1960-01-03", end_date=date_today)

            # do some manipulations
            df.reset_index(inplace=True)    
            df.rename(index=str, columns={"Trade Date":"Date"}, inplace=True)

            # make a new column containing the code in every entry
            df.insert(0,'Code', [code[6:] for i in range(len(df))])

            # we ignore all errors that sqlalchemy throws at us because the
            # columns do not match. this loses some data, which we keep track
            # of by a counter named "omitted_rows", which is printed at the end 
            try:
                # write our local dataframe to the database (pandas has a function
                # "to_sql", which servers exactly this purpose)
                df.to_sql(exchange, engine, if_exists='append', index=False)
                print("\nSuccessfully written %s to quandl_futures" % code)

            # if we get an error from sqlalchemy, we simply ignore it 
            # this is a bit hacky, but sometimes the column strucutre even inside
            # of one exchange does not match.
            except sqlalchemy.exc.OperationalError:
                omitted_rows += len(df)
                print("\nOmitted " + code) 
                continue
    
    
    print("\nDone")
    print("Omitted %i rows" % omitted_rows)

if __name__ == '__main__':
    main()
