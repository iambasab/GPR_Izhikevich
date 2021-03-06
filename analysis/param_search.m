% Exploring parameter space

% Specify your parameter mapping in this line - the names you gave
% your Izhy parameters in your SpineCreator component.
% In this order: 'a', 'b', 'c', 'd', 'Cap', 'Vreset', 'Vthresh', 'k', 'Vpeak'
codeIzhyParams = {'a', 'b', 'c', 'd', 'Cap', 'vr', 'vt', 'k', 'Vpeak'};
% ** Change this line to suit your model **
myIzhyParams   = {'a', 'b', 'c', 'd', 'C',   'Vr', 'Vt', 'k', 'Vpeak'};
paramMapping = containers.Map (codeIzhyParams, myIzhyParams);

% List your state variable names, including the injected current
% (that'll be a component port rather than a component state variable).
codeIzhyStateVars = {'v', 'u', 'I'};
% ** Change this line to suit your model **
myIzhyStateVars   = {'v', 'u', 'I'};
statevarMapping = containers.Map (codeIzhyStateVars, myIzhyStateVars);

% Your preferred quiver plot params. These are: scale, increment,
% plot_scale_divisor. Try [ 10, 0.5, 5 ]. Increase scale to show
% more of the trajectory.
quivParamNames = {'qvscale', 'qvinc', 'qvdivisor'};
% ** Change this line to suit your output **
quivParamVals = [ 20, 0.5, 5 ];
quiverParams = containers.Map (quivParamNames, quivParamVals);


% Calls phaseplane_izhy with the specified location, expt, population
% name and param mapping
%** Change this line to suit your model location, experiment, population etc. **
rates=[];
e = 9; % Choose single expt. 5 has injection current 65, 9 has 90.
cur_param = 'a';
for i = 0:17

    cur_param_val = (i-4).* 0.01;

    display(['Crunching experiment' num2str(e) '.xml']);
    spinemlcmd = ['pushd /home/seb/src/SpineML_2_BRAHMS && ./convert_script_s2b -m ~/abrg2/abrg_local/' ...
                  'IzhiBG/SimpleIzhi -e' num2str(e) ' -pSebtest1:' cur_param ':' ...
                  num2str(cur_param_val) '; popd'];
    system(spinemlcmd);
    rate = phaseplane_izhi ('/home/seb/src/SpineML_2_BRAHMS/temp', ['experiment' num2str(e) '.xml'], 'Sebtest1', ...
                            paramMapping, statevarMapping, quiverParams, ...
                            1);
    rates = [rates; cur_param_val , rate];
    pause(2)
end

figure(35);
subplot (2,1,1);
plot (rates(:,1), rates(:,2), 'o-');
xlabel(['Param ' cur_param]);
ylabel('Firing rate /s');
subplot (2,1,2);
drates = diff(rates(:,2));
drates = [drates; 0]./rates(:,1);
plot (rates(:,1), drates, 'o-r');
xlabel(['Param ' cur_param]);
ylabel(['delta firing rate/delta ' cur_param]);
