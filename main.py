import numpy as np
import math
import SPHacceleration
import SPHdensity
import SPHboundaries
from animatedscatter import AnimatedScatter
import matplotlib.animation as animation
from mayavi import mlab

#print 'hello world'
timesteps=50
gamma=7.
c=10.
rho0=1
deltat=0.005
n=500
V=1.
boundaries=np.array([5,5,20]) #Boundaries of box first two numbers are distance from 0 on both sides for X and Y, last number is floor.
density=np.ones((n),dtype=float)
velocity=np.random.random((n,3))*1000-500
position=np.random.random((n,3))*boundaries[0]*2-boundaries[0]
#print position
ac=np.zeros((n,3),dtype=float)
h=10.
Mass=np.ones((n),dtype=float)
Ch=1./(4*math.pi*h**3)


def calc_velo_pos(density,ac, velocity, position, h, Mass, Ch, n, gamma, c, boundaries,deltat):
    velocity = velocity*0.9 + .5*(deltat)*ac
    position += .5*(deltat)*velocity
    position,velocity=SPHboundaries.calcboundaries(position,velocity,boundaries,n)
#    print velocity, position
    density = calc_density(position,h,n,Mass,Ch,density)
    #print density
    pressure = calc_pressure(density, rho0, gamma, c)
    ac = calc_acceleration(pressure, velocity, density, position, h, n, Ch,ac,c)
#    print velocity, position, density, ac
    return velocity, position, ac,density
    
def update_func(position,velocity,ac,density, h, Mass, Ch, n, gamma, c, boundaries,deltat):
    velocity,position,ac,density=calc_velo_pos(density,ac, velocity, position, h, Mass, Ch, n, gamma, c, boundaries,deltat)      
    return position, velocity,ac,density
  

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
  density=np.zeros((n),dtype=float)
  density=SPHdensity.calcdensity(position,density,Mass,Ch,h,n)
  return density
#  for i in len(position):
#    for j in len(position):
#      density[i]+=calc_Kerns(position[i,:]-position[j,:],h)[0]*Dens[j]*V[j]
      
def calc_pressure(density,rho0,gamma,c):
  Pressure=((rho0*c**2)/gamma)*(((density/rho0)**gamma)-1)
  return Pressure

def calc_acceleration(Pressure,velocity, density,position,h,n,Ch,ac,c):
  ac=np.zeros((n,3),dtype=float)
  ac=SPHacceleration.calcacceleration(position, velocity, ac,Pressure,density,Ch,h,c, n)
  #ac[:,2]-=9.8
  return ac
  
#  for i in len(position):
#    for j in len(position):
#      ac[i]+=(Pressure[i]/density[i]**2+Pressure[j]/density[j]**2)*calc_Kerns(position[j,:],h)[1]+[gravitionalterm]
#Writer = animation.writers['ffmpeg']
#writer = Writer(fps=15, metadata=dict(artist='Me'), bitrate=1800)      
#ims=[]
#a = AnimatedScatter(density,ac, velocity, position, h, Mass, Ch, n, gamma, c, boundaries,deltat,update_func)
#a.show()
#im_ani = animation.ArtistAnimation(a, ims, interval=50, repeat_delay=3000,blit=True)
#im_ani.save('im.mp4', writer=writer)
#a.save('the_movie.mp4', writer = 'mencoder', fps=15)

## plotting attempt
#import matplotlib.pyplot as plt
#from mpl_toolkits.mplot3d import Axes3D
##fig = plt.figure()
##ax = fig.add_subplot(111, projection='3d')
#f = open('myfile','w')
#
for i in xrange(0,timesteps):
  velocity,position,ac,density=calc_velo_pos(density,ac, velocity, position, h, Mass, Ch, n, gamma, c, boundaries,deltat)
  mlab.points3d(position[:,0],position[:,1],position[:,2])
  mlab.savefig('figs/(%d).jpg' %i, size=None, figure=None, magnification='auto')
  mlab.clf()      
  #color=['b','g','r','c','m','y','k','w']
  #ax.scatter(position[:,0],position[:,1],position[:,2],c=color, marker='o')
  #plt.show()
#  f.write('#comment \n')
#  f.write(str(i))
#  f.write('\n ')
#  f.write(str(position[:,:]))
#  f.write('\n') 
#f.close() 


#mlab.show()
