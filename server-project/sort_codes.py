"""
The quandl Continuous Futures dataset consists of of 15 different exchanges 
and each exchange lists different futures. These futures are represented by a code.

The format for continuous contracts is CHRIS/{EXCHANGE}_{CODE}{NUMBER},
where {NUMBER} is the "depth" associated with the chained contract. For
instance, the front month contract has depth 1, the second month contract
has depth 2, and so on.
e.g. : CHRIS/EUREX_F2CR1

We want to distinguish the codes based on which exchange it is related to.
"""
import datetime
import time

import pandas as pd
import quandl

today = datetime.date.today()

def codes_per_exchange(filename):
    """
    Reads a csv file of all codes. Provided by quandl, here:
    https://www.quandl.com/data/CHRIS-Wiki-Continuous-Futures/documentation/introduction    

    and assigns all the codes to their respective exchange. 

    In:
        name of the file, including extension
    Returns:
        codes_per_xch: dict that maps an exchange name string (eg 'EUREX') to
            a list of strings (eg. ['CHRIS/EUREX_FEUA1', '...'])
    """
    # first, we read a local csv file that contains codes and their corresponding
    # names for the continuous contracts for all 600 futures on Quandl
    codes = pd.read_csv(filename, header=0, names=["code","name"]) 
    
        
    # we don't need the names, only the codes
    codes = codes["code"]
    
    #print("Number of Contracts: %i" % len(codes))
    # Number of Contracts: 4046
     
    # next, we need to distinguish all different exchanges that list futures
    # (because they provide different column headers) 
    unique_names = []
    for code in codes:
        start_of_code = code[0:code.find('_')]
        if not start_of_code in unique_names: 
           unique_names.append(start_of_code) 
    
    list_of_exchanges = [name[6:] for name in unique_names]
    
    #print(list_of_exchanges)
    #['EUREX', 'SHFE', 'SGX', 'MCX', 'MGEX', 'ASX', 'LIFFE', 'OSE', 'MX', 'TFX',
    #'CME', 'ICE', 'CBOE', 'ODE', 'HKEX']
    #print(len(list_of_exchanges))
    # 15
    
    # sort the codes per exchange
    # we use a dictionary here which maps the exchange name to a list of all codes
    # belonging to that exchange
    codes_per_xch = {exchange : [] for exchange in list_of_exchanges} 
    for code in codes:
        start_of_code = code[0:code.find('_')]
        exchange_name = start_of_code[6:]
        codes_per_xch[exchange_name].append(code)

    return codes_per_xch

 
def identify_unique_columns(codes_per_exchange):
    """
    write all column headers to a txt file for later usage
    (this is not really needed for the main functionality, but nice to have)
    """
    all_columns = []
    for exchange, list_of_codes in codes_per_exchange.items():
        # we only need one code per exchange in order to see its column headers
        # assumes that the data delivered per exchange is identically formated
        print("\n")
        print(list_of_codes[0])
        
        df = quandl.get(list_of_codes[0], start_date="1960-01-03", end_date=today,
                api_key='V_Wjo3oPLtefuTGpZgdF')
    
        for column in df.columns:
            if column not in all_columns:
                all_columns.append(column)
                #print(column)
    
        # wait 0.35 seconds because there are limits on queries
        time.sleep(0.35)
    
    print(all_columns)
    
    with open('columns.txt', 'a') as file:
        for column in all_columns:
            file.write(column + "\n")


def get_columns():
    """
    get all column headers:
    """
    with open('columns.txt', 'r') as file:
        columns = file.read().split("\n")
    return columns


def main():
      pass

if __name__ == '__main__':
    main()
