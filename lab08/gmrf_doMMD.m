function mrf=gmrf_doMMD(mrf)

         cmap = load('MRF_colormap.mat'); % the colormap
            h = mrf.imagesize(1);         % height of the image
            w = mrf.imagesize(2);         % width of the image
         cnum = mrf.classnum;             % number of classes
         beta = mrf.Beta;                 % value of parameter beta
    DeltaUmin = mrf.DeltaUmin;            % value of minimal necessary energy change
            T = mrf.T0;                   % temperature at the begining
            c = mrf.c;                    % the c constant parameter
     

           cycle = 0;
    summa_deltaE = 2 * DeltaUmin; % the first iteration is guaranteed

    while summa_deltaE > DeltaUmin 
        
        % ====================================== %
        %                                        %
        %    Please, put your implementation     %
        %             BELOW THIS LINE            %
        %                                        %
        % ====================================== %
        
        summa_deltE = 0;
        cycle = cycle + 1;
        
        for y = 1:mrf.imagesize(1)
            for x = 1:mrf.imagesize(2)
                currLabel = mrf.classmask(y,x);
                
                
                
                neighbourLabels = zeros(3,3);
                x1 = 1;
                x2 = 3;
                y1 = 1;
                y2 = 3;
                if y-1 < 1
                    y1 = 2;
                end
                if mrf.imagesize(1) < y+1
                    y2 = 2;
                end
                if x-1 < 1
                    x1 = 2;
                end
                if mrf.imagesize(2) < x+1
                    x2 = 2;
                end
                neighbourLabels(y1:y2, x1:x2) = mrf.classmask(max([y-1 1]) : min(y+1,mrf.imagesize(1)),   max([x-1 1]) : min(x+1, mrf.imagesize(2)));
                
                
                
                curr_posterior = mrf.logProbs{currLabel}(y, x);
                curr_prior = beta +   sum(sum(beta .* (neighbourLabels == currLabel) + -beta .* (neighbourLabels ~= currLabel & neighbourLabels ~= 0)));
                
                while true
                    changeY = ceil(3*rand);
                    changeX = ceil(3*rand);
                    if (~(changeX == 1 & changeY == 1) & neighbourLabels(changeY, changeX)~=0)
                        break;
                    end
                end
                
                
                tryal_neighbourLabels = neighbourLabels;
                while isequal(tryal_neighbourLabels, neighbourLabels)
                    tryal_neighbourLabels(changeY, changeX) = ceil(mrf.classnum*rand);
                end
                
                
                tryal_posterior = curr_posterior;
                tryal_prior = beta +   sum(sum(-beta .* (tryal_neighbourLabels == currLabel) + beta .* (tryal_neighbourLabels ~= currLabel & tryal_neighbourLabels ~= 0)));
               
                curr_U = curr_posterior + curr_prior;
                tryal_U = tryal_posterior + tryal_prior;
                
                dU = tryal_U - curr_U;
                
                
                if (dU <= 0 | rand < exp(-dU/T))
                    mrf.classmask(y+changeY-2, x+changeX-2) = tryal_neighbourLabels(changeY, changeX);
                    summa_deltaE = summa_deltaE + abs(dU);
                end
                
            end
        end
        
        
        
        
        
        %n = (min(y+1,size(mrf.classmask,1)) - max([y-1 1]) +1) * (min(x+1,size(mrf.classmask,2)) -max([x-1 1]) +1);
%         neighbourLabels = zeros(10);
%         k = 1;
%         for yi = max([y-1 1]) : min(y+1,size(mrf.classmask,1))
%             for xi = max([x-1 1]) : min(x+1,size(mrf.classmask,2))
%                 neighbourLabels(k) = mrf.calssmask(yi,xi);
%                 k= k+1;
%             end
%         end
        
        
        
        
        
        
        
        
        % ====================================== %
        %                                        %
        %    Please, put your implementation     %
        %             ABOVE THIS LINE            %
        %                                        %
        % ====================================== %    
        
        imshow(uint8(255*reshape(cmap.color(mrf.classmask,:), h, w, 3)));
        %fprintf('Iteration #%i\n', cycle);
        title(['Class map in cycle ', num2str(cycle)]);
        drawnow;
    end
end
