function [orginal,after_fs]=classifier_main(ds,Targets,opt_answer)


for j=1:5
    p_obj=cvpartition(Targets,'k',2);
    for i=1:2
        %% Partitioning Dataset
        tr=p_obj.training(i);
        tr_ind=find(tr==1);
        te=p_obj.test(i);
        tes_ind=find(te==1);
        Data=ds;
        Train=Data(tr_ind,:);
        Tr_Tar=Targets(tr_ind,:);
        Test=Data(tes_ind,:);
        Te_Tar=Targets(tes_ind,:);
        
        %% bayes Classifier
        a=Bayes_CV_estimate(Train,Tr_Tar,Test,Te_Tar);
        orginal_bayes(i)=1-a;
        %%
        %         o1=ClassificationTree.fit(Train,Tr_Tar);
        %         c2=o1.predict(Test);
        %         obj=classperf(Te_Tar,c2);
        %         orginal_bayes(i)=obj.CorrectRate;
        %         o1=NaiveBayes.fit(Train,Tr_Tar);
        %         c2=o1.predict(Test);
        %         obj=classperf(Te_Tar,c2);
        %         orginal_bayes(i)=obj.CorrectRate;
        
        %% Adaboost Classifier
        if length(unique(Targets))<=2
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassAdaBoost;
            classifier = classifier.train(TrainingDataSet);
            classified = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classified.targets);
            orginal_boosting(i)=perf.correctRate;
            
        else
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassAdaBoost;
            classifier = prtClassBinaryToMaryOneVsAll;
            classifier.baseClassifier = prtClassLibSvm;
            classifier.internalDecider = prtDecisionMap;
            classifier = classifier.train(TrainingDataSet);
            classes    = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classes.targets);
            orginal_boosting(i)=perf.correctRate;
        end
        %% fld Classifier
        if length(unique(Targets))<=2
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassFld;
            classifier = classifier.train(TrainingDataSet);
            classified = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classified.targets);
            orginal_fld(i)=perf.correctRate;
            
        else
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassFld;
            classifier = prtClassBinaryToMaryOneVsAll;
            classifier.baseClassifier = prtClassFld;
            classifier.internalDecider = prtDecisionMap;
            classifier = classifier.train(TrainingDataSet);
            classes    = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classes.targets);
            orginal_fld(i)=perf.correctRate;
        end
        
        %% SVM
        if length(unique(Targets))<=2
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassLibSvm;
            classifier = classifier.train(TrainingDataSet);
            classified = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classified.targets);
            orginal_svm(i)=perf.correctRate;
            
        else
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassLibSvm ;
            classifier = prtClassBinaryToMaryOneVsAll;
            classifier.baseClassifier = prtClassLibSvm;
            classifier.internalDecider = prtDecisionMap;
            classifier = classifier.train(TrainingDataSet);
            classes    = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classes.targets);
            orginal_svm(i)=perf.correctRate;
        end
        %% KNN
        cl=knnclassify(Test,Train,Tr_Tar,1);
        knnobj=classperf(Te_Tar,cl);
        orginal_knn(i)=knnobj.correctRate;
        
        %% Linear Discriminant Analysis
        dic_obj=ClassificationDiscriminant.fit(Train,Tr_Tar);
        dic_y=predict(dic_obj,Test);
        perf=classperf(Te_Tar,dic_y);
        orginal_linear(i)=perf.correctRate;
        
        
        
        %% Fisher Classifier
        Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
        Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
        if length(unique(Targets))<=2
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassFld;
            classifier = classifier.train(TrainingDataSet);
            classified = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classified.targets);
            orginal_fisher(i)=perf.correctRate;
            
        else
            
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassFld ;
            classifier = prtClassBinaryToMaryOneVsAll;
            classifier.baseClassifier = prtClassFld;
            classifier.internalDecider = prtDecisionMap;
            classifier = classifier.train(TrainingDataSet);
            classes    = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classes.targets);
            orginal_fisher(i)=perf.correctRate;
        end
        
        
        
        
        
        %*************************************************************************
        %*************************************************************************
        %*************************************************************************
        
        
        
        
        %% After Feature Selection
        Feachers=opt_answer;
        Train_FS=Data(tr_ind,Feachers);
        Test_FS=Data(tes_ind,Feachers);
        %% Bayes
        a=Bayes_CV_estimate(Train_FS,Tr_Tar,Test_FS,Te_Tar);
        fs_bayes(i)=1-a;
        %         o1=ClassificationTree.fit(Train,Tr_Tar);
        %         c2=o1.predict(Test);
        %         obj=classperf(Te_Tar,c2);
        %         fs_bayes(i)=obj.CorrectRate;
        %         o1=NaiveBayes.fit(Train_FS,Tr_Tar);
        %         c2=o1.predict(Test_FS);
        %         obj=classperf(Te_Tar,c2);
        %         fs_bayes(i)=obj.CorrectRate;
        
        
        %% SVM
        Train_ds=prtDataSetClass(Train_FS,Tr_Tar);
        Test_ds=prtDataSetClass(Test_FS,Te_Tar);
        if length(unique(Targets))<=2
            TrainingDataSet= Train_ds;
            classifier = prtClassLibSvm;
            classifier = classifier.train(TrainingDataSet);
            classified = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classified.targets);
            fs_svm(i)=perf.correctRate;
            
        else
            
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassLibSvm ;
            classifier = prtClassBinaryToMaryOneVsAll;
            classifier.baseClassifier = prtClassLibSvm;
            classifier.internalDecider = prtDecisionMap;
            classifier = classifier.train(TrainingDataSet);
            classes    = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classes.targets);
            fs_svm(i)=perf.correctRate;
        end
        
        %% KNN
        
        cll=knnclassify(Test_FS,Train_FS,Tr_Tar,1);
        knnobj1=classperf(Te_Tar,cll);
        fs_knn(i)=knnobj1.correctRate;
        
        %% Linear Discriminant Analysis
        dic_obj=ClassificationDiscriminant.fit(Train_FS,Tr_Tar);
        dic_y=predict(dic_obj,Test_FS);
        perf=classperf(Te_Tar,dic_y);
        fs_linear(i)=perf.correctRate;
        
        
        %% Fisher Classifier
        Train_ds=prtDataSetClass(Train_FS,Tr_Tar);
        Test_ds=prtDataSetClass(Test_FS,Te_Tar);
        if length(unique(Targets))<=2
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            % training data
            classifier = prtClassFld;           % Create a classifier
            classifier = classifier.train(TrainingDataSet);    % Train
            classified = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classified.targets);
            fs_fisher(i)=perf.correctRate;
            
        else
            
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassFld ;
            classifier = prtClassBinaryToMaryOneVsAll;
            classifier.baseClassifier = prtClassFld;
            classifier.internalDecider = prtDecisionMap;
            classifier = classifier.train(TrainingDataSet);
            classes    = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classes.targets);
            fs_fisher(i)=perf.correctRate;
        end
        %% fld
        if length(unique(Targets))<=2
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassFld;
            classifier = classifier.train(TrainingDataSet);
            classified = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classified.targets);
            fs_fld(i)=perf.correctRate;
            
        else
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassFld;
            classifier = prtClassBinaryToMaryOneVsAll;
            classifier.baseClassifier = prtClassFld;
            classifier.internalDecider = prtDecisionMap;
            classifier = classifier.train(TrainingDataSet);
            classes    = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classes.targets);
            fs_fld(i)=perf.correctRate;
        end
        
        
        %% Adaboost Classifier
        if length(unique(Targets))<=2
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassAdaBoost;
            classifier = classifier.train(TrainingDataSet);
            classified = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classified.targets);
            fs_boosting(i)=perf.correctRate;
            
        else
            Train_ds=prtDataSetClass(Data(tr_ind,:),Targets(tr_ind));
            Test_ds=prtDataSetClass(Data(tes_ind,:),Targets(tes_ind));
            TestDataSet = Test_ds;
            TrainingDataSet= Train_ds;
            classifier = prtClassAdaBoost;
            classifier = prtClassBinaryToMaryOneVsAll;
            classifier.baseClassifier = prtClassLibSvm;
            classifier.internalDecider = prtDecisionMap;
            classifier = classifier.train(TrainingDataSet);
            classes    = run(classifier, TestDataSet);
            perf=classperf(TestDataSet.targets,classes.targets);
            fs_boosting(i)=perf.correctRate;
        end
    end
    orginal_fld(j)=mean(orginal_fld);
    orginal_svm(j)=mean(orginal_svm);
    orginal_knn(j)=mean(orginal_knn);
    orginal_linear(j)=mean(orginal_knn);
    orginal_fisher(j)=mean(orginal_fisher);
    orginal_bayes(j)=mean(orginal_bayes);
    orginal_boosting(j)=mean(orginal_boosting);
    
    fs_fld(j)=mean(fs_fld);
    fs_fisher(j)=mean(fs_fisher);
    fs_linear(j)=mean(fs_linear);
    fs_knn(j)=mean(fs_knn);
    fs_svm(j)=mean(fs_svm);
    fs_bayes(j)=mean(fs_bayes);
    fs_boosting(j)=mean(fs_boosting);
