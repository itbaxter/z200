import sys, numpy
    
from netCDF4 import Dataset , netcdftime , num2date
#TODO change variable names to something more obvious like year/month/etc
#TODO read variable lengths from netcdf file instead of hard coding them
def extractTime(ncdata):
    """Takes in a NETCDF4 file
        Returns a list of strings representing year-month-day hour:minutes
        Note: string returned has been modified to only return complete 12 month years
    """
    tname = 'time'
    nctime = ncdata.variables[tname][:]
    t_unit = ncdata.variables[tname].units
    t_cal = ncdata.variables[tname].calendar
    tvalue = num2date(nctime,units = t_unit,calendar = t_cal)
    str_time = [i.strftime("%Y-%m-%d %H:%M") for i in tvalue]

    #TODO Add first year of data from feb-dec
    #TODO Add last year January
    str_time_truncated=str_time[11:-1]
    return str_time_truncated
      

def AverageDataSet(ncdata):
    """ Reads in a file containing monthly average temperature values for each multiple years at a range of locations
    
    Returns a singly numpy array of length 12 containing the average of all the monthly temperature values for each month"""
    print (ncdata.dimensions.keys())
    print (ncdata.file_format)    

    temp = ncdata.variables['T850'][:]
    averagedTemps=[]

    #Manipulate time to be of use to us - produce an array of all years where each row is 1 year's worth of dates
    str_time=extractTime(ncdata)
    years=[]
    for i in range(0,int(len(str_time)/12),12):
        years.append(str_time[i:i+11])


#    averagedTemps=np.arange(12)
#    for i in range(0,len(ncdata.variables['lon'])):  #LONG
    AverageValuesDS= numpy.zeros((2,2,12),float)
    for i in range(0,2):  #LONG
        print ("LONG: %d" % i)
#        for j in range(0,len(ncdata.variables['lat'])): #LAT
        for j in range(0,2): #LAT
            print ("LAT: %d" % j)
            for M in range(0,11):   #MONTHS
            #for M in range(0,2):   #MONTHS
                print ("Month:: %d" % M)
                sumOfMonths=0
                #for Y in range(0,len(years)-1):  #YEARS
                for Y in range(0,2):  #YEARS
                    print ("Year: %d" % Y)
                    sumOfMonths = sumOfMonths + temp[M+11+12*Y][j][i]
                    print ("sumOfMonths: %d" %sumOfMonths ) 
                    print ("Temp: %d" % int( temp[M+11+12*Y][j][i]))
                    
                    
                AverageValuesDS[i][j][M] = sumOfMonths/(Y+1) 
                print("avergeForMonth %d" % int(AverageValuesDS[i][j][M]))
                print("\n")
    return AverageValuesDS
                 
    

if __name__ == "__main__":
    
    #Read in a data file
    datafile=sys.argv[1]
    DS = Dataset(datafile)
    
    #Preprocess file - average it
    AveragedTemps=AverageDataSet(DS)
    print (AveragedTemps)







