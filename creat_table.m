function [table_binary]=creat_table(count,Acoustic_Loc, Node_Location,X_rank)
[list,row]=size(Node_Location); % Node_Number * Scan_Time
table_binary=zeros(list,1); %   
x0 = Acoustic_Loc(count ,1);
y0 = Acoustic_Loc(count ,2);

for k = 1:list
    
    x1 =  Node_Location(X_rank(k, count),1);
    y1 =  Node_Location(X_rank(k, count),2);
    x2 =  Node_Location(X_rank(k, count),3);
    y2 =  Node_Location(X_rank(k, count),4);
    X0 = [x0, y0];
    X1 = [x1 y1];
    X2 = [x2 y2];
    dis = norm(X1 -X0) - norm(X2 -X0);
    if dis >= 0
        table_binary(k) = 0;
    else
        table_binary(k) = 1;
    end
end
