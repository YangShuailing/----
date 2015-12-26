function [table_binary]=creat_table(dual_node_all,X_rank)
[list,row]=size(dual_node_all); % Node_Number_all * 4
table_binary=zeros(list,list); %   

for k = 1:list
    x0 = dual_node_all(k,1);
    y0 = dual_node_all(k,2);
    X0 = [x0, y0];
    for count = 1:list
        x1 =  dual_node_all(X_rank(k, count),1);
        y1 =  dual_node_all(X_rank(k, count),2);
        x2 =  dual_node_all(X_rank(k, count),3);
        y2 =  dual_node_all(X_rank(k, count),4);
        X1 = [x1 y1];
        X2 = [x2 y2];
        dis = norm(X1 -X0) - norm(X2 -X0);
        if dis >= 0
            table_binary(k, count) = 0;
        else
            table_binary(k, count) = 1;
        end
    end
end
