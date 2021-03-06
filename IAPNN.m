%   B. Chandra and K. V. N. Babu, "An improved architecture for Probabilistic Neural Networks,"
%   The 2011 International Joint Conference on Neural Networks, San Jose, CA, 2011, pp. 919-924.
%   http://ieeexplore.ieee.org/document/6033320/

classdef IAPNN
    properties
        Size
        Classes
        Train
        lambda
        x_Train
        y_Train
        Theta
    end
    methods
        function clf = IAPNN(x_train,y_train,lambda)
            %Mean center and normalize the data
            x_train = x_train - repmat(mean(x_train),size(x_train,1),1);
            for i = 1:size(x_train,1)
                x_train(i,:) = x_train(i,:)/norm(x_train(i,:));
            end
            
            clf.Size = size(x_train,1);
            clf.Classes = unique(y_train);
            clf.x_Train = x_train;
            clf.y_Train = y_train;
            clf.lambda = lambda;
            
            %Create the theta matrix
            clf.Theta = zeros(size(clf.Classes,1),size(clf.x_Train,2));
            for i = 1:numel(clf.Classes)
                classSet = clf.x_Train(clf.y_Train == clf.Classes(i),:);
                for j = 1:size(clf.x_Train,2)
                    clf.Theta(i,j) = (sum(exp(classSet(:,j)-1))^(clf.lambda^-2))/size(classSet,1);
                end
            end
        end
        function y_pred = Predict(clf, x_test)
            %Normalize the data
            for i = 1:size(x_test,1)
                x_test(i,:) = x_test(i,:)/norm(x_test(i,:));
            end
            
            y_pred = zeros(size(x_test,1),1);
            for i = 1:size(x_test,1)
                Class_Layer = zeros(size(clf.Classes,1),1);
                for j = 1:numel(clf.Classes)
                    Class_Layer(j) = x_test(i,:)*clf.Theta(j,:)';
                end
                [~,id] = max(Class_Layer);
                y_pred(i) = clf.Classes(id);
            end
        end
    end
end
