
function drop_1 = p(q,t)
% initialise control points
global count C drop_next drop lastcount delta dropping i1 j i
tar_del = 0.02;
interval = 0.03;
time = 0;

if t >= drop_next
    del = q / C; 
    if dropping == 1  
        if del > tar_del
        drop = 1;
        i1 = i1 + 1;
        count = count + 1;
        i = interval + interval *(log(count) + 0.5772 + (1/(2*count)));
        drop_next = time + i; 
        else 
            dropping = 0;
            drop = 0;
        end
    elseif del > tar_del
            drop = 1;
            i1 = i1 + 1;
            dropping = 1;
            delta = count - lastcount;
            
            %if  delta > 1 && (t - drop_next) < 16 * interval 
            if (t - drop_next) < 16 * interval 
                if delta < 2
                    count = 1;
                    time = t;
                else
                    count = delta;
                end
            else
                count = 1;
                j = j+ 1;
                time = t;
            end
            i = interval + interval *(log(count) + 0.5772 + (1/(2*count)));
            drop_next = time + i;
            lastcount = count;
     else 
        drop = 0;
    end
end
drop_1 = drop;

end