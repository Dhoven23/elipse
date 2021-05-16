clear all,close all, clc
t = 0:0.00005:2*pi;

X = 2*sin(t);
Y = cos(t);

plot(X,Y,'c','Linewidth',1), hold on
xlim([-2.2,2.2])
ylim([-1.2,1.2])



posX = 1;
posY = 0;

velX = 1;
velY = -1.5;

speed = sqrt((velX*velX) + (velY*velY));

dt = 0.001;
iter = 0;

points = []
while(1)
    iter = iter + 1;
    posX_last = posX;
    posY_last = posY;
    
    posX = posX + velX*dt;
    posY = posY + velY*dt;
    
    dx = posX - posX_last;
    dy = posY - posY_last;
    len = sqrt((dx*dx) + (dy*dy));
    dx = dx/len;
    dy = dy/len;
    %figure(3)
    %plot(dx,dy,'ro')
    
    figure(1)
%     if (mod(iter,5))
%         points = [points; [posX,posY]];
%         plot(points(:,1),points(:,2),'r-'), hold on, axis equal
%         drawnow
%     end


    
    
    if ((.25*posX*posX)+(posY*posY) >= 1)
        points = [points; [posX,posY]];
        plot(points(:,1),points(:,2),'r-'), hold on, axis equal
        drawnow
        A = X - posX;
        C = diff(diff(abs(A)));
        [val1, ind1] = max(C);
        %         figure(2)
        %         subplot(3,1,1)
        %         plot(C)
        C(ind1) = 0;
        [val2, ind2] = max(C);
        %         subplot(3,1,2)
        %         plot(C)
        %         subplot(3,1,3)
        %         plot(abs(A))
        temp = ind1;
        if(ind1 > ind2)
            ind1 = ind2;
            ind2 = temp;
        end
        
        if (posX > 0)
            if(posY > 0)
                ind = ind1;
            end
            if(posY < 0)
                ind = ind2;
            end
        end
        if (posX < 0)
            if(posY > 0)
                ind = ind2;
            end
            if(posY < 0)
                ind = ind1;
            end
        end
        
        if(posX == 0)
            ind = ind1;
        end
        fprintf("Contact: (%.2f,%.2f)\n\n",X(ind),Y(ind))
        
        x1 = X(ind-1);
        x2 = X(ind+1);
        mX = x1 - x2;
        
        y1 = Y(ind-1);
        y2 = Y(ind+1);
        mY = y1 - y2;
        
        len = sqrt((mX*mX)+(mY*mY));
        mX = mX/len;
        mY = mY/len;
        ang = atan(mY/mX);
        angWall = ang-(pi/2);
        angBall = atan(dy/dx);
        angBtw = angWall - angBall;
        fprintf("Normal = %.2f\n",angWall*(180/pi))
        fprintf("Ball angle = %.2f\n",angBall*(180/pi))
        fprintf("Angle between = %.2f\n",angBtw*(180/pi))
        
        if(dy > 0)
            if(dx < 0)
                fprintf("\nNW\n")
                velY = -velY;
                velX = -velX;
                len = sqrt((velY*velY) + (velX*velX));
                velY = velY/len;
                velX = velX/len;
                ang = atan(velY/velX);
                fprintf("\nVector Angle = %f\n",ang*(180/pi));
                
                velY = len * sin(ang + 2*(angBtw));
                velX = len * cos(ang + 2*(angBtw));
                
                posX = posX + velX*.002;
                posY = posY + velY*.002;
            else
                if(dx > 0)
                    fprintf("\nNE\n")
                    velY = -velY;
                    velX = -velX;
                    len = sqrt((velY*velY) + (velX*velX));
                    velY = velY/len;
                    velX = velX/len;
                    ang = atan(velY/velX);
                    ang = ang - pi;
                    fprintf("\nVector Angle = %f\n",ang*(180/pi));
                
                    velY = len * sin(ang + 2*(angBtw));
                    velX = len * cos(ang + 2*(angBtw));
                
                    posX = posX + velX*.002;
                    posY = posY + velY*.002;
                end
            end    
        else
            if(dy < 0)
                if (dx < 0)
                     fprintf("\nSW\n")
                     velY = -velY;
                     velX = -velX;
                     len = sqrt((velY*velY) + (velX*velX));
                     velY = velY/len;
                     velX = velX/len;
                     ang = atan(velY/velX);
                     fprintf("\nVector Angle = %f\n",ang*(180/pi));
                
                     velY = len * sin(ang + 2*(angBtw));
                     velX = len * cos(ang + 2*(angBtw));
                
                     posX = posX + velX*.002;
                     posY = posY + velY*.002;
                else
                    if(dx > 0)
                        fprintf("\nSE\n")
                        velY = -velY;
                        velX = -velX;
                        len = sqrt((velY*velY) + (velX*velX));
                        velY = velY/len;
                        velX = velX/len;
                        ang = atan(velY/velX);
                        ang = ang + pi;
                        fprintf("\nVector Angle = %f\n",ang*(180/pi));
                        
                        velY = len * sin(ang + 2*(angBtw));
                        velX = len * cos(ang + 2*(angBtw));
                        
                        posX = posX + velX*.002;
                        posY = posY + velY*.002;
                    end
                end
                
            end
        end
       
        
        
    end
    
    if (iter > 120000)
        break
    end
end