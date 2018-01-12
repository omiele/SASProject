/*----------------------------------------------*/
  /*      Macro One way anova                 */
  /*----------------------------------------------*/

%Macro oneway(TransVar, ClassVar); 
Proc GLM Data=WORK.merged_data2;
Class &ClassVar;
Var &TransVar;
title "One-Way ANOVA";
Model &TransVar = &ClassVar;
means &ClassVar / hovtest=levene welch plots=none;
lsmeans &ClassVar / adjust=tukey pdiff alpha=.05; 
Run;
%Mend oneway;

/* Ethinicity as independent */
%oneway(emotionality, ethnicity);

/* Income as independent */
%oneway(emotionality, income);

/* Child support as independent */
%oneway(emotionality, child_support);