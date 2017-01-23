function drop = p(q,t)
% initialise control points
global count C drop_next lastcount delta dropping i1 j
tar_del = 0.005; % target in seconds
interval = 0.1;  % interval in seconds
time = 0;

if t >= drop_next
    del = q / C; 
    if dropping == 1  
        if del > tar_del
        drop = 1;
        i1 = i1 + 1;
        count = count + 1;
        i = 2 * interval * sqrt(count);
        drop_next = time + i; 
        else 
            dropping = 0;
            drop = 0;
        end
    elseif del > tar_del
            drop = 1;
            dropping = 1;
            delta = count - lastcount;
            if (t - drop_next) < 16 * interval 
                if delta < 2
                    count = 1;
                    time = t;
                else
                    count = delta;
                end
            else
                count = 1;
                time = t;
            end
            i = 2 * interval * sqrt(count);
            drop_next = time + i;
            lastcount = count;
     else 
        drop = 0;
    end
end
end