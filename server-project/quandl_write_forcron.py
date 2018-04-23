import datetime
import time

import pandas as pd
import quandl
quandl.ApiConfig.api_key = 'YOUR-QUANDL-API-KEY'

import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, Float, String, MetaData, ForeignKey

from get_quandl import codes_per_exchange

date_today = datetime.date.today()
date_yesterday = datetime.date.today() - datetime.timedelta(5)

#with open(".pw", "r") as file:
 #   pw = file.read().strip("\n")


def main():

    engine = create_engine('mysql://root:MfLigRs$1901@127.0.0.1/quandl_futures')

    codes_per_xch = codes_per_exchange()

    omitted_rows = 0

    for exchange, list_of_codes in codes_per_xch.items():
        for code in list_of_codes:
        #for counter in range(2): #only get data for first two codes in every exchange
         #   code = list_of_codes[counter]

            df = quandl.get(code, rows =1)
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

if __name__ == '__main__':
    main()
