import sys, numpy, time
import netcdf4
    
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

    AverageValuesDS= numpy.zeros(( len(ncdata.variables['lon']),len(ncdata.variables['lat']),12),float)
    for i in range(0,len(ncdata.variables['lon'])): #LON
        for j in range(0,len(ncdata.variables['lat'])): #LAT
            for M in range(0,12):   #MONTHS
                sumOfMonths=0
                for Y in range(0,len(years)-1):  #YEARS
                    sumOfMonths = sumOfMonths + temp[M+11+12*Y][j][i]

                AverageValuesDS[i][j][M] = sumOfMonths/(Y+1)

    return AverageValuesDS

    AnomaliesDS = numpy.zeros(( len(ncdata.variables['lon']),len(ncdata.variables['lat']),12),float)
    for Y in range(0, len(years)):
        for M in range(0,11):
            for i in range(0,len[ncdata.variables("lon")]):
                for j in range(0,len[ncdata.variables("lat")]):
                    if temp[M] != -9.99 ** 8:
                        AnomaliesDS = temp[M][Y][j][i] - AverageValuesDS[M][i][j]
    return AnomaliesDS

if __name__ == "__main__":

    #Read in a data file
    datafile=sys.argv[0]
    DS = Dataset(datafile)

    #Preprocess file - average it
    st=time.time()
    AnomaliesDS=AverageDataSet(DS)
    et=time.time()

    print (len(AnomaliesDS))
    print("time taken: %d" %(et-st))
