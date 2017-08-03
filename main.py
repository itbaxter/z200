im=240.0
jm=121.0
km=444.0
km1=12.0
km2=37.0
r=[im,jm,km1,km2]
s=[im,jm]
x=km2*3
y=km2*3
      
def AverageDataSet(ncdata):
    print (ncdata.file_format)    
    print (ncdata.dimensions.keys())

from netCDF4 import Dataset
dataset = Dataset('b.e11.B1850C5CN.f19_g16.0850cntl.001.cam.h0.T850.085001-184912.nc')

averaged_DS=AverageDataSet(dataset)


