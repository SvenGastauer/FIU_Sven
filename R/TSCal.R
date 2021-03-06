###################################################################
#Theoretical TS of calibration sphere
#   R script of function for band averaged TS of tungsten
#     carbide spheres
#   translated from Matlab code (Version date 31/5/05)
#   written by D. MacLennan (Marine Lab, Aberdeen)
#   updated from R version written by Sascha F?ssler 03/2010
#
#   Sven Gastauer 04/01/2017
###################################################################
# Input:
# freq  : frequencies [kHz]
# c     : soundspeeds [m/s]
# d     : sphere diameter [cm]
# mat   : material Cu = Copper, TC = Tungsten-Carbide
# water : sw= seawater; fw = fresh water
# plot  : yes no
###################################################################
# Output:
# dataframe: "F","TS","ModF2","c"
# F = Frequency [kHz]; TS = TS [dB]; ModF2 = ModF^2;
# c = soundspeed [m/s]
# optional plot
###################################################################
library(ggplot2)
library(reshape2)
ts.cal <- function(freq=seq(38,200),c=seq(1450,1500,by=0.1),d=38.1,mat="TC",water="sw",plot="yes"){
  require(ggplot2)
  a <- d/2
  results <-NA
  #select materia l
  cc <- switch(mat,
       TC = c(6853,4171),
       Cu = c(4760,2288))
  ww <- switch(water,
               sw = 1.027,
               fw = 1)
  rho <- switch(mat,
               TC = c(14.9/ww),
               Cu = c(8.945/ww))

  for(i in 1:length(c)){
      q<- 2*pi*freq*a/c[i] # ka range
      ka=q

      nr    <- length(ka)
      F     <- matrix(0,nr,4)
      Lmax  <- floor(max(ka))+20
      alpha <- 2*rho*(cc[2]/c[i])^2
      beta  <- rho*(cc[1]/c[i])^2-alpha
      nn    <- 1:(Lmax+1)
      n0    <- 2:(Lmax+1)
      lh    <- nn-0.5
      LL    <- 0:Lmax
      S     <- (floor(LL/2)==LL/2)*1-(floor((LL+1)/2)==(LL+1)/2)*1
      L     <- 1:Lmax
      L     <- matrix(c(L,L,L),length(L),3)
      jh    <- matrix(0,Lmax+1,3)
      djh   <- jh
      ddjh  <- jh
      yh    <- matrix(0,Lmax+1,1)

      for (jj in 1:nr){
        q     <- ka[jj]
        q1    <- q*c[i]/cc[1]
        q2    <- q*c[i]/cc[2]
        qq    <- matrix(c(q1,q2,q),length(q),3)
        bfac  <- sqrt((qq*2/pi));
        Qm    <- t(matrix(qq,length(qq),Lmax))
        Bf    <- t(matrix(bfac,length(bfac),Lmax+1))

        # jh/yh are spherical Bessel functions of the first/second kinds
        # starting at order L=0 (i.e. order is row number - 1).
        jh  <- (matrix(c(besselJ(q1,lh),besselJ(q2,lh),besselJ(q,lh)),length(nn),3))/Bf
        yh  <- besselY(q,lh)/Bf[,3]
        djh[1,]   <- -jh[1,]+cos(qq)	 		         # Zero order derivatives
        dyh    <- -yh[1]+sin(q)				         # djh= x*jL'(x); dyh= x*yL'(x)
        ddjh[1,]  <- -2*djh[1,]-qq*sin(qq)		     # ddjh = x^2*jL''(x)
        djh[n0,]  <- -(L+1)*jh[n0,]+Qm*jh[n0-1,]   # Derivatives for orders 2 upwards
        dyh[n0]   <- -(L[,1]+1)*yh[n0]+Qm[,3]*yh[n0-1]
        ddjh[n0,] <- ((L+1)*(L+2)-Qm*Qm)*jh[n0,]-2*Qm*jh[n0-1,]

        a2 <- (LL*LL+LL-2)*jh[,2]+ddjh[,2]
        a1 <- 2*LL*(LL+1)*(djh[,1]-jh[,1])
        b2 <- a2*(beta*q1^2*jh[,1]-alpha*ddjh[,1])-alpha*a1*(jh[,2]-djh[,2])
        b1 <- q*(a2*djh[,1]-a1*jh[,2])
        x  <- -b2*djh[,3]/q + b1*jh[,3]
        y  <- b2*dyh/q - b1*yh
        z  <- S*(2*LL+1)*x/(x*x+y*y)
        y  <- z*y
        x  <- z*x

        F[jj,3:4] <- -(2/q)*c(sum(y),sum(x))			# The form function
        F[jj,1]   <- F[jj,3]^2+F[jj,4]^2		      # and its modulus squared
        F[jj,2]<-10*log10((a/2000)^2*F[jj,1])
        }
      tmp <- as.data.frame(cbind(freq, F[,2], F[,1]))
      tmp$c = c[i]
      names(tmp)<-c("F","TS","ModF2","c")
      if(i>1 | jj>1){
        results <- rbind(results,tmp)
        }else{
          results<-tmp
        }
  }
 if(plot=="yes"){
   pp<-ggplot(data=results, aes(x=F,y=TS,group=c))+
     geom_line(aes(lty=as.factor(c)))+
     labs(lty = "c [m/s]")+
     theme_classic()+
     theme(legend.position = "top",
           text=element_text(size=16))+
     xlab("Frequency [kHz]")+ylab("TS [dB]")
   print(pp)
 }
  results <- na.omit(results)
  return(results)
}