end
%%
%**************************************************************************
%**************************************************************************
%**************************************************************************
orginal_fld=mean(orginal_fld);
orginal_svm=mean(orginal_svm);
orginal_knn=mean(orginal_knn);
orginal_linear=mean(orginal_knn);
orginal_fisher=mean(orginal_fisher);
orginal_bayes=mean(orginal_bayes);
orginal_boosting=mean(orginal_boosting);

orginal=(orginal_fld+orginal_fisher+orginal_knn+orginal_linear+orginal_svm+orginal_bayes+orginal_boosting)/7;


fs_fld=mean(fs_fld);
fs_fisher=mean(fs_fisher);
fs_linear=mean(fs_linear);
fs_knn=mean(fs_knn);
fs_svm=mean(fs_svm);
fs_bayes=mean(fs_bayes);
fs_boosting=mean(fs_boosting);

after_fs=(fs_fld+fs_fisher+fs_knn+fs_linear+fs_svm+fs_bayes+fs_boosting)/7;
result={'fld Classifier','KNN Classifier','Fisher Classifier','SVM Classifier','LDA Classifier','Bayes Classifier','Boosting Classifier';...
    orginal_fld,orginal_knn,orginal_fisher,orginal_svm,orginal_linear,orginal_bayes,orginal_boosting;...
    'After FS-FLD Classifier','After FS-KNN Classifier','After FS-Fisher Classifier','After FS-SVM Classifier','After FS-LDA Classifier','After FS-Bayes Classifier','After FS-Boosting Classifier';...
    fs_fld,fs_knn,fs_fisher,fs_svm,fs_linear,fs_bayes,fs_boosting;...
    'Total result before FS','Total result after FS ','Num of Feature Before FS','Num of Feature After FS','','','';...
    orginal,after_fs,size(Train,2),length(opt_answer),'','',''};
xlswrite('classifier.xlsx',result);
