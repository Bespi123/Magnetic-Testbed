function h1 = plotHeltholtsCoils(spire1,spire2,L)
    %%% Get fields
    fieldsName = fields(spire1);
    %%% Plot spire 1
    for i = 1:numel(fieldsName)
         scale = (L/4)/norm((spire1.([fieldsName{i,1}])(:,2)-spire1.([fieldsName{i,1}])(:,1)));
         plot3(spire1.([fieldsName{i,1}])(1,:),spire1.([fieldsName{i,1}])(2,:),spire1.([fieldsName{i,1}])(3,:),'LineWidth',2,'Color','k');hold on;
         [h1,~] = plotVector(spire1.([fieldsName{i,1}])(:,1),(spire1.([fieldsName{i,1}])(:,2)-spire1.([fieldsName{i,1}])(:,1))*scale,1,'r--',' ','e');
         set(h1,'LineWidth',2,'MaxHeadSize',1);    
    end
    
    fieldsName = fields(spire2);
    %%% Plot spire 2
    for i = 1:numel(fieldsName)
         plot3(spire2.([fieldsName{i,1}])(1,:),spire2.([fieldsName{i,1}])(2,:),spire2.([fieldsName{i,1}])(3,:),'LineWidth',2,'Color','k');hold on;
         [h1,~] = plotVector(spire2.([fieldsName{i,1}])(:,1),(spire2.([fieldsName{i,1}])(:,2)-spire2.([fieldsName{i,1}])(:,1))*scale,1,'r--',' ','e');
         set(h1,'LineWidth',2,'MaxHeadSize',1);  
    end
    %scale=(L/4)/norm(B);
    %[h1,~] = plotVector(P,(B)*scale,1,'g--','B ','e');
    set(h1,'LineWidth',2,'MaxHeadSize',1); 
    axis equal; xlabel('x(m)'); ylabel('y(m)'); zlabel('z(m)');
end