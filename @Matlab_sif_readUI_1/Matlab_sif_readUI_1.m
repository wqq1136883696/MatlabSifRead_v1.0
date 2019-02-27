classdef Matlab_sif_readUI_1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        SifFileRead               matlab.ui.Figure
        FileMenu                  matlab.ui.container.Menu
        OpenFileMenu              matlab.ui.container.Menu
        OpenFolderMenu            matlab.ui.container.Menu
        ShowFileinListBoxMenu     matlab.ui.container.Menu
        SaveMenu                  matlab.ui.container.Menu
        ExportMenu                matlab.ui.container.Menu
        ExitMenu                  matlab.ui.container.Menu
        FigureMenu                matlab.ui.container.Menu
        Menu                      matlab.ui.container.Menu
        ShowAllFigureMenu         matlab.ui.container.Menu
        TabGroup                  matlab.ui.container.TabGroup
        MainTab                   matlab.ui.container.Tab
        XButton                   matlab.ui.control.Button
        FilefolderEditFieldLabel  matlab.ui.control.Label
        FilefolderEditField       matlab.ui.control.EditField
        Button_2                  matlab.ui.control.Button
        Button_3                  matlab.ui.control.Button
        Button                    matlab.ui.control.Button
        Panel                     matlab.ui.container.Panel
        UIAxes                    matlab.ui.control.UIAxes
        Button_4                  matlab.ui.control.Button
        Button_5                  matlab.ui.control.Button
        FileListBoxLabel          matlab.ui.control.Label
        FileListBox               matlab.ui.control.ListBox
        Button_6                  matlab.ui.control.Button
        SetPanel                  matlab.ui.container.Panel
        TabGroup2                 matlab.ui.container.TabGroup
        AxisTab                   matlab.ui.container.Tab
        XminSpinnerLabel          matlab.ui.control.Label
        XminSpinner               matlab.ui.control.Spinner
        XmaxSpinnerLabel          matlab.ui.control.Label
        XmaxSpinner               matlab.ui.control.Spinner
        YminSpinnerLabel          matlab.ui.control.Label
        YminSpinner               matlab.ui.control.Spinner
        YmaxSpinnerLabel          matlab.ui.control.Label
        YmaxSpinner               matlab.ui.control.Spinner
        LineTab                   matlab.ui.container.Tab
        ColorDropDownLabel        matlab.ui.control.Label
        ColorDropDown             matlab.ui.control.DropDown
        OkButton                  matlab.ui.control.Button
        ApplyButton               matlab.ui.control.Button
        Tab2                      matlab.ui.container.Tab
    end


    properties (Access = private)
        % CopySetPanel  %     复制的最初使的设置值
      
        Xmin    %   X坐标轴最小值
        Xmax    %   X坐标轴最大值
        Ymin    %   Y坐标轴最小值
        Ymax    %   Y坐标轴最大值
    end

    methods (Access = private)
        
        % 画信号的图像
        function singlePlot(app,calibvals,data,xtype,xunit,ytype,yunit)
            y_max = max(data);
            size = length(calibvals);
            app.UIAxes.XLim = [calibvals(1) calibvals(size)];
            app.UIAxes.YLim = [0 y_max*1.05];
            plot(app.UIAxes,calibvals,data);
            title(app.UIAxes,'spectrum','fontsize',14);
            xlabel(app.UIAxes,{xtype;xunit});
            ylabel(app.UIAxes,{ytype;yunit});
            app.UIAxes.YAxis.Direction = 'normal';
            
        end
    
        % 显示image模式的图像
        function imageShow(app,data,xtype,ytype)
            data = data';
            app.UIAxes.XLim = [0 1024];
            app.UIAxes.YLim = [0 256];
            imagesc(app.UIAxes,data);
            title(app.UIAxes,'Image');
            xlabel(app.UIAxes,{xtype});
            ylabel(app.UIAxes,{ytype});
            %colorbar(app.UIAxes);
        end
    
        % 获取原始的数据
        function [pattern,calibvals,data,xtype,xunit,ytype,yunit] = getOrignalData(app)
             % 获取选中的列表的值
            value = app.FileListBox.Value;
            
            % 获取输入框中的内容
            fileFolder = app.FilefolderEditField.get();
            filePath = fullfile(fileFolder.Value,value);
            
            % 获取原始数据
            [pattern,calibvals,data,xtype,xunit,ytype,yunit] = MatlabUI_sif_show(filePath);
        end
    

        
        % 保存sif数据成为图片
        function saveSifToJpg(app,fig)
            [f,p]=uiputfile({'*.jpg';'*.png';'*.pdf'},'保存文件');
            if(length(f) > 1)
                str=strcat(p,f);
                if(contains(f,'.jpg'))
                    print(fig,str,'-djpeg')
                elseif(contains(f,'.png'))
                    print(fig,str,'-dpng')
                elseif(contains(f,'.pdf'))
                    print(fig,str,'-dpdf')
                end
            end
        end
    
    end


    methods (Access = private)

        % Callback function: Button_3, ShowAllFigureMenu
        function ShowAllImageButtonPushed(app, event)
            %   显示全部图像
       
            % 获取输入框中的文件夹路径
            fileFolder = app.FilefolderEditField.get();
            Matlab_sif_read(fileFolder.Value)
        end

        % Callback function: Button_2, ShowFileinListBoxMenu
        function ShowSifListButtonPushed(app, event)
            % show sif list
            % 显示文件列表
           
            % 获取输入框中的内容
            fileFolder = app.FilefolderEditField.get();
            
            % 读取sif文件列表，添加到列表中
            [fileNames,size] = MatlabUI_sif_file_list_read(fileFolder.Value);
            app.FileListBox.set('Items',fileNames);
            
            % 如果只有一个文件，则直接显示图像
            if(size == 1)
                app.FileListBoxValueChanged()
            end
        end

        % Value changed function: FileListBox
        function FileListBoxValueChanged(app, event)
            % show image
            % 显示所选文件的图像

            % 获取原始数据
            [pattern,calibvals,data,xtype,xunit,ytype,yunit] = app.getOrignalData();
            
            % 判断数据类型，然后显示出来； pattern=0为信号模式，pattern=4为图像模式
            if(pattern == '0')
                singlePlot(app,calibvals,data,xtype,xunit,ytype,yunit);            
            elseif(pattern == '4')
                app.imageShow(data,xtype,ytype);
            end
        end

        % Button pushed function: XButton
        function XButtonPushed(app, event)
            %删除输入框内容
            app.FilefolderEditField.set('Value','');
        end

        % Callback function: Button, OpenFolderMenu
        function BrowseButtonPushed(app, event)
            % Browse
            % 选择打开的文件夹
            
            uiFileFolder = uigetdir();
            if(uiFileFolder)
                app.FilefolderEditField.set('Value',uiFileFolder);
            end
        end

        % Callback function: Button_4, SaveMenu
        function SaveAxesImageButtonPushed(app, event)
            % Save
            % 画图保存成jpg图片格式
            
            fig = figure;
            % 获取原始数据
            [pattern,calibvals,data,xtype,xunit,ytype,yunit] = app.getOrignalData();
            
            % 判断数据类型，然后显示出来； pattern=0为信号模式，pattern=4为图像模式
            if(pattern == '0')
                plot(calibvals,data);
                title('spectrum');
                xlabel({xtype;xunit});
                ylabel({ytype;yunit});
                grid on;
                disp([app.Xmin app.Xmax app.Ymin app.Ymax]);
                if(app.Xmin < app.Xmax)
                    xlim([app.Xmin app.Xmax]);
                end
                if(app.Ymin < app.Ymax)
                    ylim([app.Ymin app.Ymax]);
                end
                  
            elseif(pattern == '4')
                app.imageShow(data,xtype,ytype);
            end
            
            % 保存文件
           app.saveSifToJpg(fig);
        end

        % Button pushed function: Button_5
        function SetButtonPushed(app, event)
            % Set 设置
            app.SetPanel.Visible = 'on';
        end

        % Button pushed function: OkButton
        function OkButtonPushed(app, event)
            % Ok
            app.SetPanel.Visible = 'off';
        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            % 应用改变
            app.Xmin = app.XminSpinner.Value;
            app.Xmax = app.XmaxSpinner.Value;
            app.Ymin = app.YminSpinner.Value;
            app.Ymax = app.YmaxSpinner.Value;
            disp([app.Xmin app.Xmax app.Ymin app.Ymax]);
            if(app.Xmin < app.Xmax)
                app.UIAxes.XLim = [app.Xmin app.Xmax];
            end
            if(app.Ymin < app.Ymax)
                app.UIAxes.YLim = [app.Ymin app.Ymax];
            end
        end

        % Callback function: Button_6, ExportMenu
        function ExportButtonPushed(app, event)
            % 获取原始数据
            
            % 获取输入框中的内容
            fileFolder = app.FilefolderEditField.get();
            % 读取sif文件列表，添加到列表中
            [fileNames,size] = MatlabUI_sif_file_list_read(fileFolder.Value);
            
            for i = 1:size
                % 分割文件名
                S = regexp(fileNames(i), '\.', 'split')
                % 组合成一个新的文件名
              
                name = strcat(char(S{1}(1)),'.asc')
                               
                % 完整的输出文件夹的路径
                OutfileName = fullfile(fileFolder.Value,name);
                
                % 获取原始数据
                filePath = fullfile(fileFolder.Value,char(fileNames(i)));
                [pattern,calibvals,data,~,~,~,~] = MatlabUI_sif_show(filePath);
                
                if(pattern == '0')
                    WriteData(:,1) = calibvals;
                    WriteData(:,2) = data;
                    dlmwrite(OutfileName,WriteData,'delimiter','\t')
                elseif(pattern == '4')
                    dlmwrite(OutfileName,data,'delimiter','\t')
                end
            end
        end

        % Menu selected function: OpenFileMenu
        function OpenFileMenuSelected(app, event)
            [file,path] = uigetfile('*.sif');
            if(length(file)>1)
                filePath = fullfile(path,file);            
                %   获取原始数据
                [pattern,calibvals,data,xtype,xunit,ytype,yunit] = MatlabUI_sif_show(filePath);
                
                % 判断数据类型，然后显示出来； pattern=0为信号模式，pattern=4为图像模式
                if(pattern == '0')
                    singlePlot(app,calibvals,data,xtype,xunit,ytype,yunit);            
                elseif(pattern == '4')
                    app.imageShow(data,xtype,ytype);
                end
                % 设置列表的值
                app.FileListBox.set('Items',string(file));
                app.FilefolderEditField.set('Value',string(path));
            end
        end

        % Menu selected function: ExitMenu
        function ExitMenuSelected(app, event)
            app.delete();
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create SifFileRead
            app.SifFileRead = uifigure;
            app.SifFileRead.Position = [100 100 745 534];
            app.SifFileRead.Name = 'Sif_File_Read';

            % Create FileMenu
            app.FileMenu = uimenu(app.SifFileRead);
            app.FileMenu.Text = 'File';

            % Create OpenFileMenu
            app.OpenFileMenu = uimenu(app.FileMenu);
            app.OpenFileMenu.MenuSelectedFcn = createCallbackFcn(app, @OpenFileMenuSelected, true);
            app.OpenFileMenu.Accelerator = 'D';
            app.OpenFileMenu.Text = 'Open File';

            % Create OpenFolderMenu
            app.OpenFolderMenu = uimenu(app.FileMenu);
            app.OpenFolderMenu.MenuSelectedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.OpenFolderMenu.Accelerator = 'F';
            app.OpenFolderMenu.Text = 'Open Folder';

            % Create ShowFileinListBoxMenu
            app.ShowFileinListBoxMenu = uimenu(app.FileMenu);
            app.ShowFileinListBoxMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowSifListButtonPushed, true);
            app.ShowFileinListBoxMenu.Accelerator = 'W';
            app.ShowFileinListBoxMenu.Text = 'Show File in ListBox';

            % Create SaveMenu
            app.SaveMenu = uimenu(app.FileMenu);
            app.SaveMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveAxesImageButtonPushed, true);
            app.SaveMenu.Separator = 'on';
            app.SaveMenu.Accelerator = 'S';
            app.SaveMenu.Text = 'Save';

            % Create ExportMenu
            app.ExportMenu = uimenu(app.FileMenu);
            app.ExportMenu.MenuSelectedFcn = createCallbackFcn(app, @ExportButtonPushed, true);
            app.ExportMenu.Separator = 'on';
            app.ExportMenu.Accelerator = 'E';
            app.ExportMenu.Text = 'Export';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.FileMenu);
            app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            app.ExitMenu.Separator = 'on';
            app.ExitMenu.Text = 'Exit';

            % Create FigureMenu
            app.FigureMenu = uimenu(app.SifFileRead);
            app.FigureMenu.Text = 'Figure';

            % Create Menu
            app.Menu = uimenu(app.FigureMenu);
            app.Menu.Text = 'Menu';

            % Create ShowAllFigureMenu
            app.ShowAllFigureMenu = uimenu(app.FigureMenu);
            app.ShowAllFigureMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowAllImageButtonPushed, true);
            app.ShowAllFigureMenu.Text = 'Show All Figure';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.SifFileRead);
            app.TabGroup.Position = [1 5 745 530];

            % Create MainTab
            app.MainTab = uitab(app.TabGroup);
            app.MainTab.Title = 'Main';

            % Create XButton
            app.XButton = uibutton(app.MainTab, 'push');
            app.XButton.ButtonPushedFcn = createCallbackFcn(app, @XButtonPushed, true);
            app.XButton.BackgroundColor = [0.902 0.902 0.902];
            app.XButton.Position = [409 462 25 22];
            app.XButton.Text = 'X';

            % Create FilefolderEditFieldLabel
            app.FilefolderEditFieldLabel = uilabel(app.MainTab);
            app.FilefolderEditFieldLabel.BackgroundColor = [0.902 0.902 0.902];
            app.FilefolderEditFieldLabel.HorizontalAlignment = 'right';
            app.FilefolderEditFieldLabel.FontSize = 16;
            app.FilefolderEditFieldLabel.Position = [31 463 71 22];
            app.FilefolderEditFieldLabel.Text = 'Filefolder';

            % Create FilefolderEditField
            app.FilefolderEditField = uieditfield(app.MainTab, 'text');
            app.FilefolderEditField.FontSize = 16;
            app.FilefolderEditField.BackgroundColor = [0.902 0.902 0.902];
            app.FilefolderEditField.Position = [117 461 294 23];

            % Create Button_2
            app.Button_2 = uibutton(app.MainTab, 'push');
            app.Button_2.ButtonPushedFcn = createCallbackFcn(app, @ShowSifListButtonPushed, true);
            app.Button_2.Icon = 'icon_state_play.png';
            app.Button_2.FontSize = 16;
            app.Button_2.Position = [490 461 40 26];
            app.Button_2.Text = '';

            % Create Button_3
            app.Button_3 = uibutton(app.MainTab, 'push');
            app.Button_3.ButtonPushedFcn = createCallbackFcn(app, @ShowAllImageButtonPushed, true);
            app.Button_3.Icon = 'FrequencyDomainAxes_24.png';
            app.Button_3.FontSize = 16;
            app.Button_3.Position = [540 461 40 26];
            app.Button_3.Text = '';

            % Create Button
            app.Button = uibutton(app.MainTab, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.Button.Icon = 'icon_folder_open.png';
            app.Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Button.FontSize = 16;
            app.Button.Position = [440 460 40 26];
            app.Button.Text = '';

            % Create Panel
            app.Panel = uipanel(app.MainTab);
            app.Panel.FontSize = 14;
            app.Panel.Position = [161 0 583 457];

            % Create UIAxes
            app.UIAxes = uiaxes(app.Panel);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.MinorGridAlpha = 0.15;
            app.UIAxes.Box = 'on';
            app.UIAxes.BoxStyle = 'full';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.XMinorGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.YMinorGrid = 'on';
            app.UIAxes.TitleFontWeight = 'bold';
            app.UIAxes.Position = [21 6 560 430];

            % Create Button_4
            app.Button_4 = uibutton(app.Panel, 'push');
            app.Button_4.ButtonPushedFcn = createCallbackFcn(app, @SaveAxesImageButtonPushed, true);
            app.Button_4.Icon = 'Save.png';
            app.Button_4.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Button_4.FontSize = 14;
            app.Button_4.Position = [9 422 54 32];
            app.Button_4.Text = '';

            % Create Button_5
            app.Button_5 = uibutton(app.Panel, 'push');
            app.Button_5.ButtonPushedFcn = createCallbackFcn(app, @SetButtonPushed, true);
            app.Button_5.Icon = 'gear_24.png';
            app.Button_5.IconAlignment = 'top';
            app.Button_5.FontSize = 14;
            app.Button_5.Position = [76 422 54 32];
            app.Button_5.Text = '';

            % Create FileListBoxLabel
            app.FileListBoxLabel = uilabel(app.MainTab);
            app.FileListBoxLabel.HorizontalAlignment = 'right';
            app.FileListBoxLabel.FontSize = 16;
            app.FileListBoxLabel.Position = [11 432 31 22];
            app.FileListBoxLabel.Text = 'File';

            % Create FileListBox
            app.FileListBox = uilistbox(app.MainTab);
            app.FileListBox.Items = {''};
            app.FileListBox.ValueChangedFcn = createCallbackFcn(app, @FileListBoxValueChanged, true);
            app.FileListBox.FontSize = 16;
            app.FileListBox.Position = [57 6 100 450];
            app.FileListBox.Value = '';

            % Create Button_6
            app.Button_6 = uibutton(app.MainTab, 'push');
            app.Button_6.ButtonPushedFcn = createCallbackFcn(app, @ExportButtonPushed, true);
            app.Button_6.Icon = 'Export_16.png';
            app.Button_6.FontSize = 14;
            app.Button_6.Position = [590 461 40 26];
            app.Button_6.Text = '';

            % Create SetPanel
            app.SetPanel = uipanel(app.MainTab);
            app.SetPanel.Title = 'Set';
            app.SetPanel.Visible = 'off';
            app.SetPanel.FontSize = 14;
            app.SetPanel.Position = [277 323 303 183];

            % Create TabGroup2
            app.TabGroup2 = uitabgroup(app.SetPanel);
            app.TabGroup2.Position = [1 39 302 122];

            % Create AxisTab
            app.AxisTab = uitab(app.TabGroup2);
            app.AxisTab.Title = 'Axis';

            % Create XminSpinnerLabel
            app.XminSpinnerLabel = uilabel(app.AxisTab);
            app.XminSpinnerLabel.HorizontalAlignment = 'center';
            app.XminSpinnerLabel.Position = [23 61 36 22];
            app.XminSpinnerLabel.Text = 'Xmin';

            % Create XminSpinner
            app.XminSpinner = uispinner(app.AxisTab);
            app.XminSpinner.FontSize = 16;
            app.XminSpinner.Position = [67 61 55 22];

            % Create XmaxSpinnerLabel
            app.XmaxSpinnerLabel = uilabel(app.AxisTab);
            app.XmaxSpinnerLabel.HorizontalAlignment = 'center';
            app.XmaxSpinnerLabel.Position = [167 61 36 22];
            app.XmaxSpinnerLabel.Text = 'Xmax';

            % Create XmaxSpinner
            app.XmaxSpinner = uispinner(app.AxisTab);
            app.XmaxSpinner.FontSize = 16;
            app.XmaxSpinner.Position = [218 61 55 22];

            % Create YminSpinnerLabel
            app.YminSpinnerLabel = uilabel(app.AxisTab);
            app.YminSpinnerLabel.HorizontalAlignment = 'center';
            app.YminSpinnerLabel.Position = [23 16 36 22];
            app.YminSpinnerLabel.Text = 'Ymin';

            % Create YminSpinner
            app.YminSpinner = uispinner(app.AxisTab);
            app.YminSpinner.FontSize = 16;
            app.YminSpinner.Position = [67 16 55 22];

            % Create YmaxSpinnerLabel
            app.YmaxSpinnerLabel = uilabel(app.AxisTab);
            app.YmaxSpinnerLabel.HorizontalAlignment = 'center';
            app.YmaxSpinnerLabel.Position = [167 16 36 22];
            app.YmaxSpinnerLabel.Text = 'Ymax';

            % Create YmaxSpinner
            app.YmaxSpinner = uispinner(app.AxisTab);
            app.YmaxSpinner.FontSize = 16;
            app.YmaxSpinner.Position = [218 16 55 22];

            % Create LineTab
            app.LineTab = uitab(app.TabGroup2);
            app.LineTab.Title = 'Line';

            % Create ColorDropDownLabel
            app.ColorDropDownLabel = uilabel(app.LineTab);
            app.ColorDropDownLabel.HorizontalAlignment = 'right';
            app.ColorDropDownLabel.FontSize = 14;
            app.ColorDropDownLabel.Position = [31 56 39 22];
            app.ColorDropDownLabel.Text = 'Color';

            % Create ColorDropDown
            app.ColorDropDown = uidropdown(app.LineTab);
            app.ColorDropDown.Items = {'red', 'yellow', 'green', 'cyan', 'blue', 'magenta', 'white', 'black'};
            app.ColorDropDown.FontSize = 14;
            app.ColorDropDown.Position = [90 56 80 22];
            app.ColorDropDown.Value = 'blue';

            % Create OkButton
            app.OkButton = uibutton(app.SetPanel, 'push');
            app.OkButton.ButtonPushedFcn = createCallbackFcn(app, @OkButtonPushed, true);
            app.OkButton.FontSize = 16;
            app.OkButton.Position = [159 8 63 26];
            app.OkButton.Text = 'Ok';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.SetPanel, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.FontSize = 16;
            app.ApplyButton.Position = [89 8 63 26];
            app.ApplyButton.Text = 'Apply';

            % Create Tab2
            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Title = 'Tab2';
        end
    end

    methods (Access = public)

        % Construct app
        function app = Matlab_sif_readUI_1

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.SifFileRead)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.SifFileRead)
        end
    end
end