import datetime
import time

import pandas as pd
import quandl
quandl.ApiConfig.api_key = 'V_Wjo3oPLtefuTGpZgdF'

import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, Float, String, MetaData, ForeignKey

from get_quandl import codes_per_exchange

date_today = datetime.date.today()

with open(".pw", "r") as file:
    pw = file.read().strip("\n")


def main():

    engine = create_engine('mysql://root:%s@127.0.0.1/quandl_futures' % pw)

    codes_per_xch = codes_per_exchange()
    
    omitted_rows = 0

    for exchange, list_of_codes in codes_per_xch.items(): 
        for code in list_of_codes:

            #code = list_of_codes[1]

            df = quandl.get(code, start_date="1960-01-03", end_date=date_today)
            df.reset_index(inplace=True)    
            df.rename(index=str, columns={"Trade Date":"Date"}, inplace=True)
            df.insert(0,'Code', [code[6:] for i in range(len(df))])

            try:
                df.to_sql(exchange, engine, if_exists='append', index=False)
            except sqlalchemy.exc.OperationalError:
                omitted_rows += len(df)
                print("\nOmitted " + code) 
                continue
    
            print("\nSuccessfully written %s to quandl_futures" % code)
    
    print("\nDone")
    print("Omitted %i rows" % omitted_rows)

#def main():
#    omitted_rows = 0
#    engine = create_engine('mysql://root:%s@127.0.0.1/quandl_futures' % pw)
#
#    codes_per_xch = codes_per_exchange()
#    
#    exchange = 'ICE'
#    list_of_codes = codes_per_xch[exchange]
#    for k in [197,203]:
#        # 197 and 203
#        code = list_of_codes[k] 
#
#        df = quandl.get(code, start_date="1960-01-03", end_date=date_today)
#        df.reset_index(inplace=True)    
#        df.rename(index=str, columns={"Trade Date":"Date"}, inplace=True)
#        df.insert(0,'Code', [code[6:] for i in range(len(df))])
#        try:
#            df.to_sql(exchange, engine, if_exists='append', index=False)
#        except sqlalchemy.exc.OperationalError:
#            omitted_rows += len(df)
#            print("\nOmitted " + code) 
#            continue
#
#        print("\nSuccessfully written %s to quandl_futures" % code)

if __name__ == '__main__':
    main()
