import numpy as np
import math
import matplotlib.pyplot as plt 
import SPHacceleration
import SPHdensity
#print 'hello world'
timesteps=2
gamma=7.
c=1.
rho0=1.
deltat=0.02
n=2
V=1.
density=np.ones((n),dtype=float)
velocity=np.zeros((n,3),dtype=float)
position=np.random.random((n,3))
#print position
ac=np.zeros((n,3),dtype=float)
h=1.
Mass=np.ones((n),dtype=float)
Ch=1./(4*math.pi*h**3)


def calc_velo_pos(density,ac, velocity, position, h, Mass, Ch, n, gamma, c):
    velocity += .5*(deltat)*ac
    position += .5*(deltat)*velocity
#    print velocity, position
    density = calc_density(position,h,n,Mass,Ch,density)
    pressure = calc_pressure(density, rho0, gamma, c)
    ac = calc_acceleration(pressure, density, position, h, n, Ch,ac)
#    print velocity, position, density, ac
    return velocity, position, ac

#def calc_Kerns(position,h):
#  r=(position[0]**2+position[1]**2+position[2]**2)**0.5
#  x=r/h
#  Ch=1./(4*math.pi*h**3)
#  if 0<abs(x)<1:
#    W=Ch*((2.-x)**3-4*(1.-x)**3)
#    dW=Ch*(12*(1-x)**2-3*(2.-x)**2)
#  elif 1<abs(x)<2:
#    W=Ch*((2.-x)**3)
#    dW=Ch*(-3*(2.-x)**2)
#  else:
#    W=0.
#    dW=0.
#  return [W,dW]
  

def calc_density(position,h,n,Mass,Ch,density):  
  density=SPHdensity.calcdensity(position,density,Mass,Ch,h,n)
  return density
#  for i in len(position):
#    for j in len(position):
#      density[i]+=calc_Kerns(position[i,:]-position[j,:],h)[0]*Dens[j]*V[j]
      
def calc_pressure(density,rho0,gamma,c):
  Pressure=((rho0*c**2)/gamma)*(((density/rho0)**gamma)-1)
  return Pressure

def calc_acceleration(Pressure,density,position,h,n,Ch,ac):
  ac=SPHacceleration.calcacceleration(position,ac,Pressure,density,Ch,h,n)
  ac[:,2]-=1
  return ac
  
#  for i in len(position):
#    for j in len(position):
#      ac[i]+=(Pressure[i]/density[i]**2+Pressure[j]/density[j]**2)*calc_Kerns(position[j,:],h)[1]+[gravitionalterm]
#      
#  


for i in xrange(0,timesteps):
  velocity,position,ac=calc_velo_pos(density,ac, velocity, position, h, Mass, Ch, n, gamma, c)      
    