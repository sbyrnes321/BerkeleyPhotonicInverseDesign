function[phi]=messySD(phi,dx)

    [Ny,Nx] = size(phi);
    newphi=ones(Ny+2,Nx+2)*(Nx+Ny);
    
    origins=ones(Ny+2,Nx+2);
    %% Construct initial data points from phi
    
   %%extphi=an extruded phi with side cells
    
   extphi=zeros(Ny+2,Nx+2);  %% we need space on the sides
   extphi(2:(Ny+1),2:(Nx+1))=phi;
   extphi(2:(Ny+1),1)=phi(:,1);
   extphi(1,2:(Nx+1))=phi(1,:);
   extphi(2:(Ny+1),Nx+2)=phi(:,Nx);
   extphi(Ny+2,2:(Nx+1))=phi(Ny,:);
   
  % figure(1);imagesc(extphi);
  
   
   extphibin=sign(extphi);
   
    % figure(2);imagesc(extphi);
   
   %% find border points
   origins2=origins;
   origins3=origins;
   for i=2:Ny+1
       for j=2:Nx+1
           if (extphibin(i+1,j)+extphibin(i-1,j)+extphibin(i,j-1)+extphibin(i,j+1))~=4*extphibin(i,j);
              origins(i,j)=0;
           end
       end
   end
  


   
   newphi=newphi.*origins+(1-origins)*dx/2;%;5/max(max(abs(extphi)))*dx/2;
   
   %newphi is huge everywhere except at boarder points.
   
    %%teporarily
%     newphi(floor(Ny/2)+1,floor(Nx/2)+1)=0.5;
%     newphi(floor(Ny/2),floor(Nx/2))=0.5;
%     newphi(floor(Ny/2),floor(Nx/2)+1)=0.5;
%     newphi(floor(Ny/2)+1,floor(Nx/2))=0.5;
%     
%     origins(floor(Ny/2)+1,floor(Nx/2)+1)=0;
%     origins(floor(Ny/2),floor(Nx/2))=0;
%     origins(floor(Ny/2),floor(Nx/2)+1)=0;
%     origins(floor(Ny/2)+1,floor(Nx/2))=0;
%     
    
    
   % figure(6);imagesc(newphi);
    
    %% Do the five iterations of the algorythm
    
     for iter=1:5
         if (iter==1 || iter==5)
             bi=2;ei=Ny+1;si=1;
             bj=2;ej=Nx+1;sj=1;
         end
         if iter==2
             bi=2;ei=Ny+1;si=1;
             bj=Nx+1;ej=2;sj=-1;
         end
         if iter==3
             bi=Ny+1;ei=2;si=-1;
             bj=2;ej=Nx+1;sj=1;
         end
         if iter==4
             bi=Ny+1;ei=2;si=-1;
             bj=Nx+1;ej=2;sj=-1;
         end
         
         for i=bi:si:ei
             for j=bj:sj:ej
                 xmin=min(newphi(i-1,j),newphi(i+1,j));
                 ymin=min(newphi(i,j-1),newphi(i,j+1));
                 if origins(i,j)
                    if abs(xmin-ymin)>=dx
                         newphi(i,j)=min(xmin,ymin)+dx;
                    else
                         newphi(i,j)=(xmin+ymin+sqrt(2*dx^2-(xmin-ymin)^2))/2;
                    end
                 
                 end
             end
          end
         
          %figure(iter); imagesc(newphi);
         
     end
     newphi=newphi.*extphibin;
     phi=newphi(2:(Ny+1),2:(Nx+1));
                  
              
            
    