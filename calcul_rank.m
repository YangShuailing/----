%��ȡ����ê�ڵ��Ŀ��ڵ������
function [Xrank] = calcul_rank(node_anchor,node_all)

[ Anchor_Number p]= size(node_anchor);  % ê�ڵ����
[Node_All_Num q] = size(node_all); % ��ͨ�ڵ� 

 temp_dis = zeros(Node_All_Num,Anchor_Number);
for  i=1:Anchor_Number
    X0=node_anchor(i,:);
    for  j=1:Node_All_Num
        X = node_all(j,:);
        dis_anchor(j) = norm(X0-X);
    end
    temp_dis(:,i) = dis_anchor';
end
[Xa,Xrank]=sort(temp_dis,1);
Xrank = Xrank';
end
% Xa %�����С
% Xrank ��ţ�Ŀ��ڵ������ǰ