import datetime
import time

import numpy as np
import pandas as pd

import quandl
quandl.ApiConfig.api_key = 'V_Wjo3oPLtefuTGpZgdF'

import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import DateTime, Table, Column, Integer, Float, String, MetaData, ForeignKey
metadata = MetaData()

from get_quandl import codes_per_exchange

def main():
    """
    Automated table creation in our sql database.
    Creates one table for each exchange, because they use different columns
    """
    raise Exception("the tables have already been created, don't do it again")

    date_today = datetime.date.today()
    
    with open(".pw", "r") as file:
        pw = file.read().strip("\n")
    
    engine = create_engine('mysql://root:%s@127.0.0.1/quandl_futures' % pw)
    
    # a dictionary that maps the exchange name to a list of all codes of that exch.
    codes_per_xch = codes_per_exchange('codes.csv')
    
    for exchange, list_of_codes in codes_per_xch.items():
       
        # we simply use the first code as a template for getting the column names
        # this assumes that the exchange is consistent in its supply of columns
        df = quandl.get(list_of_codes[0], start_date="1960-01-03", end_date=date_today)
        
        finance = Table(exchange, metadata,
                    Column('Id', Integer, primary_key=True),
                    Column('Code', String(20)),
                    Column('Date', DateTime),
                    *[Column(column_name, Float) for column_name in df.columns]          
                        )
        
        metadata.create_all(engine)
    
        print("Table %s successfully created in Database quandl_futures\n" % exchange)
    
        # wait 0.35 seconds because quandl has limits for queries to its API
        time.sleep(0.35)
        
        
if __name__ == '__main__':
    main()

